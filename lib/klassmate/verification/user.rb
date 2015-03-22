require 'klassmate/verification/errors'

module Klassmate
  module Verification
    module User
      def self.included(mod)
        mod.extend ClassMethods

        # Include adapters according to parent model
        if mod.respond_to? :property
          # DataMapper
          Klassmate::Verifier::UserAdapters::DataMapper.after_included(mod)
        end
      end

      module ClassMethods
        def verifier_connection
          host = 'http://verifier.klassmate.com:18778/'

          @verifier_connection ||= Faraday.new(:url => host) do |builder|
            builder.use Faraday::Request::UrlEncoded
            builder.use Faraday::Adapter::NetHttp
            builder.use FaradayMiddleware::ParseJson
          end
        end

        def find_or_new_verified_user(options = {})
          organization = options[:organization]

          begin
            rsp = verifier_connection.post "/#{organization.verifier}",
              username: options[:username], password: options[:password]
          rescue Faraday::Error::ConnectionFailed => e
            raise Klassmate::Verification::Errors::VerifierNotAvailable.new
          rescue Faraday::Error::ParsingError => e
            raise Klassmate::Verification::Errors::InternalError.new
          end

          if rsp.status != 200 or !rsp.body['transaction_id']
            raise Klassmate::Verification::Errors::InvalidCredentials.new
          end

          transaction_id = rsp.body['transaction_id']
          user = where(transaction_id: transaction_id).first

          if user
            user
          else
            user = new
            user.username = options[:username]
            user.password = options[:password]
            user.transaction_id = transaction_id

            user
          end
        end
      end
    end
  end
end
