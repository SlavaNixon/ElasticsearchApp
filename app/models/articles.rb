# frozen_string_literal: true

require 'will_paginate/array'

class Articles
  include ActiveModel::Model
  include Es

  WillPaginate.per_page = 3

  attr_reader :articles

  def self.search(query)
    parse_records(Es.client.search(index: INDEX_NAME, q: query))
  end

  def self.parse_records(articles)
      articles.dig('hits', 'hits').map do |article|
      params = article['_source'].slice('id', 'author', 'name', 'content', 'created_at')
      Article.new_from_params(params)
    end
  end

  def initialize
    client.indices.create index: INDEX_NAME unless client.indices.exists?(index: INDEX_NAME)
    articles = client.search index: INDEX_NAME, size: 1000
    @articles = Articles.parse_records(articles)
  end

  def find(id)
    @articles.find { |article| article.id == Integer(id) } if ids.include?(Integer(id))
  rescue
    # Ignored
  end

  def ids
    @articles.map(&:id) if @articles.present?
  end

  def next_id
    ids.max + 1
  rescue
    0
  end
end
