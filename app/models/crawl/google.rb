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
                   # {
                   #  title: hash['titleNoFormatting'],
                   #  description: hash['content'],
                   #  image: hash['tbUrl'],
                   #  url: hash['url'],
                   #  duration: distance_of_time_in_words(hash['duration'].to_i),
                   #  published: hash['published'].to_date.to_s
                   # }
                 end
               else
                 []
               end
  end

  def books
    @books ||= if google_hash = Google::Search::Book.new(query: @query).response.hash['responseData']
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

  def sites
    @sites ||= if google_hash = Google::Search::Web.new(query: @query).response.hash['responseData']
                 google_hash['results'].map do |hash|
                   # {
                   #  title: hash['titleNoFormatting'],
                   #  description: hash['content'],
                   #  image: hash['tbUrl'],
                   #  url: hash['url'],
                   #  duration: distance_of_time_in_words(hash['duration'].to_i),
                   #  published: hash['published'].to_date.to_s
                   # }
                 end
               else
                 []
               end
  end
end
