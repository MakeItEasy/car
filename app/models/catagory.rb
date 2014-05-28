class Catagory < ActiveRecord::Base

  default_scope { order(order: :asc) }

  validates :name, presence: true, length: { maximum: 10 }, uniqueness: true
  validates :order, numericality: { only_integer: true, 
    greater_than_or_equal_to: 0, less_than: 100 }, uniqueness: true
end
