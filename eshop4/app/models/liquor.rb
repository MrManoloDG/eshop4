class Liquor < ActiveRecord::Base

  has_and_belongs_to_many :suppliers
  belongs_to : producer

  #has_many :cart_items
  #has_many :carts, :through => :cart_items

  #has_attached_file :cover_image
  #validates_attachment :cover_image,
  #:content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] }

  validates_length_of :title, :in => 1..255
  validates_presence_of :producer
  validates_presence_of :suppliers
  validates_presence_of :producer_at
  validates_numericality_of :price
  validates_length_of :serial_number, :in => 1..5
  validates_uniqueness_of :serial_number

  def author_names
    self.suppliers.map{|supplier| supplier.name}.join(", ")
  end

  #def self.latest(num)
  #  all.order("books.id desc").includes(:authors, :publisher).limit(num)
  #end
end
