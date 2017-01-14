class Api::V1::ForumsController < Api::V1Controller
  respond_to :json

  api :GET, '/forums', 'List of forums'
  def index
    @collection = Forum.cached.to_a
    respond_with @collection
  end
end
