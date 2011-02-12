module Sunspot
  module FieldFactory
    
    class Attachment
      def initialize(name = nil, &block)
        if block
          @data_extractor = DataExtractor::BlockExtractor.new(&block)
        else
          @data_extractor = DataExtractor::AttributeExtractor.new(name)
        end
      end

      def populate_document(document, model)
      end
    end
    
  end
end