module OptionableContentConcern
  extend ActiveSupport::Concern

  included do
    helper_method :genres_v2?, :genres_sort_key
  end

  def genres_sort_key
    if user_signed_in?
      current_user.preferences.russian_genres? ? :russian : :name
    else
      :russian
    end
  end

  def genres_v2?
    user_signed_in? && (current_user.admin? || current_user.super_moderator?)
  end
end
