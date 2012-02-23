class User < ActiveRecord::Base
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation,:remember_me,:udid
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable and :activatable ,:confirmable,
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :book_userships
  has_many :books, :through => :book_userships
  #has_one :book
end
