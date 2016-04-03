class Api::V1 < Record::Base
  def current_data(options = { crawl: true, social: false })
    return { id: @record, container: @container, error: 'not available' } unless old_data = data
    new_data = { id: nil,
                 container: @container,
                 name: name(old_data),
                 social: {},
                 price:{}
               }

    old_data.each do |k, v|

      if v.is_a?(Hash)
        if k.include?('_shares')
          new_data[:social][k] = sanitize_value(v.values.last)
        elsif k.include?('price')
          new_data[:price][k] = sanitize_value(v.values.last)
        else
          new_data[k] = sanitize_value(v.values.last)
        end
      else
        if k.include?('_shares')
          new_data[:social][k] = sanitize_value(v)
        elsif k.include?('price')
          new_data[:price][k] = sanitize_value(v)
        else
          new_data[k] = sanitize_value(v)
        end
      end
    end if old_data['id']
    recrawl(old_data['url'], options) if old_data['url']
    new_data.deep_symbolize_keys!
  end

  def historical_data(options = { crawl: true, social: false })
    return { id: @record, container: @container, error: 'not available' } unless old_data = data
    new_data = {}
    old_data.each do |k, v|
      if v.is_a?(Hash) && v.count > 1
        new_data[k] = v.merge({Date.today.to_s => v.values.last}).group_by_week {|k,v| k }.map do |k,v|
          if value = v.try(:first).try(:last)
            @last = sanitize_value(value)
          end
          {k.to_date => @last}
        end.inject({},:merge)
      end
    end if old_data['id']
    recrawl(old_data['url'], options) if old_data['url']

    if new_data.empty?
      {
        id: old_data['id'],
        container: @container,
        name: name(old_data),
        error: 'no history available'
      }
    else
      {
        id: old_data['id'],
        container: @container,
        name: name(old_data),
        history: new_data.deep_symbolize_keys!
      }
    end
  end

  def related_data(options = { crawl: true, social: false })
    # return { id: @record, container: @container, error: 'not available' } unless name

    # links = Crawl::Google.new(name).links

    # if links
    #   {
    #     id: @record,
    #     container: @container,
    #     name: name,
    #     links: links
    #   }
    # else
    #   {
    #     id: @record,
    #     container: @container,
    #     name: name,
    #     error: 'no related available'
    #   }
    # end
  end

  def links_data(options = { crawl: true, social: false })
    return { id: @record, container: @container, error: 'not available' } unless name

    links = Crawl::Google.new(name).links

    if links
      {
        id: @record,
        container: @container,
        name: name,
        links: links
      }
    else
      {
        id: @record,
        container: @container,
        name: name,
        error: 'no links available'
      }
    end
  end

  def references_data(options = { crawl: true, social: false })
    return { id: @record, container: @container, error: 'not available' } unless name

    references = Crawl::Google.new(name).references

    if references
      {
        id: @record,
        container: @container,
        name: name,
        references: references
      }
    else
      {
        id: @record,
        container: @container,
        name: name,
        error: 'no references available'
      }
    end
  end

  def news_data(options = { crawl: true, social: false })
    return { id: @record, container: @container, error: 'not available' } unless name

    news = Crawl::Google.new(name).news

    if news
      {
        id: @record,
        container: @container,
        name: name,
        news: news
      }
    else
      {
        id: @record,
        container: @container,
        name: name,
        error: 'no news available'
      }
    end
  end

  def videos_data(options = { crawl: true, social: false })
    return { id: @record, container: @container, error: 'not available' } unless name

    videos = Crawl::Google.new(name).videos

    if videos
      {
        id: @record,
        container: @container,
        name: name,
        videos: videos
      }
    else
      {
        id: @record,
        container: @container,
        name: name,
        error: 'no videos available'
      }
    end
  end
end
