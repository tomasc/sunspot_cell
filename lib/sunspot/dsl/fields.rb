module Sunspot
  module DSL
    class Fields
      
      # Added an attachment field, the attachment filename is passed to Solr for
      # indexing by tiqa

      def attachment(*names)
        names.each do |name|
          @setup.add_attachment_field_factory(name)
        end
      end
      
    end
  end
end