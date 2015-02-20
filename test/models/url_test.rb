require 'test_helper'

class UrlTest < ActiveSupport::TestCase
  setup do
    assert @url = Page::Url.new('google.com')
    assert @url.date = '2014-08-09'
  end

  test 'cache_key method returns correct cache path' do
    assert_equal @url.cache_key, 'google/google.com/c7b920f57e553df2bb68272f61570210/2014-08-09'
  end

  test 'build_path method returns correct hashed path' do
    assert_equal @url.build_path, 'google/google.com/c7b920f57e553df2bb68272f61570210'
  end

  # TODO
  # test 'uri method returns a URI object' do
  #   pending 'Needs to match a URI object'
  # end

  test 'url method returns correctly formatted internet address' do
    assert_equal @url.url, 'http://google.com'
  end

  test 'md5 method returns correct ' do
    assert path = @url.url
    assert checksum = Digest::MD5.hexdigest(path)
    assert_equal @url.md5, checksum
  end

  test 'host method returns correct host name' do
    assert_equal @url.host, 'google.com'
  end

  test 'name method returns correct site name' do
    assert_equal @url.name, 'google'
  end
end
