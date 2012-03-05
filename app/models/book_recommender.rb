#$: << ::File.expand_path("../../lib", __FILE__)
require "recommendify"
require "redis"

Recommendify.redis = Redis.new

class Recommender < Recommendify::Base
  max_neighbors 50
  input_matrix:order_items,
    :similarity_func => :jaccard,
    :weight          => 5.0
end

class BookRecommender

  def recommend(item_id)
    recommender = Recommender.new

    booksship = BookUsership.select("user_id,book_id").where("is_lend = '1'")

    newbookship = Hash.new

    booksship.each do |book|
        unless newbookship.has_key?(book[:user_id])
         then  newbookship.store(book[:user_id],[])
        end
        newbookship[book[:user_id]]<<book[:book_id]
    end

    recommender.order_items.all_items.each do |item|
      recommender.order_items.delete_item(item)
    end


    newbookship.each do |key,value|
      recommender.order_items.add_set(key,value)
    end

    recommender.process!

    recommendBook = recommender.for(item_id)

    return    recommendBook

    end
end