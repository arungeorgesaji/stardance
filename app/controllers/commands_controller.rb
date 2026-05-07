class CommandsController < ApplicationController
  def index
    authorize :command, :index?
    @commands = Command.search(params[:q], current_user)
    head :no_content unless turbo_frame_request?
  end
end
