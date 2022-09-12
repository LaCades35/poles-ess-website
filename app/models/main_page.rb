# frozen_string_literal: true
class MainPage < ApplicationRecord
  # Configurations =============================================================
  include Seoable
  include Resourceable
  include Enablable
  include RichDescription

  include PgSearch::Model
  multisearchable against: [:title, :baseline, :search_description]

  has_one_attached :image

  acts_as_list scope: [:parent_page_id]

  # Associations ===============================================================
  belongs_to :parent_page, class_name: 'MainPage', optional: true
  has_many :child_pages, -> { order(:position) }, class_name: 'MainPage', foreign_key: 'parent_page_id'

  has_many :menu_blocks, -> { order(:position) }, inverse_of: :main_page, dependent: :destroy
  accepts_nested_attributes_for :menu_blocks, reject_if: :all_blank
  has_many :menu_items, -> { order(:position) }, through: :menu_blocks

  # Callbacks ==================================================================
  validates :title, presence: true
  validates :key, uniqueness: true, unless: :destroyable?
  validates :image, content_type: ['image/jpeg', 'image/jpg', 'image/gif', 'image/png']

  private def check_for_key
    return true if key.nil?
    throw :abort
  end
  before_destroy :check_for_key

  # Scopes =====================================================================
  scope :no_parent, -> { where(parent_page_id: nil) }

  # Class Methods ==============================================================
  def self.apply_filters(params)
    [
    ].inject(all) do |relation, filter|
      next relation unless params[filter].present?

      relation.send(filter, params[filter])
    end
  end

  def self.apply_sorts(*)
    order(created_at: :desc)
  end

  # Instance Methods ===========================================================
  def destroyable?
    key.nil?
  end

  # MainPage rattachées à des modèles (ex : chiffres clés, membres..)
  def special_page?
    key.present? && Object.const_defined?(key.classify.to_sym)
  end

  def no_parent?
    parent_page_id.nil?
  end
end
