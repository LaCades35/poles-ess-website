# frozen_string_literal: true
class Adherent < ApplicationRecord
  include Seoable
  include Enablable

  # Configurations =============================================================
  has_one_attached :image
  has_rich_text :description
  acts_as_list scope: [:adherent_category_id]

  # Associations ===============================================================
  belongs_to :adherent_category, inverse_of: :adherents, optional: true

  # Callbacks ==================================================================
  validates :title, presence: true
  validates :adherent_category, presence: true
  validates :image, content_type: ['image/jpeg', 'image/jpg', 'image/gif', 'image/png']

  # Scopes =====================================================================
  scope :by_title, ->(val) {
    val.downcase!
    where(Adherent.arel_table[:title].matches("%#{val}%"))
  }
  scope :by_adherent_category, ->(val) { where(adherent_category_id: val) }
  scope :sort_by_adherent_category_title, ->(order) { joins(:adherent_category).order(Category.arel_table[:title].public_send(order.downcase)) }

  # Class Methods ==============================================================
  def self.apply_filters(params)
    klass = self
    klass = klass.by_title(params[:by_title]) if params[:by_title].present?
    klass = klass.by_adherent_category(params[:by_adherent_category]) if params[:by_adherent_category].present?
    klass.all
  end

  def self.apply_sorts(params)
    return self.order(position: :asc) if params[:by_adherent_category].present?
    return self.order(title: :asc)
  end

  # Instance Methods ===========================================================

  private #=====================================================================
end
