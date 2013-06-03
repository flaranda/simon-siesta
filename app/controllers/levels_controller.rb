class LevelsController < ApplicationController
  require 'yaml'
  respond_to 'json'

  def show
    level_number = params[:level_number] || 1
    levels = YAML::load( File.open( Rails.root.join( "config", "levels.yml" ) ) )
    respond_with levels["level_#{ level_number }"]
  end
end