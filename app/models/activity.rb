class Activity < ApplicationRecord
  include Themable
  include Profilable
  include Seoable
  include Enablable
  include Resourceable
  include RichDescription

  include PgSearch::Model
  multisearchable against: [:title, :home_title, :search_description]

  has_one_attached :image


  # Validations ================================================================

  validates :title,  presence: true
  validates :home_title, presence: true, if: :highlighted?
  validates :image, content_type: ['image/jpeg', 'image/jpg', 'image/gif', 'image/png']

  # Scopes ====================================================================

  scope :highlighted, -> { where(highlighted: true) }

  # Instance methods ====================================================

  def relationships
    relationships = []
    relationships << self.themes.enabled
    relationships << self.profiles.enabled
    relationships.flatten
  end

  # Class Methods ==============================================================

  def self.apply_filters(params)
    [
      :by_theme,
      :by_profile,
    ].inject(all) do |relation, filter|
      next relation unless params[filter].present?

      relation.send(filter, params[filter])
    end
  end

  def self.apply_sorts(params)
    if params[:by_theme].present? && !params[:by_theme].blank?
      self.order_by_theme_interface_position
    elsif params[:by_profile].present? && !params[:by_profile].blank?
      self.order_by_profile_interface_position
    else
      self.order(created_at: :desc)
    end
  end
end
