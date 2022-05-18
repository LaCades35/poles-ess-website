class Admin::InterfacesController < Admin::BaseController

  before_action :get_interface, only: [:update]

  def update
    if @interface.update(interface_params)
      flash[:notice] = "Position mise à jour avec succès"
      redirect_back(fallback_location: admin_root_path)
    else
      flash[:error] = "Une erreur s'est produite lors de la position"
    end
  end

  private # =====================================================

  def interface_params
    params.require(:interface).permit(:position)
  end

  def get_interface
    @interface = params[:classname].constantize.find params[:id]
  end

end
