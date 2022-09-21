# frozen_string_literal: true

module CyberSoc
  class Talk
    attr_reader :title, :author, :date

    def initialize(mongo_doc)
      @title = mongo_doc[:title]
      @author = mongo_doc[:author]
      @date = mongo_doc[:date]
    end
  end
end
