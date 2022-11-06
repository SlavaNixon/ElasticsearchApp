class Article
  include ActiveModel::Model
  include Es

  attr_accessor :id, :name, :author, :content, :created_at

  def body
    { id: @id, name: @name, author: @author, content: @content, created_at: @created_at
    }.as_json
  end

  def initialize(id, name, author, content, created_at)
    @id = id
    @name = name
    @author = author
    @content = content
    @created_at = created_at.to_time
  end

  def create
    client.create(index: "articles", id: @id, body: body)
  end

  def update
    client.update(index: "articles", id: @id, body: {doc: body}.as_json)
  end
end
