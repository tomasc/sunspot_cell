module SunspotCell
  module DSL
    module Fields

      def self.included(base)
         base.class_eval do
          include InstanceMethods
         end
      end

      module InstanceMethods

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
end