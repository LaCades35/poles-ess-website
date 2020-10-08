class FormationsController < ApplicationController

  include SlugsAndRedirections

  before_action :get_formation, only: [:show, :edit, :update]

  def index
    @all_formation_categories = FormationCategory.order(:position)
    @formations = Formation.apply_filters(params)
    if params[:sort] == 'by_future'
      @formations = @formations.sort_by_future
    else
      @formations = @formations.sort_by_formation_category
    end
  end

  def show
  end

  private # =====================================================

  def get_formation
    @formation = get_object_from_param_or_redirect(Formation)
  end

end