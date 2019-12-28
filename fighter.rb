load 'player.rb'
load 'npc.rb'
load 'AbilityManager.rb'
load 'game.rb'

class Fighter
  attr_reader :name, :stats, :being, :max_health, :current_health, :fleed, :abilities, :damages_received, :damages_dealt

  def initialize(being)
    @being     = being
    @name      = being.name
    @stats     = being.stats
    @fleed     = false
    set_abilites(being.abilities)

    @max_health     = being.stats["health"]
    @current_health = being.stats["health"]

    @damages_received = [] # Used to calculate chance of dying
  end

  def set_abilites(ability_handles) # ability_handles == ["strike", "heal"]
    @ability_manager = AbilityManager.new

    @abilities = ability_handles.map { |handle| @ability_manager.find_by_handle(handle) }
  end

  def calculate_healing(ability)
    min_healing = ability["effects"].reduce(0) do |dmg, effect|
      dmg + effect["base_healing"] # 5
    end

    min_healing
  end

  def receive_healing(healing)
    previous_health = @current_health

    @current_health += healing
    @current_health = @max_health if @current_health > @max_health
    @received_healing = @current_health - previous_health;

    Game.log("#{@name} received #{@received_healing} points of health!")
  end

  def calculate_damage(ability)
    min_damage = ability["effects"].reduce(0) do |dmg, effect|
      dmg + effect["base_damage"] # 5
    end

    power = @stats["power"] # 10
    sense = @stats["sense"] # 10

    max_damage            = min_damage + power # 15
    sense_influence       = sense / 100 + 1 # 1.1
    influenced_max_damage = max_damage * sense_influence # 16.5
    damage                = rand(min_damage..influenced_max_damage) # 5..16.5

    # Our desired effect for the sense stat is to increase the propsensity of min - max to be closer to max.
    # But, the minimum damage and maximum damage need to be possibilities. The damage output CANNOT exceed the maximum damage.

    damage = max_damage if damage > max_damage

    damage.round
  end

  # FIX BUG:
  #   Beter blocked 10 points of damage, down from 6!
  #   Kyle used Strike against Beter, dealing -4 damage!
  def receive_damage(damage, attacker)
    received_damage = damage
    attacker_sense  = attacker.stats["sense"]
    agility         = @stats["agility"]
    
    # Can we dodge the damage? (Agility vs. attacker's Sense)

    # agility = 10, attacker_sense = 10

    dodge_chance = agility / attacker_sense # 0.1..10, .1 == nearly impossible to dodge, 10 == nearly impossible to be damaged
      
    if dodge_chance > rand(0.1..10)
      # Dodged!
      received_damage = 0

      Game.log("#{@name} dodged the attack!")
      return received_damage
    end

    # Can we reduce the damage? If so, by how much? (Fortitude)

    fortitude = @stats["fortitude"] # 10
    
    reduced_damage = rand(0..fortitude) # 0..10
    reduced_damage = 0 if reduced_damage < 0

    Game.log("#{@name} blocked #{reduced_damage} points of damage, down from #{received_damage}!")

    received_damage -= reduced_damage

    @current_health -= received_damage
    @damages_received.push(received_damage)
    
    received_damage
  end

  def is_dead?
    if @current_health <= 0 
      true
    else 
      false
    end
  end
  
  def battle_turn(battle)
    defender = battle.defender
    intent = turn_intent

    @damages_dealt = defender.damages_received

    case intent
    when "attack"
      ability = select_ability(intent)
      damage = calculate_damage(ability)

      received_damage = defender.receive_damage(damage, self)

      Game.log("#{@name} used #{ability["name"]} against #{defender.name}, dealing #{received_damage} damage!")
      Game.log("#{defender.name} has #{defender.current_health} health left.")
    when "benefit" # TODO: Target friendlies!
      ability = select_ability(intent)
      healing = calculate_healing(ability)
      
      receive_healing(healing)
      Game.log("#{@name} has #{@current_health} health left.") # TODO: DRY this up
    when "flee"
      flee
    end
  end

  def select_ability(intent)
    if @being.is_a?(Player)
      ability_type        = intent
      abilities_by_intent = @abilities.select { |a| a["type"] == intent }
      ability_names       = abilities_by_intent.map { |a| a["name"] }
  
      Game.log("Select an ability:")
      selected_ability_name = gets_from_array(ability_names)
  
      @abilities.find { |ability| ability["name"] == selected_ability_name }
    elsif @being.is_a?(NPC)
      if intent == "attack"
        return attack_ability_recommendation
      end

      if intent == "benefit"
        return benefit_ability_recommendation
      end
    end
  end

  def intent_recommendation
    if max_damage_received > @current_health
      if AbilityManager.has_healing_ability(@abilities)
        return "benefit"
      else
        return "flee"
      end
    end

    "attack"
  end

  def max_damage_received
    highest_damage = 0

    @damages_received.each do |damage|
      if damage > highest_damage
        highest_damage = damage
      end
    end

    highest_damage
  end

  def average_damage_received
    return 0 if @damages_received.count == 0

    @damages_received.reduce(0) { |all_dmg, dmg| all_dmg + dmg } / @damages_received.count
  end

  def average_damage_dealt
    return 0 if @damages_dealt.count == 0

    @damages_dealt.reduce(0) { |all_dmg, dmg| all_dmg + dmg } / @damages_dealt.count
  end

  def attack_ability_recommendation
    AbilityManager.most_potent_attack_ability(@abilities)
  end

  def benefit_ability_recommendation
    AbilityManager.most_potent_benefit_ability(@abilities)
  end

  def flee
    can_flee = true # TODO: Implement RNG goodness; i.e. can we flee? Did something get in the way? etc.

    if can_flee
      @fleed = true
    end
  end

  def turn_intent
    if @being.is_a?(Player)
      recommended_intent = intent_recommendation
      intent_types = %w[attack benefit flee]
      
      Game.log("It's recommended that you #{recommended_intent}.")
      gets_from_array(intent_types)
    elsif @being.is_a?(NPC)
      intent_recommendation
    end
  end

  def gets_from_array(options)
    pp options

    input = gets
    input.strip!

    if options.include?(input) 
      input
    else 
      Game.log("You can't do that, try again.")
      gets_from_array(options)
    end
  end
end
