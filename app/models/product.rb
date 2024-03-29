class Product < ActiveRecord::Base
  attr_accessible :description, :image_url, :price, :title, :line_items

  has_many :line_items

  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, :image_url, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :title, uniqueness: true, length: {
    minimum: 10,
    too_short: 'too_short'
  }
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)$}i,
    message: 'format not allowed'
  }

  private

  def ensure_not_referenced_by_any_line_item
      if line_items.empty?
          return true
      else
          errors.add(:base, 'existed')
          return false
      end
  end

end
