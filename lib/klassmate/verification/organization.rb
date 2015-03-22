module Klassmate
  module Verification
    module Organization
      def self.included(mod)
        # Include adapters according to parent model
        if mod.respond_to? :property
          # DataMapper
          mod.property :verifier, String
        end
      end
    end
  end
end
