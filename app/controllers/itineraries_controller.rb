class ItinerariesController < ApplicationController
  before_action :set_itinerary, only: [:name, :description, :duration, :startdate, :enddate, :color]

  respond_to :json
  def calendar_data
    @all_itineraries = Itinerary.all
    #gets calendar data for the current user
    @itineraries = Itinerary.where(user_id: current_user.id)
    #then ones that the current user is involved in
    @itineraries2 = []
    itinerary_invited_users = ItineraryInvitedUser.where(user_id: current_user.id)
    itinerary_invited_users.each do |f|
      @itineraries2 += Itinerary.where(id: f.itinerary_id)
    end
    #then the events of both
    @events = []
    #@itinerary_event_count = []
    @events2 = []
    #@itinerary_event_count2 = []
    @itineraries.each do |f|
      current_events = Event.where(itinerary_id: f.id)
      #@itinerary_event_count.push(current_events.length)
      @events += current_events
    end
    @itineraries2.each do |f|
      current_events = Event.where(itinerary_id: f.id)
      #@itinerary_event_count2.push(current_events.length)
      @events2 += current_events
    end
    @events3 = []
    event_invited_users = EventInvitedUser.where(user_id: current_user.id)
    event_invited_users.each do |f|
      @events3 += Event.where(id: f.event_id)
    end
    respond_to do |format|
      format.json { render json: @itineraries.as_json + @events.as_json(editable: true) + @itineraries2.as_json(editable: false) + @events2.as_json(editable: false) + @events3.as_json(editable: false) }
    end
  end

  respond_to :json
  def calendar_data2
    @itinerary = Itinerary.where(id: params[:id])
    @events = Event.where(itinerary_id: params[:id])
    #@itineraries = Itinerary.all
    respond_to do |format|
      format.json { render json: @itinerary.as_json + @events.as_json(editable: true) }
    end
  end

  respond_to :json
  def calendar_data3
    @event = Event.find(params[:event_id])
    #@itineraries = Itinerary.all
    respond_to do |format|
      format.json { render json: @event.as_json(editable: true) }
    end
  end
  
 def determine_time
    @itinerary = Itinerary.find(params[:itinerary_id])
    @events = Event.where(itinerary_id: @itinerary.id).order(:start_datetime).find_each
    @best_times = []
    #count number of voting events.  We need this because of a reason
    #For every event, find all the times that work for everyone
    @all_events = []
    
    @events.each do |event|
      
      votes = event.select_winning_votes
      #@all_events.push holder
       votes.each do |vote|
          @best_times.push Vote.find(vote)
          @all_events.push event.id
        
      end     
    end
    
    #Now, take those times, figure out the best order for things
    @times = @itinerary.figure_out_best_times(@best_times)

    redirect_to(:action => 'show', :id => @itinerary.id, :votes => @times)
  end  

  def index
    @itineraries = Itinerary.all
    @users = User.all
  end


  def show
    @itinerary = Itinerary.find(params[:id])
    @user = User.find(@itinerary.user_id)
    @events = Event.where "itinerary_id like ?", "%#{params[:id]}%"
    @allevent = Event.find_by "itinerary_id like ?", "%#{params[:id]}%"
    @recommended = params[:votes]
    
  end


  def new
    @itinerary = Itinerary.new
    itinerary_invited_users = @itinerary.itinerary_invited_users.build
  end
  

  def create
    @itinerary = Itinerary.new(itinerary_params)
    @itinerary.user_id = current_user.id
    if @itinerary.save
      redirect_to(:action => 'show', :id => @itinerary.id)
    else
      render('new')
    end
  end

  def edit
    @itinerary = Itinerary.find(params[:id])
    @itinerary_invited_users = ItineraryInvitedUser.where "itinerary_id like ?", "%#{params[:id]}%"
    @users ||= Array.new
    @itinerary_invited_users.each do |itinerary_invited_user|
      @users.push(User.find_by(id: itinerary_invited_user.user_id))
    end
  end
  
  def update
    @itinerary = Itinerary.find(params[:id])
    if @itinerary.update_attributes(itinerary_params)
      redirect_to(:action => 'show', :id => @itinerary.id)
    else
      render('index')
    end
  end
  
  def delete
    @itinerary = Itinerary.find(params[:id])
  end
  
  def destroy
    Itinerary.find(params[:id]).destroy
    redirect_to(:action => 'index')
  end
  
private
  def set_itinerary
    @itinerary = Itinerary.find(params[:id])
  end

  def itinerary_params
    params.require(:itinerary).permit(:name, :user_id, 
      :description, :startdate, :enddate, :color, itinerary_invited_users_attributes: [:id, :itinerary_id, :user_id])
  end
end