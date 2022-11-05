puts "Deleting all articles..."
Article.delete_all
client = Elasticsearch::Client.new()
client.indices.delete index: 'articles' if client.indices.exists?(index: 'articles')

puts "Creating articles..."
50.times{ |i| Article.create(name: "Name#{i}", author: "Author#{i}", content: "Content#{i}") }
