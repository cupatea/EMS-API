class InvitesController < ApplicationController
  before_action :authenticate_with_token!
  before_action :fetch_event
  before_action :fetch_invitee

  def create
    if user_able_to_invite?
      @invitee.events << @event

      render json: { status: "User was invited to event", event: @event }
    end
  end


  private

  def user_able_to_invite?
    unless current_user.id == @event.owner_id and !@invitee.events.map(&:id).include?(@event.id)
      render json: { status: "You can`t do this" }
      false
    else
      true
    end
  end

  def fetch_invitee
    @invitee = User.find_by_id permitted_invite_params[:invitee_id]

    if @invitee
      @invitee
    else
      render json: { status: "Invitee not found" }
    end
  end

  def fetch_event
    @event = Event.find_by_id permitted_invite_params[:event_id]

    if @event
      @event
    else
      render json: { status: "Event not found" }
    end
  end

  def permitted_invite_params
    params.require(:invite).permit(:invitee_id, :event_id)
  end
end
