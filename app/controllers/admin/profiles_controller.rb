class Admin::ProfilesController < Admin::BaseController
  include DestroyableUpload

  before_action :get_profile, except: %i[index new create]

  def index
    @profiles = Profile.includes(:seo).order(:position)
  end

  def new
    @profile = Profile.new
    @profile.build_seo
    @profile.resources.new
  end

  def create
    @profile = Profile.new(profile_params)
    if @profile.save
      flash[:notice] = "Le profil a été créé avec succès"
      redirect_to params[:continue].present? ? edit_admin_profile_path(@profile) : admin_profiles_path
    else
      @profile.resources.new if @profile.resources.empty?
      flash[:error] = "Une erreur s'est produite lors de la mise à jour du profil"
      render :new
    end
  end

  def edit
    @profile.resources.new if @profile.resources.empty?
  end

  def update
    if @profile.update(profile_params)
      flash[:notice] = "Profil mis à jour avec succès"
      redirect_to params[:continue].present? ? edit_admin_profile_path(@profile) : admin_profiles_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour du profil"
      render :edit
    end
  end

  def edit_configuration
  end

  def update_configuration
    if @profile.update(profile_params)
      flash[:notice] = "Profil mis à jour avec succès"
      redirect_to params[:continue].present? ? edit_configuration_admin_profile_path(@profile) : admin_profiles_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour du profil"
      render :edit_configuration
    end
  end

  def destroy
    begin
      @profile.destroy!
      flash[:notice] = "Le profil a été supprimé avec succès"
    rescue ActiveRecord::DeleteRestrictionError
      flash[:error] = "Vous ne pouvez pas supprimer ce profil car il a des données dépendantes"
    end
    redirect_to action: :index
  end

  private # =====================================================

  def profile_params
    params.require(:profile).permit(
      :title, :description, :short_description, :baseline, :image, :position, :enabled,
      seo_attributes: seo_attributes, resources_attributes: resources_attributes
    )
  end

  def get_profile
    @profile = Profile.from_param params[:id]
  end

end
