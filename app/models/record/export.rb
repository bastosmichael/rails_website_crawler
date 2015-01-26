class Record::Export
  def initialize(container, headers = { 'name' => nil, 'url' => nil })
    @container = container
    @headers = headers
    process_master_hash
  end

  def csv
    require 'csv'
    rowid = -1
    CSV.open('test.csv', 'w') do |csv|
      master_hash.values.each do |hsh|
        rowid += 1
        if rowid == 0
          csv << ['id'] + @headers.keys # adding header row (column labels)
        else
          csv << hsh.values
        end # of if/else inside hsh
      end # of hsh's (rows)
    end # of csv open
  end

  def master_hash
    @master_hash ||= {}
  end

  def process_master_hash
    @headers.each do |header, _value|
      hash = record('_' + header.pluralize + '.json').data
      hash.each do |k, v|
        if master_hash.keys.include?(k)
          master_hash[k][header] = v
        else
          master_hash[k] = { 'id' => k }.merge(@headers)
          master_hash[k][header] = v
        end
      end
    end
  end

  def cloud
    @cloud ||= Cloud.new(@container)
  end

  def indexes
    @records ||= cloud.files.select { |f| f if f.key.starts_with? '_' }
  end

  def record(record)
    Record::Base.new(@container, record)
  end
end
