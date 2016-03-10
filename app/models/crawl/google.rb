class Crawl::Google
  include ActionView::Helpers::DateHelper

  def initialize(query = nil)
    @query = query
  end

  def videos
    @videos ||= Rails.cache.fetch("#{@query}/google_videos", expires_in: 7.days) do
      if google_hash = Google::Search::Video.new(query: @query).response.hash['responseData']
        google_hash['results'].map do |hash|
          {
            title: hash['titleNoFormatting'],
            description: ActionView::Base.full_sanitizer.sanitize(hash['content']),
            image: hash['tbUrl'],
            url: hash['url'],
            length: distance_of_time_in_words(hash['duration'].to_i),
            published: hash['published'].to_date.to_s
          }
        end
      else
        nil
      end
    end
  end

  def news
    @news ||= Rails.cache.fetch("#{@query}/google_news", expires_in: 7.days) do
      if google_hash = Google::Search::News.new(query: @query).response.hash['responseData']
        google_hash['results'].map do |hash|
          image = hash['image']['tbUrl'] if hash['image']
          if related = hash['relatedStories']
            related = related.map do |h|
              {
                title: h['titleNoFormatting'],
                url: h['unescapedUrl'],
                publisher: h['publisher'],
                published: h['publishedDate'].to_date.to_s,
                language: hash['language']
              }
            end
          end
          {
            title: hash['titleNoFormatting'],
            description: ActionView::Base.full_sanitizer.sanitize(hash['content']),
            image: image,
            url: hash['unescapedUrl'],
            publisher: hash['publisher'],
            published: hash['publishedDate'].to_date.to_s,
            language: hash['language'],
            related: related || []
          }
        end
      else
        nil
      end
    end
  end

  def references
    @references ||= Rails.cache.fetch("#{@query}/google_references", expires_in: 7.days) do
      if google_hash = Google::Search::Book.new(query: @query).response.hash['responseData']
        google_hash['results'].map do |hash|
          description = "by #{hash['authors']} ISBN: #{hash['bookId']}"

          image = hash['tbUrl'] unless hash['tbUrl'] == "/googlebooks/images/no_cover_thumb.gif"

          {
            title: hash['titleNoFormatting'],
            description: description,
            image: image,
            url: hash['unescapedUrl'],
            length: hash['pageCount'] + ' pages',
            published: hash['publishedYear']
          }
        end
      else
        nil
      end
    end
  end

  def links
    @links ||= Rails.cache.fetch("#{@query}/google_links", expires_in: 7.days) do
      if google_hash = Google::Search::Web.new(query: @query).response.hash['responseData']
        google_hash['results'].map do |hash|
          {
            title: hash['titleNoFormatting'],
            description: ActionView::Base.full_sanitizer.sanitize(hash['content']),
            url: hash['unescapedUrl']
          }
        end
      else
        nil
      end
    end
  end
end
