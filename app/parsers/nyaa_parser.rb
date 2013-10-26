class NyaaParser < TorrentsParser
  # адрес ленты
  def self.rss_url
    "http://www.nyaa.eu/?page=rss"
  end

private
  def get(url)
    super(url, required_text=['<title>NyaaTorrents', '</html>'])
  end
end
