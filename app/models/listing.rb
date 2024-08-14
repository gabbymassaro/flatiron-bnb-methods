class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  after_create :assign_host
  # after_destroy :destroy_hosts

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true


  private
  def assign_host
    self.host.update(host: true)
  end

  # def destroy_hosts
  # end
end
