puts "Deleting all articles..."
client = Elasticsearch::Client.new()
client.indices.delete index: 'articles' if client.indices.exists?(index: 'articles')

puts "Creating articles..."
50.times do |id|
  Article.new(id, "Name#{id}", "Author#{id}", "Content#{id}", "01.08.20#{id + 10}").create
end
