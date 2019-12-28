require 'json'

class AbilityManager
  def initialize 
    @abilities = abilities
  end

  def find_by_handle(handle) 
    @abilities.find { |a| a["handle"] == handle }
  end

  def add_ability(ability_config)
    @abilities.push(being_config)

    write_abilities
  end

  def write_abilities
    json = JSON.pretty_generate(@abilities)

    File.open("data/abilities.json", "w") do |f|
      f.write(json)
    end
  end

  def abilities
    JSON.parse(File.read('data/abilities.json'))
  end

  def self.has_attack_ability(abilities)
    self.attack_abilities(abilities).length > 0
  end

  def self.has_healing_ability(abilities)
    self.healing_abilities(abilities).length > 0
  end

  def self.most_potent_attack_ability(abilities)
    attack_abilities = self.attack_abilities(abilities)

    most_potent_ability = nil
    most_potent_damage = 0

    attack_abilities.find do |a|
      effects = self.damage_effects(a)

      total_damage = effects.reduce(0) { |all_dmg, effect| all_dmg + effect["base_damage"] }

      if total_damage > most_potent_damage
        most_potent_damage = total_damage
        most_potent_ability = a
      end
    end

    most_potent_ability
  end

  def self.most_potent_benefit_ability(abilities)
    healing_abilities = self.healing_abilities(abilities)

    most_potent_ability = nil
    most_potent_healing = 0

    healing_abilities.find do |a|
      effects = self.healing_effects(a)

      total_healing = effects.reduce(0) { |all_dmg, effect| all_dmg + effect["base_healing"] }

      if total_healing > most_potent_healing
        most_potent_healing = total_healing
        most_potent_ability = a
      end
    end

    most_potent_ability
  end

  def self.attack_abilities(abilities)
    abilities.select do |a|
      self.damage_effects(a).length > 0
    end
  end

  def self.healing_abilities(abilities)
    abilities.select do |a|
      self.healing_effects(a).length > 0
    end
  end

  def self.healing_effects(ability)
    ability["effects"].select { |e| e["base_healing"] != nil }
  end

  def self.damage_effects(ability)
    ability["effects"].select { |e| e["base_damage"] != nil }
  end
end
