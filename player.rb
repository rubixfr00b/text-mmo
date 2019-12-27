require 'json'

load 'being.rb'

# There is only one Player, for now.
class Player < Being
  def initialize
    super(player_data)
  end

  def player_data
    JSON.parse(File.read('data/player.json'))
  end

  def update_player_data
    json = JSON.pretty_generate(
      {
        :name => @name,
        :stats => @stats,
        :abilities => @abilities,
        :inventory => @inventory,
        :equipment => @equipment
      }
    )

    File.open("data/player.json", "w") do |f|
      f.write(json)
    end
  end
end
