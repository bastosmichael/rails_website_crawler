require 'typhoeus/adapters/faraday'
Elasticsearch::Model.client = Elasticsearch::Client.new(Rails.configuration.config['elasticsearch'].symbolize_keys!)
