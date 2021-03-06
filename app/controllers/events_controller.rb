class EventsController < ApplicationController
  before_action :authenticate_with_token!
  before_action :set_event, only:[:show, :update, :destroy]


  # GET /events
  def index
    if params[:interval].present?
     events = current_user.events.with_interval params[:interval].to_i
   else
      events = current_user.events
    end
    render json: events
  end

  # GET /events/1
  def show
    if event_permitted_to_show?
      render json: @event
    else
      render json: { error: "Access denied" }, status: 403
    end
  end

  # POST /events
  def create
    event = current_user.events.create permitted_event_params
    if event
      event.update owner_id: current_user.id

      render json: event
    else
      render json: { error: event.errors }
    end
  end

  # PATCH/PUT /events/1
  def update
    if event_permitted_to_edit_or_delete?
      if @event.update(permitted_event_params)
        render json: @event
      else
        render json: { error: @event.errors }
      end
    else
      render json: { error: "Access denied"}, status: 403
    end
  end

  # DELETE /events/1
  def destroy
    if event_permitted_to_edit_or_delete?
      if @event.destroy
        render json: { data: {message: "Successfuly deleted"} }
      else
        render json: { error: @event.errors }
      end
    else
      render json: { error: "Access denied"}, status: 403
    end
  end


  private
    # Use callback to share common setup or constraints between actions.
    def set_event
      @event = Event.find_by_id params[:id]
      unless @event
        render json: { error: "Not found" }, status: 404
      end
    end

    # Only allow a trusted parameter "white list" through.
    def permitted_event_params
      params.require(:event).permit(:name, :time, :place, :purpose, :attachment)
    end
    # Check whether user is event's participant
    def event_permitted_to_show?
      current_user.events.map(&:id).include?(@event.id)
    end
    # Check whether user is a creator of the event
    def event_permitted_to_edit_or_delete?
      current_user.id == @event.owner_id
    end
end
