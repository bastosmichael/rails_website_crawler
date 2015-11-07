class Record::Addons
  def self.insert hash
    if addons = Rails.configuration.config[:admin][:addons][hash[:container].try(:to_sym)]
      addons.each do |key, value|
        hash[key] = hash[key] + value if hash[key]
      end
    end
    return hash
  end
end
