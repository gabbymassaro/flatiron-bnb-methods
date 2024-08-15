class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :no_host_reservations
  validate :invalid_reservation_dates


  def duration
    (checkout - checkin).to_i
  end

  def total_price
    duration * listing.price
  end

  private

  def no_host_reservations
    if guest_id == listing.host_id
      errors.add(:guest, "cannot be the same as the host")
    end
  end

  def invalid_reservation_dates
    bad_dates = Reservation.where(listing_id: listing_id)
                           .where.not(id: id)
                           .where("checkin < ? OR checkout > ? ",
                           checkout, checkin)
    if bad_dates.exists?
      errors.add(:checkin, "cannot reserve")
    end
  end
end
