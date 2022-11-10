# frozen_string_literal: true

module Es
  module_function

  INDEX_NAME = 'articles'

  def client
    @client ||= Elasticsearch::Client.new
  end
end
