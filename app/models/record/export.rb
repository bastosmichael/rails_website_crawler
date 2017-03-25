class Record::Export
  def initialize(container, headers = ['name', 'url'])
    @container = container
    @headers = headers
  end

  def csv
    require 'csv'
    CSV.open('test.csv', 'w') do |csv|
      indexes.with_progress.each do |index|
        id = index.key.gsub('.json','')
        hash = record(id).current_data({ crawl: false, social: false })
        csv << hash.values
      end # of hsh's (rows)
    end # of csv open
  end

  def cloud
    @cloud ||= Cloud.new(@container)
  end

  def indexes
    @records ||= cloud.files
  end

  def record(record)
    Api::V1.new(@container, record)
  end
end
