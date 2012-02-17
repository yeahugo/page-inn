class Book < ActiveRecord::Base
  has_many:pagebooks
  has_many:ebooks
end
