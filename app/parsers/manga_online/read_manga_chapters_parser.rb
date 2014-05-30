class MangaOnline::ReadMangaChaptersParser < SiteParserWithCache #ReadMangaParser
  DOMAIN = "http://readmanga.me"

  def initialize manga_id, chapters_path
    @manga_id = manga_id
    @chapters_path = chapters_path
  end

  def chapters
    @chapters ||= fetch_chapters
  end

private

  def fetch_chapters
    chapters = []
    doc = Nokogiri::HTML(get chapters_url)
    doc.css('#chapterSelectorSelect').css('option').each do |elem|
      chapters << MangaChapter.new(manga_id: @manga_id, url: "#{DOMAIN}#{elem.attr('value')}", name: elem.text)
    end
    chapters
  end

  def chapters_url
    "#{DOMAIN}#{@chapters_path}"
  end
end
