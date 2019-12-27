# Beings can do things like attack, converse, trade and/or give quests.
# Both NPCs, mobs and Players are Beings.
class Being
  attr_accessor :name, :stats, :inventory, :abilities, :equipment, :abilities

  def initialize(being_data)
    params = %w(id stats name inventory abilities equipment)

    params.each do |param|
      self.instance_variable_set("@#{param}", being_data[param])
    end
  end

  def set_stat(stat, value)
    @stats[stat] = value
  end

  def stat(stat)
    @stats[stat]
  end

  def say(sentence)
    puts sentence
  end

  def ask(question)
    puts question
    gets.to_s
  end
end
