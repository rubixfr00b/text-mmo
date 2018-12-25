load 'being.rb'

# There is only one Player, for now.
class Player < Being
  def initialize
    super(being_config)

    listen
  end

  def being_config
    {
      'name' => name
    }
  end

  def name
    print 'Enter your name: '
    gets.to_s
  end

  def listen
    print "#{@name}$ "
    gets.to_s
  end
end
