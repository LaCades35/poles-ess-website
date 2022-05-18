# frozen_string_literal: true
class Admin::PartnersController < Admin::BaseController
  include DestroyableUpload
  before_action :get_partner, except: %i[index new create]

  def index
    @partners = Partner
      .includes(:seo, :partner_category)
      .apply_filters(params).apply_sorts(params)
    @page = MainPage.find_by(key: "partner")
  end

  def new
    @partner = Partner.new
    @partner.build_seo
  end

  def create
    @partner = Partner.new(partner_params)
    if @partner.save
      flash[:notice] = "Le partenaire a été créé avec succès"
      redirect_to params[:continue].present? ? edit_admin_partner_path(@partner) : admin_partners_path
    else
      flash[:error] = "Une erreur s'est produite lors de la création du partenaire"
      render :new
    end
  end

  def edit
  end

  def update
    if @partner.update(partner_params)
      flash[:notice] = "Le partenaire a été mis à jour avec succès"
      redirect_to params[:continue].present? ? edit_admin_partner_path(@partner) : admin_partners_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour du partenaire"
      render :edit
    end
  end

  def edit_configuration
  end

  def update_configuration
    if @partner.update(partner_params)
      flash[:notice] = "Le partenaire a été mis à jour avec succès"
      redirect_to params[:continue].present? ? edit_configuration_admin_partner_path(@partner) : admin_partners_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour du partenaire"
      render :edit_configuration
    end
  end

  def destroy
    begin
      flash[:notice] = "Le partenaire a bien été supprimée" if @partner.destroy
    rescue ActiveRecord::DeleteRestrictionError
      flash[:error] = "Ce partenaire ne peut être supprimé car des éléments lui sont dépendants"
    end
    redirect_to admin_partners_path
  end

  private

  def get_partner
    @partner = Partner.from_param params[:id]
  end

  def partner_params
    params
      .require(:partner)
      .permit(
        :partner_category_id,
        :title,
        :link,
        :description,
        :image,
        :enabled,
        :position,
        seo_attributes: seo_attributes
      )
  end
end
