class ItinerariesController < ApplicationController

  respond_to :json
  def calendar_data
    @events = Event.all
    respond_to do |format|
      format.json { render json: @events.as_json }
    end
  end

  def index
    @itineraries = Itinerary.all
    @users = User.all
  end

  def show
    @itinerary = Itinerary.find(params[:id])
    @user = User.find(@itinerary.user_id)
  end

  def new
    @itinerary = Itinerary.new
  end
  
  def create
    @itinerary = Itinerary.new(itinerary_params)
    @itinerary.user_id = current_user.id

    if @itinerary.save
      redirect_to(:action => 'index')
    else
      render('new')
    end
  end

  def edit
    @itinerary = Itinerary.find(params[:id])
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
  def itinerary_params
    params.require(:itinerary).permit(:name, :user_id, :description, :startdate, :enddate)
  end
end