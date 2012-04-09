class Movie < ActiveRecord::Base
  ALL_RATINGS = ["G", "PG", "PG-13", "R"]

  def similar
    Movie.similar({ director: director })
  end

  def self.order_by(field)
    order(field)
  end

  def self.ratings
    ALL_RATINGS
  end

  def self.similar(args)
    similar_args = args.select{ |key, value| value.present? }
    similar_args.keys.size > 0 ? Movie.where(similar_args): []
  end

  def self.filter_on_ratings(ratings)
    where( rating: ratings)
  end
end
