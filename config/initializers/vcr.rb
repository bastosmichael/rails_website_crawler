VCR.configure { |c|
  c.cassette_library_dir = 'tmp'
  c.hook_into :webmock
  c.cassette_persisters[:local] = Persist.new()
  c.default_cassette_options[:persist_with] = :local
  c.allow_http_connections_when_no_cassette = true }