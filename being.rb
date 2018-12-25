# Beings can do things like attack, converse, trade and/or give quests.
# Both NPCs and Players are Beings.
class Being
  def initialize(options)
    @name = options['name']
    @stats = {}

    puts "My name is #{@name}"
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
