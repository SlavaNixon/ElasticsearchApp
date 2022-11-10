# frozen_string_literal: true

require 'will_paginate/array'

class ArticleCollection
  include ActiveModel::Model
  include Es
  extend Es

  WillPaginate.per_page = 3

  attr_reader :articles

  def self.search(query)
    parse_records(client.search(index: INDEX_NAME, q: query)) if index_exists?
  end

  def self.parse_records(articles)
    articles.dig('hits', 'hits').map do |article|
      params = article['_source'].slice('id', 'author', 'name', 'content', 'created_at')
      Article.new_from_params(params)
    end
  end

  def initialize
    client.indices.create index: INDEX_NAME unless index_exists?
    articles = client.search index: INDEX_NAME, size: 1000
    @articles = ArticleCollection.parse_records(articles)
  end

  def find(id)
    @articles.find { |article| article.id == Integer(id) } if ids.include?(Integer(id))
  rescue StandardError
    # Ignored
  end

  def ids
    @articles.map(&:id) if @articles.present?
  end

  def next_id
    ids.max + 1
  rescue StandardError
    0
  end
end
