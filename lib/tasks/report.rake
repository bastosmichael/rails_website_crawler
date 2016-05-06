namespace :report do
  desc 'Get List of Api keys'
  task :api_keys do
    Cloud.new('api-keys').files.map(&:key).map { |key| Record::Base.new('api-keys', key.gsub('.json','')).data.merge(api_key: key).symbolize_keys! }
  end
end
