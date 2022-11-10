# frozen_string_literal: true

class Article
  include ActiveModel::Model
  include Es

  attr_accessor :id, :name, :author, :content, :created_at

  def body
    { id: @id, name: @name, author: @author, content: @content, created_at: @created_at }.as_json
  end

  def self.new_from_params(params)
    id = params['id']
    name = params['name']
    author = params['author']
    content = params['content']
    created_at = params['created_at'].to_time
    new(id, name, author, content, created_at)
  end

  def initialize(id, name, author, content, created_at)
    @id = id
    @name = name
    @author = author
    @content = content
    @created_at = created_at.to_time
  end

  def create
    client.create(index: INDEX_NAME, id: @id, body:)
  end

  def update
    client.update(index: INDEX_NAME, id: @id, body: { doc: body }.as_json)
  end
end
