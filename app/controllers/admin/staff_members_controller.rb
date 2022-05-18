# frozen_string_literal: true
class Admin::StaffMembersController < Admin::BaseController
  include DestroyableUpload
  before_action :get_staff_member, except: %i[index new create]

  def index
    @staff_members = StaffMember
      .includes(:seo, :staff_member_category)
      .apply_filters(params).apply_sorts(params)
    @page = MainPage.find_by(key: "staff_member")

  end

  def new
    @staff_member = StaffMember.new
    @staff_member.build_seo
  end

  def create
    @staff_member = StaffMember.new(staff_member_params)
    if @staff_member.save
      flash[:notice] = "Le membre de l'équipe a été créé avec succès"
      redirect_to params[:continue].present? ? edit_admin_staff_member_path(@staff_member) : admin_staff_members_path
    else
      flash[:error] = "Une erreur s'est produite lors de la création du membre de l'équipe"
      render :new
    end
  end

  def edit
  end

  def update
    if @staff_member.update(staff_member_params)
      flash[:notice] = "Le membre de l'équipe a été mis à jour avec succès"
      redirect_to params[:continue].present? ? edit_admin_staff_member_path(@staff_member) : admin_staff_members_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour du membre de l'équipe"
      render :edit
    end
  end

  def edit_configuration
  end

  def update_configuration
    if @staff_member.update(staff_member_params)
      flash[:notice] = "Le membre de l'équipe a été mis à jour avec succès"
      redirect_to params[:continue].present? ? edit_configuration_admin_staff_member_path(@staff_member) : admin_staff_members_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour du membre de l'équipe"
      render :edit_configuration
    end
  end

  def destroy
    begin
      flash[:notice] = "Le membre de l'équipe a bien été supprimée" if @staff_member.destroy
    rescue ActiveRecord::DeleteRestrictionError
      flash[:error] = "Ce membre de l'équipe ne peut être supprimé car des éléments lui sont dépendants"
    end
    redirect_to admin_staff_members_path
  end

  private

  def get_staff_member
    @staff_member = StaffMember.from_param params[:id]
  end

  def staff_member_params
    params
      .require(:staff_member)
      .permit(
        :staff_member_category_id,
        :firstname,
        :lastname,
        :description,
        :image,
        :enabled,
        :position,
        seo_attributes: seo_attributes
      )
  end
end
