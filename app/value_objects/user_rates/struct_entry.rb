UserRates::StructEntry = Struct.new(
  :id,
  :score,
  :text,
  :text_html,
  :episodes,
  :volumes,
  :chapters,
  :rewatches,
  :target_id,
  :target_class_downcase,
  :target_name,
  :target_russian,
  :target_url,
  :target_episodes,
  :target_episodes_aired,
  :target_volumes,
  :target_chapters,
  :target_kind,
  :target_is_ongoing,
  :target_is_anons
)

class UserRates::StructEntry
  URL_PREFIX = {
    'Anime' => 'animes',
    'Manga' => 'mangas',
    'Ranobe' => 'ranobe'
  }

  def self.create user_rate # rubocop:disable all
    is_anime = user_rate.target_type == 'Anime'
    target = is_anime ? user_rate.anime : user_rate.manga
    target_class_downcase = target.class.name.downcase

    UserRates::StructEntry.new(
      user_rate.id,
      user_rate.score,
      user_rate.text,
      user_rate.text_html,
      user_rate.episodes,
      user_rate.volumes,
      user_rate.chapters,
      user_rate.rewatches,
      user_rate.target_id,
      target_class_downcase,
      target.name,
      target.russian,
      "/#{URL_PREFIX[target.class.name]}/" +
        CopyrightedIds.instance.change(user_rate.target_id, target_class_downcase),
      (target.episodes if is_anime),
      (target.episodes_aired if is_anime),
      (target.volumes unless is_anime),
      (target.chapters unless is_anime),
      target.kind,
      target.ongoing?,
      target.anons?
    )
  end
end
