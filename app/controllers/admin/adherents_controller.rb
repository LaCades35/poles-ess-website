# frozen_string_literal: true
class Admin::AdherentsController < Admin::BaseController
  include DestroyableUpload
  before_action :get_adherent, except: %i[index new create]

  def index
    @adherents = Adherent
      .includes(:seo, :adherent_category)
      .apply_filters(params).apply_sorts(params)
    @page = MainPage.find_by(key: "adherent")
  end

  def new
    @adherent = Adherent.new
    @adherent.build_seo
  end

  def create
    @adherent = Adherent.new(adherent_params)
    if @adherent.save
      flash[:notice] = "L'adhérent a été créé avec succès"
      redirect_to params[:continue].present? ? edit_admin_adherent_path(@adherent) : admin_adherents_path
    else
      flash[:error] = "Une erreur s'est produite lors de la création de l'adhérent"
      render :new
    end
  end

  def edit
  end

  def update
    if @adherent.update(adherent_params)
      flash[:notice] = "L'adhérent a été mis à jour avec succès"
      redirect_to params[:continue].present? ? edit_admin_adherent_path(@adherent) : admin_adherents_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de l'adhérent"
      render :edit
    end
  end

  def edit_configuration
  end

  def update_configuration
    if @adherent.update(adherent_params)
      flash[:notice] = "L'adhérent a été mis à jour avec succès"
      redirect_to params[:continue].present? ? edit_configuration_admin_adherent_path(@adherent) : admin_adherents_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de l'adhérent"
      render :edit_configuration
    end
  end

  def destroy
    begin
      flash[:notice] = "L'adhérent a bien été supprimée" if @adherent.destroy
    rescue ActiveRecord::DeleteRestrictionError
      flash[:error] = "Cet adhérent ne peut être supprimé car des éléments lui sont dépendants"
    end
    redirect_to admin_adherents_path
  end

  private

  def get_adherent
    @adherent = Adherent.from_param params[:id]
  end

  def adherent_params
    params
      .require(:adherent)
      .permit(
        :adherent_category_id,
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
