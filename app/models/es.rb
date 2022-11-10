# frozen_string_literal: true

module Es
  module_function

  INDEX_NAME = 'articles'

  def client
    @client ||= Elasticsearch::Client.new
  end

  def index_exists?
    client
    @client.indices.exists?(index: INDEX_NAME)
  end
end
