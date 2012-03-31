class Movie < ActiveRecord::Base
  ALL_RATINGS = ["G", "PG", "PG-13", "R"]
  def self.order_by(field)
    order(field)
  end

  def self.ratings
    ALL_RATINGS
  end

  def self.filter_on_ratings(ratings)
    where( rating: ratings)
  end
end
