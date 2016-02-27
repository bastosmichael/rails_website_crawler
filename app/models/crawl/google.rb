class Crawl::Google
  def initialize(query = nil)
    @query = query
  end

  def videos
    include ActionView::Helpers::DateHelper
    @videos ||= if google_hash = Google::Search::Video.new(query: @query).response.hash['responseData']
                 google_hash['results'].map do |hash|
                   {
                    title: hash['titleNoFormatting'],
                    description: hash['content'],
                    image: hash['tbUrl'],
                    url: hash['url'],
                    length: distance_of_time_in_words(hash['duration'].to_i),
                    published: hash['published'].to_date.to_s
                   }
                 end
               else
                 []
               end
  end

  def news
    @news ||= if google_hash = Google::Search::News.new(query: @query).response.hash['responseData']
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
                    description: hash['content'],
                    image: image,
                    url: hash['unescapedUrl'],
                    publisher: hash['publisher'],
                    published: hash['publishedDate'].to_date.to_s,
                    language: hash['language'],
                    related: related || []
                  }
                end
              else
                []
              end
  end

  def references
    @references ||= if google_hash = Google::Search::Book.new(query: @query).response.hash['responseData']
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
                 []
               end
  end

  def links
    @links ||= if google_hash = Google::Search::Web.new(query: @query).response.hash['responseData']
                 google_hash['results'].map do |hash|
                   {
                    title: hash['titleNoFormatting'],
                    description: hash['content'],
                    url: hash['unescapedUrl']
                   }
                 end
               else
                 []
               end
  end
end
