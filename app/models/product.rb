class Product < ActiveRecord::Base
  default_scope :order => 'title'
  has_many :line_items
  has_many :orders, through: :line_items
  
  before_destroy :ensure_not_referenced_by_any_line_item

	validates :title, :description, :image_url, presence: true
	validates :price, numericality: {greater_than_or_equal_to: 0.01}
	validates :title, uniqueness: true
	validates :image_url, allow_blank: true, format: {
		with: %r{\.(gif|jpg|png)\Z}i,
		message: 'must be a URL for GIF, JPG or PNG image.'
	}

  def self.latest
    Product.order('updated_at').last
  end
  #validates :title, :length => { :minimum => 10 }
  validates_length_of :title, :minimum => 10, :message => "No minimo 10 caracteres"

  # ensure that there are no line items referencing this product
  def ensure_not_referenced_by_any_line_item
    if line_items.count.zero?
      true
    else
      errors.add(:base, 'Line Items present')
      false
    end
  end

end