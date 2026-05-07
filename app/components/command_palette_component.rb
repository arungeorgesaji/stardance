class CommandPaletteComponent < ViewComponent::Base
  def initialize(current_user:)
    @current_user = current_user
  end

  def initial_commands = Command.for_user(@current_user)
end
