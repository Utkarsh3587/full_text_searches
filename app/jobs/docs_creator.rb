require 'elasticsearch'
require 'logger'

class DocsCreator

  MAX_PAYLOAD_SIZE = 5000
  MAX_REPEAT_CYCLE = 600 # total number of docs are 3 million
  LOGGER = Logger.new(STDOUT)
  LOGGER.level = Logger::DEBUG

  def insert_docs
    cluster_url = Rails.application.config.cluster_url
    cluster_index = Rails.application.config.cluster_index
    cluster_type = Rails.application.config.cluster_type

    client = Elasticsearch::Client.new url: cluster_url, log: true

    record_id = 775000
    MAX_REPEAT_CYCLE.times do |i|
      docs = []
      LOGGER.debug { "Batch started #{i+1}" }
      MAX_PAYLOAD_SIZE.times do ||
        record_id += 1
        docs.push %Q{{ "create" : { "_index" : "#{cluster_index}", "_type" : "#{cluster_type}", "_id" : "#{record_id}" } }}
        doc = {}
        doc[:first_name] = Faker::Name.first_name
        doc[:last_name] = Faker::Name.last_name
        doc[:email] = Faker::Internet.email(doc[:first_name] + '.' + doc[:last_name])
        doc[:address] = Faker::Address.street_address + ', ' + Faker::Address.city + ', ' +
            Faker::Address.state + ', ' + Faker::Address.country + ', ' + Faker::Address.zip
        doc[:profile_url] = Faker::Internet.url
        doc[:avatar] = Faker::Avatar.image
        doc[:bday] = Faker::Date.birthday(min_age = 18, max_age = 65)
        doc[:fav_color] = Faker::Color.color_name
        doc[:contact_number] = Faker::PhoneNumber.cell_phone.to_s
        doc[:created_at] = DateTime.now.strftime('%Y-%m-%dT%H:%M:%S')
        docs.push %Q{#{doc.to_json}}
      end
      LOGGER.debug { "Batch finished #{i+1}" }
      client.bulk body: docs.join("\n").concat("\n")
    end


  end
end