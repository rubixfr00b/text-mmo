load 'fighter.rb'

class Battle
  attr_reader :defender, :attacker, :initiator, :target

  def initialize(initiator, target)
    puts "[Battle] Initializing initator"
    @initiator = Fighter.new(initiator)

    puts "[Battle] Initializing target"
    @target = Fighter.new(target)

    @attacker = @initiator
    @defender = @target

    @current_turn = :initiator

    turn
  end

  # Recursive function where the attacker performs an action
  def turn
    @attacker.battle_turn(self)

    if @defender.is_dead?
      puts "#{@defender.name} is dead!"
    elsif @attacker.fleed
      puts "#{@attacker.name} ran away successfully!"
    else
      next_turn
    end
  end

  def next_turn
    if @current_turn == :initiator
      @current_turn = :target
      @attacker = @target
      @defender = @initiator
    elsif @current_turn == :target
      @current_turn = :initiator
      @attacker = @initiator
      @defender = @target
    end

    turn
  end
end
