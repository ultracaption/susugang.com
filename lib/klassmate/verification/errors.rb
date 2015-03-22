module Klassmate
  module Verification
    module Errors
      class VerifierNotAvailable < StandardError; end
      class InternalError < StandardError; end
      class InvalidCredentials < StandardError; end
    end
  end
end
