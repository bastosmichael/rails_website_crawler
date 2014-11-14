class Record::Export

  def initialize container
    @container = container
  end

  def csv
    require 'csv'
      keys = []
      all_records = records.with_progress.map do |r|
        data = record(r.key).data
        if id = data['id']
          new_data = data.map do |k, v|
            value = v.is_a?(Hash) ? v.values.last : v
            keys << k.to_sym unless keys.include? k.to_sym
            {k.to_sym => value}
          end.compact.reduce({}, :merge)
        end
      end.compact

      # test = all_records.map do |r|
      #   keys.each do |k|
      #     r[k.to_sym] = '' unless r.keys.include? k.to_sym
      #   end
      #   r.sort
      # end


      # rowid = -1
      # CSV.open('test.csv', 'w') do |csv|
      #   test.each do |hsh|
      #     rowid += 1
      #     if rowid == 0
      #       csv << hsh.keys# adding header row (column labels)
      #     else
      #       csv << hsh.values
      #     end# of if/else inside hsh
      #   end# of hsh's (rows)
      # end# of csv open
  end

  def cloud
    @cloud ||= Cloud.new(@container)
  end

  def records
    @records ||= cloud.files.map { |f| f unless f.key.starts_with? '_' }.compact
  end

  def record(record)
    Record::Base.new(@container, record)
  end
end
