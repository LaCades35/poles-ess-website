# frozen_string_literal: true
class StaffMember < ApplicationRecord
  include Seoable
  include Enablable

  # Configurations =============================================================
  has_one_attached :image
  has_rich_text :description
  acts_as_list scope: [:staff_member_category_id]

  # Associations ===============================================================
  belongs_to :staff_member_category, inverse_of: :staff_members, optional: true

  # Callbacks ==================================================================
  validates :firstname, :lastname, presence: true
  validates :staff_member_category, presence: true
  validates :image, content_type: ['image/jpeg', 'image/jpg', 'image/gif', 'image/png']

  # Scopes =====================================================================
  scope :by_lastname, ->(val) {
    val.downcase!
    where(StaffMember.arel_table[:lastname].matches("%#{val}%"))
  }
  scope :by_staff_member_category, ->(val) { where(staff_member_category_id: val) }
  scope :sort_by_staff_member_category_title, ->(order) { joins(:staff_member_category).order(Category.arel_table[:title].public_send(order.downcase)) }

  # Class Methods ==============================================================
  def self.apply_filters(params)
    klass = self
    klass = klass.by_lastname(params[:by_lastname]) if params[:by_lastname].present?
    klass = klass.by_staff_member_category(params[:by_staff_member_category]) if params[:by_staff_member_category].present?
    klass.all
  end

  def self.apply_sorts(params)
    return self.order(position: :asc) if params[:by_staff_member_category].present?
    return self.order(lastname: :asc)
  end

  # Instance Methods ===========================================================

  def fullname
    [firstname, lastname].join(" ")
  end
  alias title fullname

  private #=====================================================================
end
