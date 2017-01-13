require 'rails_helper'

describe Restaurant, type: :model do
  it 'is not valid with a name of less than three characters' do
    user = User.new( email: "testman@email.com")
    restaurant = Restaurant.new(name: 'KF', user: user)
    user.restaurants.push restaurant
    restaurant.save
    expect(restaurant).to have(1).error_on(:name)
    expect(restaurant).not_to be_valid
  end

  it "is not valid unless it has a unique name" do
    user = User.new
    restaurant_1 = Restaurant.new(name: "Moe's Tavern")
    user.restaurants.push restaurant_1
    restaurant_1.save
    restaurant_2 = Restaurant.new(name: "Moe's Tavern")
    user.restaurants.push restaurant_2
    restaurant_2.save
    expect(restaurant_2).to have(1).error_on(:name)
  end
end
