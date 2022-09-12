# frozen_string_literal: true

module SettingHelper

  def highlighted_feature_options
    Setting.get_field('highlighted_feature').dig(:options, :option_values).map do |highlighted_feature_option|
      [ I18n.t(highlighted_feature_option, scope: %i(setting highlighted_feature options)), highlighted_feature_option ]
    end
  end

  def highlighted_feature_path
    public_send(I18n.t(Setting.highlighted_feature, scope: %i(setting highlighted_feature paths)))
  end

  def highlighted_feature_title
    I18n.t(Setting.highlighted_feature, scope: %i(setting highlighted_feature titles))
  end

  def highlighted_feature_icon
    I18n.t(Setting.highlighted_feature, scope: %i(setting highlighted_feature icons))
  end

  def highlighted_feature_block_icon
    I18n.t(Setting.highlighted_feature, scope: %i(setting highlighted_feature block_icons))
  end

  def highlighted_feature_block_question
    I18n.t(Setting.highlighted_feature, scope: %i(setting highlighted_feature block_questions))
  end

  def highlighted_feature_block_button
    I18n.t(Setting.highlighted_feature, scope: %i(setting highlighted_feature block_buttons))
  end

  def highlighted_feature_block_path
    public_send(I18n.t(Setting.highlighted_feature, scope: %i(setting highlighted_feature block_paths)))
  end

  def feature_enabled?(feature)
    Setting.enabled_features.include?(feature)
  end
end
