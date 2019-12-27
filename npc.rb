require 'csv'

load 'being.rb'

# NPCs are basically Players that cannot be controlled, per se.
class NPC < Being
  def initialize(being_data)
    super(being_data)
  end
end
