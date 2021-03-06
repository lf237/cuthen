class EventsController < ApplicationController
  before_action :set_event, only: [:name, :description, :duration, :startdate, :enddate, :deadlinedate, :votetype]

  skip_before_action :verify_authenticity_token
  def replace_event_data
    @event = Event.find(params[:id])
    @event.update_column(:start_datetime, params[:start])
    @event.update_column(:end_datetime, params[:end])
    render json: @event.as_json
  end

  def index
    @itinerary = Itinerary.find(params[:itinerary_id])
    @events = Event.where(itinerary_id: params[:itinerary_id])#.to_a
    #@events = @itinerary.Event.all
    #@itineraries = Itinerary.all
    #@event_invited_user = EventInvitedUser.all
  end

  def show
    @event = Event.find(params[:id])
    @itinerary = Itinerary.find(params[:itinerary_id])
    @guests = EventInvitedUser.where(event_id: @event.id)
  end

  def new
    
    @itinerary = Itinerary.find(params[:itinerary_id])
    if @itinerary.start_datetime == nil || @itinerary.end_datetime == nil
      redirect_to dashboard_path
    end
    @event = Event.new
    @event.name = ""
    event_invited_users = @event.event_invited_users.build
  end
  
  def create
    @event = Event.new(event_params)
    @event.itinerary_id = params[:itinerary_id]
    #event_invited_users = @event.event_invited_users.build
    if @event.save
      redirect_to(:action => 'index')
    else
      render('new')
    end
  end

  def edit
    @event = Event.find(params[:id])
    @itinerary = Itinerary.find(params[:itinerary_id])
    @event_invited_users = EventInvitedUser.where "event_id like ?", "%#{params[:id]}%"
    @users ||= Array.new
    @event_invited_users.each do |event_invited_user|
      @users.push(User.find_by(id: event_invited_user.user_id))
    end
  end
  
  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(event_params)
      redirect_to(:action => 'show', :id => @event.id)
    else
      render('index')
    end
  end
  
  def delete
    @event = Event.find(params[:id])
    @itinerary = Itinerary.find(params[:itinerary_id])
  end
  
  def destroy
    Event.find(params[:id]).destroy
    redirect_to(:action => 'index')
  end
  
private
  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :itinerary_id, 
      :description, :duration, :startdate, :enddate, 
      :deadlinedate, :votetype, event_invited_users_attributes: [:id, :event_id, :user_id])
  end
end