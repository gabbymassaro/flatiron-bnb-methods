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

end
