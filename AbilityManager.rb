require 'json'

class Manager
  def initialize 
    @abilities = abilities
  end

  def get_by_id(id) 
    @npcs.find { |being| being["id"] == id }
  end

  def generate_id
    ids = @npcs.map do |being|
      being["id"]
    end

    # Generate random string of 0-9 and a-z, 4 chars in length
    id = rand(36**4).to_s(36)

    if ids.include?(id)
      generate_id
    else
      id
    end
  end

  # Push an NPC to the NPC registry, then write the new NPC list to the disk
  def add_npc(being_config)
    being_config["id"] = generate_id

    @npcs.push(being_config)

    write_npcs
  end

  def write_npcs
    json = JSON.pretty_generate(@npcs)

    File.open("data/npcs.json", "w") do |f|
      f.write(json)
    end
  end

  def abilities
    JSON.parse(File.read('data/abilities.json'))
  end
end
