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
          options = names.pop if names.last.is_a?(Hash)
          names.each do |name|
            @setup.add_attachment_field_factory(name, options || {})
          end
        end

      end
    end
  end
end