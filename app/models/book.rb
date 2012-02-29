class Book < ActiveRecord::Base
  # To change this template use File | Settings | File Templates.
  has_many :book_userships
  has_many :users, :through => :book_userships
  belongs_to :user, :foreign_key => "status"
  belongs_to :user, :foreign_key => "owner"
end