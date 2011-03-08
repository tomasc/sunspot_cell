module SunspotCell
  module Indexer

    def self.included(base)
      base.class_eval do

        def add_documents(documents)
          documents_arr = Sunspot::Util.Array(documents)
          docs_attach = []
          docs_no_attach = []
          documents_arr.each do |document|
            if document.contains_attachment?
              docs_attach << document
            else
              docs_no_attach << document
            end
          end

          unless docs_no_attach.empty?
            @connection.add(docs_no_attach)
          else
            Sunspot::Util.Array(docs_attach).each do |document|
              document.add(@connection)
            end
          end
        end


        def document_for(model)
          Sunspot::RichDocument.new(
            :id => Sunspot::Adapters::InstanceAdapter.adapt(model).index_id,
            :type => Sunspot::Util.superclasses_for(model.class).map { |clazz| clazz.name }
          )
        end

      end
    end
  end
end