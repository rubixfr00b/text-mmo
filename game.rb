require 'csv'

load 'player.rb'
load 'npc.rb'

# Game handles the entire environment of the game
class Game
  def initialize
    @npc_schema = ['name']
    @npcs = []

    @player = Player.new
    read_data
  end

  def read_data
    CSV.foreach('data/npcs.csv') do |row|
      npc = {}

      @npc_schema.each_index do |index|
        key = @npc_schema[index]
        npc[key] = row[index]
      end

      @npcs.push(NPC.new(npc))
    end
  end
end
