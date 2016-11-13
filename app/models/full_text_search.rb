require 'elasticsearch/model'

class FullTextSearch < ActiveRecord::Base

  include Elasticsearch::Model

  cluster_url = Rails.application.config.cluster_url
  cluster_index = Rails.application.config.cluster_index
  cluster_type = Rails.application.config.cluster_type
  client = Elasticsearch::Client.new url: cluster_url, log: false

  FullTextSearch.__elasticsearch__.client = client
  index_name cluster_index
  document_type cluster_type

end
