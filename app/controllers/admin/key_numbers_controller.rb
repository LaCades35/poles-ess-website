# frozen_string_literal: true

class Admin::KeyNumbersController < Admin::BaseController
  before_action :find_key_number, except: %i[index new create]

  def index
    @key_numbers = KeyNumber.order(:position)
    @page = MainPage.find_by(key: "key_number")
  end

  def new
    @key_number = KeyNumber.new
  end

  def create
    @key_number = KeyNumber.new(key_number_params)
    if @key_number.save
      flash[:notice] = 'Le chiffre a été créé avec succès'
      redirect_to params[:continue].present? ? edit_admin_key_number_path(@key_number) : admin_key_numbers_path
    else
      flash[:error] = "Une erreur s'est produite lors de la création du chiffre"
      render :new
    end
  end

  def edit; end

  def update
    if @key_number.update(key_number_params)
      flash[:notice] = 'Le chiffre a été mis à jour avec succès'
      redirect_to params[:continue].present? ? edit_admin_key_number_path(@key_number) : admin_key_numbers_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour du chiffre"
      render :edit
    end
  end

  def position
    if params[:position].present?
      @key_number.insert_at params[:position].to_i
      flash[:notice] = 'Les pages ont été réordonnés avec succès'
    end
    redirect_to admin_key_numbers_path
  end

  def destroy
    @key_number.destroy
    flash[:notice] = 'Le chiffre a été supprimé avec succès'
    redirect_to admin_key_numbers_path
  end

  private

  def find_key_number
    @key_number = KeyNumber.find params[:id]
  end

  # strong parameters
  def key_number_params
    params.require(:key_number).permit(
      :title, :descrition, :number, :position, :source, :description
    )
  end
end
