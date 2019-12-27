load 'player.rb'
load 'battle.rb'
load 'npc.rb'
load 'BeingManager.rb'

player = Player.new
being_manager = BeingManager.new

# Beter
test_npc_being_data = being_manager.get_by_id("ewec")

npc = NPC.new(test_npc_being_data)

battle = Battle.new(player, npc)
