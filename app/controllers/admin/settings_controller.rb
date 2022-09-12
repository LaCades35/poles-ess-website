# frozen_string_literal: true

class Admin::SettingsController < Admin::BaseController
  include DestroyableUpload

  def create
    setting_params.keys.each do |key|
      unless setting_params[key].nil?
        if setting_params[key].is_a?Array
          Setting.send("#{key}=", setting_params[key])
        else
          Setting.send("#{key}=", setting_params[key].strip)
        end
      end
    end
    if setting_upload_params.present? && !(Setting.logo_instance.update(setting_upload_params))
      update_logos
    else
      flash[:notice] = "Les paramètres ont bien été mis à jour"
    end
    redirect_to action: :show
  end

  private

  def setting_params
    params.require(:setting).permit(:enabled_features, :pole_name, :pole_address, :pole_address_complementary, :pole_city, :pole_phone, :pole_mail,
      :baseline, :newsletter_subscription_title, :newsletter_subscription_description, :admin_emails,
      :contact_bloc_description, :contact_bloc_button, :default_tickets_count, :facebook, :instagram, :linkedin, :twitter,
      :reglement_formation, :map_link, :highlighted_feature, :people_columns_count, enabled_features: [])
  end

  def setting_upload_params
    params.require(:setting).permit(:logo)
  end

  def setting_logo_primary_params
    params.require(:setting).permit(:logo_primary)
  end

  def update_logos
    logo_instance = Setting.logo_instance
    logo_instance_primary = Setting.logo_instance_primary
    if logo_instance.update(setting_upload_params) & logo_instance_primary.update(setting_logo_primary_params)
      flash[:notice] = 'Les paramètres ont bien été mis à jour'
    else
      flash[:error] = logo_instance.errors.full_messages.first
    end
  end
end
