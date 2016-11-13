require 'elasticsearch'

class MappingCreator

  def create_mapping
    cluster_url = Rails.application.config.cluster_url
    cluster_index = Rails.application.config.cluster_index

    client = Elasticsearch::Client.new url: cluster_url, log: false

    client.indices.create index: cluster_index,
                          body: {
                              mappings: {
                                  document: {
                                      properties: {
                                          first_name: {
                                              type: "string"
                                          },
                                          last_name: {
                                              type: "string"
                                          },
                                          email: {
                                              type: "string"
                                          },
                                          address: {
                                              type: "string"
                                          },
                                          company_name: {
                                              type: "string"
                                          },
                                          company_city: {
                                              type: "string"
                                          },
                                          bday: {
                                              type: "date",
                                              format: "dateOptionalTime"
                                          },
                                          profile_url: {
                                              type: "string"
                                          },
                                          avatar: {
                                              type: "string"
                                          },
                                          fav_color: {
                                              type: "string"
                                          },
                                          created_at: {
                                              type: "date",
                                              format: "dateOptionalTime"
                                          }
                                      }
                                  }
                              }
                          }
  end
end