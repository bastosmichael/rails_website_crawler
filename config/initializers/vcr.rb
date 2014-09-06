VCR.configure { |c|
  c.cassette_library_dir = 'tmp/cache'
  c.hook_into :webmock
  c.default_cassette_options = { match_requests_on: [:uri, :body, :method] }
  c.cassette_persisters[:cloud] = Persist.new(Cloud.new('vcr'))
  c.default_cassette_options[:persist_with] = :cloud
  c.allow_http_connections_when_no_cassette = true
}
