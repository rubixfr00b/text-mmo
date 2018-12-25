# The Command class handles parsing a command
class Command
  attr_reader :entry, :flags, :args, :targets

  def initialize(command)
    @flags = {}
    @targets = []
    @args = command.downcase.split
    @entry = @args.shift

    parse
  end

  def flag(flag)
    @flags[flag]
  end

  def arg(index)
    @args[index]
  end

  def target(index)
    @targets[index]
  end

  def parse
    @args.each_index do |index|
      arg = @args[index]
      next_arg = @args[index + 1]

      next if already_parsed_arg(arg)
      next if parse_target(arg)

      flag = parse_flag(arg)
      next if next_arg.nil? || flag.nil?

      parse_flag_value(flag, next_arg)
    end
  end

  def already_parsed_arg(arg)
    return true if @flags[arg] || @flags.value?(arg) || @targets.include?(arg)

    false
  end

  def parse_flag(arg)
    return unless arg.include?('--')

    flag = arg.delete('--')
    @flags[flag] = true

    flag
  end

  def parse_flag_value(flag, next_arg)
    return if next_arg.include?('--')

    @flags[flag] = next_arg

    true
  end

  def parse_target(arg)
    return if arg.include?('--')

    @targets.push(arg)

    true
  end
end

command = Command.new("asd target --flag test --wew --wow")

puts command.targets
