class User < ActiveRecord::Base
    has_many :pagebooks, :through => :pagebook_userships
end
