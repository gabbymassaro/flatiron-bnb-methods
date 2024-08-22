class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
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
    Neighborhood
    .select("neighborhoods.*, COUNT(reservations.id) / COUNT(DISTINCT listings.id) AS ratio")
    .joins(listings: :reservations)
    .group("neighborhoods.id")
    .order("ratio DESC")
    .first
  end

  def self.most_res
    Neighborhood
    .select("neighborhoods.*, COUNT(reservations.id) AS res_count")
    .joins(listings: :reservations)
    .group("neighborhoods.id")
    .order("res_count DESC")
    .first
  end
end
