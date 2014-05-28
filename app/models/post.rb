class Post < ActiveRecord::Base

  extend Enumerize

  default_scope { order(created_at: :desc) }

  ## Scopes
  scope :draft, -> { with_status(:draft) }
  scope :waiting, -> { with_status(:waiting) }
  scope :published, -> { with_status(:published) }
  scope :rejected, -> { with_status(:rejected) }
  scope :locked, -> { with_status(:locked) }

  ## Validates
  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true
  validates :catagory, presence: true
  enumerize :status, in: Car::Code::POST_STATUS, default: :draft, predicates: { prefix: true }, scope: true


  ## Associations
  belongs_to :admin, foreign_key: :create_user_id
  belongs_to :catagory

end
