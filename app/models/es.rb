module Es
  module_function

  def client
    @client ||= Elasticsearch::Client.new
    @client
  end
end