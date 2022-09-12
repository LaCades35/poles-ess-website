# frozen_string_literal: true
class Theme < ApplicationRecord

  include Seoable
  include Resourceable
  include Enablable
  include RichDescription

  include PgSearch::Model
  multisearchable against: [:title, :baseline, :search_description]

  has_one_attached :image

  acts_as_list

  has_many :theme_interfaces, dependent: :destroy
  has_many :activities, through: :theme_interfaces, source: :themable,
           source_type: 'Activity'
  has_many :posts, through: :theme_interfaces, source: :themable,
          source_type: 'Post'

  has_many :menu_blocks, -> { order(:position) }, inverse_of: :theme, dependent: :destroy
  accepts_nested_attributes_for :menu_blocks, reject_if: :all_blank
  has_many :menu_items, -> { order(:position) }, through: :menu_blocks

  # Validations ================================================================

  validates :title,
            :baseline,
            presence: true
  validates :image, content_type: ['image/jpeg', 'image/jpg', 'image/gif', 'image/png']

  # Scopes ====================================================================

  scope :having_activities, -> { joins(:activities).distinct }
  scope :having_posts, -> { joins(:posts).distinct }
  scope :having_resources, -> { joins(:resources).distinct }

  # Instance methods ====================================================

  def key
    return self.title.parameterize
  end

end
