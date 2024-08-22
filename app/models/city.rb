class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    Listing.find_by_sql([
      "SELECT listings.*
      FROM listings
      LEFT JOIN reservations
      ON listings.id = reservations.listing_id
      AND NOT (
          reservations.checkin > ?
          OR reservations.checkout < ?
      )
      WHERE reservations.id IS NULL",
      end_date, start_date
    ])
  end

  def self.highest_ratio_res_to_listings
    City
      .select("cities.*, COUNT(reservations.id) / COUNT(DISTINCT listings.id) AS ratio")
      .joins(neighborhoods: { listings: :reservations })
      .group("cities.id")
      .order("ratio DESC")
      .first
  end

  def self.most_res
    City
    .select("cities.*, COUNT(reservations.id) AS res_count")
    .joins(neighborhoods: { listings: :reservations })
    .group("cities.id")
    .order("res_count DESC")
    .first
  end
end
