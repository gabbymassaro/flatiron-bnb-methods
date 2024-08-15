class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true

  validate :no_host_reservations
  validate :listing_available_at_checkin
  validate :listing_available_at_checkout
  validate :checkin_before_checkout
  validate :checkin_and_checkout_not_same


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

  def listing_available_at_checkin
    if listing.reservations.where("checkin <= ? AND checkout >= ?", checkin, checkin).exists?
      errors.add(:checkin, "is not available for the selected listing")
    end
  end

  def listing_available_at_checkout
    if listing.reservations.where("checkin <= ? AND checkout >= ?", checkout, checkout).exists?
      errors.add(:checkout, "is not available for the selected listing")
    end
  end

  def checkin_before_checkout
    return if checkin.nil? || checkout.nil?

    if checkin >= checkout
      errors.add(:checkout, "must be after checkin date")
    end
  end

  def checkin_and_checkout_not_same
    return if checkin.nil? || checkout.nil?

    if checkin == checkout
      errors.add(:checkout, "cannot be the same as checkin date")
    end
  end
  # ---- this will break other tests ----- #
  # def invalid_reservation_dates
  #   bad_dates = Reservation.where(listing_id: listing_id)
  #                          .where.not(id: id)
  #                          .where("checkin < ? OR checkout > ? ",
  #                          checkout, checkin)
  #   if bad_dates.exists?
  #     errors.add(:checkin, "cannot reserve")
  #   end
  # end
end
