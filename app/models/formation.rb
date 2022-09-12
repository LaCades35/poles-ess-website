class Formation < ApplicationRecord
  include Seoable
  include Enablable
  include Schedulable
  include RichDescription

  include PgSearch::Model
  multisearchable against: [:title, :search_description]

  has_one_attached :image

  belongs_to :formation_category

  has_many :subscriptions, inverse_of: :formation, dependent: :restrict_with_exception
  has_many :participants, through: :subscriptions

  # Validations ================================================================

  validates :title, :schedules,
            presence: true
  validates :image, content_type: ['image/jpeg', 'image/jpg', 'image/gif', 'image/png']

  # Scopes ====================================================================

  scope :by_formation_category, -> (val) {
    where(formation_category_id: val)
  }

  scope :sort_by_formation_category, -> {
    sort_by_start_date.group_by(&:formation_category).sort_by{ |cat, array| cat.position }
  }

  # Instance methods ====================================================

  def remaining_tickets
    tickets_count - participants.participation_confirmed.count
  end

  def is_full?
    remaining_tickets <= 0
  end

  # Class Methods ==============================================================

  def self.apply_filters(params)
    [
      :by_formation_category,
      :by_year,
    ].inject(all) do |relation, filter|
      next relation unless params[filter].present?
      relation.send(filter, params[filter])
    end
  end

  def self.apply_sorts(params)
    sort_by_start_date
  end

  def self.default_tickets_count
    Setting.default_tickets_count
  end

  def self.default
    formation = self.new(tickets_count: self.default_tickets_count)
    formation.build_seo
    formation.schedules.new
    formation
  end
end
