# frozen_string_literal: true
class Profile < ApplicationRecord
  include Seoable
  include Resourceable
  include Enablable
  include RichDescription

  include PgSearch::Model
  multisearchable against: [:title, :baseline, :search_description]

  has_one_attached :image
  has_one_attached :icon

  acts_as_list

  has_many :profile_interfaces, dependent: :destroy
  has_many :activities, through: :profile_interfaces, source: :profilable,
           source_type: 'Activity'
  has_many :posts, through: :profile_interfaces, source: :profilable,
          source_type: 'Post'

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
end
