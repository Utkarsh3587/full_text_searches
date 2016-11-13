
# task to create elastic search db mapping

namespace :indexing do

  task :create_mapping => :environment do |t, args|
    mapping_object = MappingCreator.new
    mapping_object.create_mapping
  end

  task :insert_fake_docs => :environment do |t, args|
    docs_creator_obj = DocsCreator.new
    docs_creator_obj.insert_docs
  end

end