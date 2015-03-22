module Klassmate
  module Verifier
    module UserAdapters
      module DataMapper
        def self.after_included(mod)
          mod.property :transaction_id, Integer
          mod.validates_uniqueness_of :transaction_id
        end
      end
    end
  end
end
