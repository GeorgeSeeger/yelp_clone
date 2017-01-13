class RestaurantsController < ApplicationController
  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    current_user.restaurants.push @restaurant
    if @restaurant.save
      redirect_to restaurants_path
    else
      render 'new'
    end
  end

  def show
    @restaurant = Restaurant.find params[:id]
  end

  def edit
    @restaurant = Restaurant.find params[:id]
  end

  def update
    @restaurant = Restaurant.find params[:id]
    if current_user.restaurants.include?(@restaurant)
      @restaurant.update restaurant_params
    else
      flash[:error] = "You can only edit restaurants you have added"
    end
    redirect_to '/restaurants'
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    if user_signed_in? && current_user.restaurants.include?(@restaurant)
      @restaurant.destroy
      flash[:notice] = 'Restaurant deleted successfully'
    else
      flash[:error] = "You can only delete restaurants you have created"
    end
    redirect_to '/restaurants'
  end

  private
  def restaurant_params
    params.require(:restaurant).permit(:name, :description)
  end
end
