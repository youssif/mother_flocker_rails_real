class Tweeter < ActiveRecord::Base
  attr_accessible :name, :handle, :email
end
