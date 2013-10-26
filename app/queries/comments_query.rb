class CommentsQuery
  LIMIT = 100

  def initialize commentable_type, commentable_id
    commentable_klass = commentable_type.camelize.constantize
    @commentable_type = commentable_klass.respond_to?(:base_class) ? commentable_klass.base_class.name : commentable_klass.name
    @commentable_id = commentable_id
  end

  def postload page, limit, descending
    comments = fetch(page, limit, descending).all
    [comments.take(limit), comments.size == limit+1]
  end

  def fetch page, limit, descending
    Comment
      .where(commentable_type: @commentable_type, commentable_id: @commentable_id)
      .includes(:user)
      .order("id #{descending ? :desc : :asc}")
      .offset(limit * (page-1))
      .limit(limit + 1)
  end
end
