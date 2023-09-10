class Moderations::MalMoreInfosController < ModerationsController
  PER_PAGE = 20

  def index
    og page_title: i18n_t('page_title')

    @anime_collection = fetch Anime
    @manga_collection = fetch Manga

    @collection = @anime_collection + @manga_collection
  end

private

  def fetch klass
    QueryObjectBase
      .new(klass.all)
      .where("more_info like '%[MAL]'")
      .paginate(page, PER_PAGE)
      .lazy_map(&:decorate)
  end
end
