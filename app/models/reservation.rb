class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true


  validate :no_host_reservations
  validate :invalid_checkins


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

  def invalid_checkins
    if checkout && checkin && checkout <= checkin
      errors.add(:guest_id, "Invalid reservations dates")
    end
  end

  def unavailable_listings
  end
end
