class User < ActiveRecord::Base
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable and :activatable ,:confirmable,
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

    #has_many :pagebooks, :through => :pagebook_userships
end
