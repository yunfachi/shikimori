class MangaProfileSerializer < MangaSerializer
  attributes :english, :japanese, :synonyms, :kind, :aired_on, :released_on,
    :volumes, :chapters, :score, :description, :description_html,
    :favoured?, :anons?, :ongoing?, :thread_id,
    :read_manga_id, :myanimelist_id,
    :rates_scores_stats, :rates_statuses_stats

  has_many :genres
  has_many :publishers

  has_one :user_rate

  def user_rate
    object.current_rate
  end

  def thread_id
    object.thread.id
  end

  def myanimelist_id
    object.id
  end

  def description
    if scope.ru_domain?
      object[:description_ru] || object[:description_en]
    else
      object[:description_en]
    end
  end
end
