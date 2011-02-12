module Sunspot
  class Indexer
    
    def add_documents(documents)
      documents_arr = Util.Array(documents)
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
        Util.Array(docs_attach).each do |document|
          document.add(@connection)
        end
      end
    end    
    
    
    def document_for(model)
      Sunspot::RichDocument.new(
        :id => Adapters::InstanceAdapter.adapt(model).index_id,
        :type => Util.superclasses_for(model.class).map { |clazz| clazz.name }
      )
    end
    
  end
end