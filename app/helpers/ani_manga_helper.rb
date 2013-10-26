module AniMangaHelper
  def h1_text(entry, with_sep=false)
    "#{entry.name}#{entry.russian.blank? ? '' : (with_sep ? ' <span class="sep inline">/</span> ' : ' / ') + entry.russian}".html_safe
  end

  def ani_manga_link(entry, &block)
    ('<a href="%s" title="%s"%s>%s</a>' % [
        url_for(entry),
        entry.name,
        entry[:description].blank? ? ' rel="nofollow"' : '',
        block_given? ? capture(&block) : entry.name
      ]).html_safe
  end

  def ani_manga_description(entry, length=nil)
    text = strip_tags(remove_misc_data(entry.description))

    text = if length.present?
      truncate(text, length: length, separator: ' ')
    elsif entry.name.size <= 14
      truncate(text, length: 210, separator: ' ')
    elsif entry.name.size <= 30
      truncate(text, length: 200, separator: ' ')
    elsif entry.name.size <= 50
      truncate(text, length: 195, separator: ' ')
    else
      truncate(text, length: 175, separator: ' ')
    end

    # с length вызывается для формирования описания в description
    if entry[:description].blank? && length.nil?
      "<!--noindex-->#{text}<!--/noindex-->"
    else
      text
    end
  end
end
