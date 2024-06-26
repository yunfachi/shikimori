json.content JsExports::Supervisor.instance.sweep(
  current_user,
  render(
    partial: 'users/user',
    collection: @collection,
    locals: {
      content_by: :named_avatar
    },
    formats: :html
  )
)

if @collection.size == controller.class::FRIENDS_LIMIT
  json.postloader render(
    partial: 'blocks/postloader',
    locals: {
      filter: 'b-user',
      next_url: current_url(page: @page + 1),
      prev_url: @page > 1 ? current_url(page: @page - 1) : nil
    },
    formats: :html
  )
end

json.JS_EXPORTS JsExports::Supervisor.instance.export(current_user)
