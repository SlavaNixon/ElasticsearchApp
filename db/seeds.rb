puts "Deleting all articles..."
Article.delete_all

puts "Creating articles..."
50.times{ |i| Article.create(name: "Name#{i}", author: "Author#{i}", content: "Content#{i}") }
