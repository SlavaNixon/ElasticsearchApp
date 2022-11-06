require 'will_paginate/array'

class Articles
  include ActiveModel::Model
  include Es

  WillPaginate.per_page = 3

  attr_reader :articles

  def initialize
    articles = client.search index: 'articles', size: 1000
    @articles = Articles.parse_records(articles)
  end

  def self.search(query)
    parse_records(Es.client.search(index: "articles", q: query))
  end

  def self.parse_records(articles)
    articles.dig('hits', 'hits').map do |article|
      params = article.dig('_source').slice('id', 'author', 'name', 'content', 'created_at')
      Article.new(params['id'], params["name"], params['author'], params["content"], params["created_at"])
    end
  end

  def find(id)
    @articles.find {|article| article.id == id.to_i } if ids.include?(id.to_i)
  end

  def ids
    @articles.map(&:id)
  end

  def next_id
    ids.max + 1
  end
end

