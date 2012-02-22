class PagebookUsership < ActiveRecord::Base
  belongs_to :pagebook
  belongs_to :user
end
