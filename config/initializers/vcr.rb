VCR.configure { |c|
  c.cassette_library_dir = 'tmp'
  c.hook_into :webmock
  c.cassette_persisters[:new] = Persist.new('vcr')
  c.default_cassette_options[:persist_with] = :new
  c.allow_http_connections_when_no_cassette = true 
}