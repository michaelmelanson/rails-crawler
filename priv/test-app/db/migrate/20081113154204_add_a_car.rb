class AddACar < ActiveRecord::Migration
  def self.up
    car = Car.new
    car.save!
  end

  def self.down
    Car.find(:first).destroy    
  end
end
