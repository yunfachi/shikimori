class Api::V1::CalendarsController < Api::V1Controller
  respond_to :json

  # AUTO GENERATED LINE: REMOVE THIS TO PREVENT REGENARATING
  api :GET, '/calendar', 'Show a calendar'
  def show
    @collection = CalendarsQuery.new.fetch locale_from_domain
    respond_with @collection, each_serializer: CalendarEntrySerializer
  end
end
