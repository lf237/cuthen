class UsersController < ApplicationController
	def autocomplete_array
  	@users = User.order(:name).where "name like ?", "%#{params[:term]}%"
  	#@tests.map(&:name) ==> @users.map{|x| x.name}
  	render json: @users.map{|x| x.name + "/" + x.id.to_s}
  end
end