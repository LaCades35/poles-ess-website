# frozen_string_literal: true
class Partner < ApplicationRecord
  include Seoable
  include Enablable

  # Configurations =============================================================
  has_one_attached :image
  has_rich_text :description
  acts_as_list scope: [:partner_category_id]

  # Associations ===============================================================
  belongs_to :partner_category, inverse_of: :partners, optional: true

  # Callbacks ==================================================================
  validates :title, presence: true
  validates :partner_category, presence: true
  validates :image, content_type: ['image/jpeg', 'image/jpg', 'image/gif', 'image/png']

  # Scopes =====================================================================
  scope :by_title, ->(val) {
    val.downcase!
    where(Partner.arel_table[:title].matches("%#{val}%"))
  }
  scope :by_partner_category, ->(val) { where(partner_category_id: val) }
  scope :sort_by_partner_category_title, ->(order) { joins(:partner_category).order(Category.arel_table[:title].public_send(order.downcase)) }

  # Class Methods ==============================================================
  def self.apply_filters(params)
    klass = self
    klass = klass.by_title(params[:by_title]) if params[:by_title].present?
    klass = klass.by_partner_category(params[:by_partner_category]) if params[:by_partner_category].present?
    klass.all
  end

  def self.apply_sorts(params)
    return self.order(position: :asc) if params[:by_partner_category].present?
    return self.order(title: :asc)
  end

  # Instance Methods ===========================================================

  private #=====================================================================
end
