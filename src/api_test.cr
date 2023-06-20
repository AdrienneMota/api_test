require "kemal"

get "/" do
  pokemons.to_json
end

get "/:id" do |context|
  pokemonId = context.params.url["id"]

  pokemon = pokemons.find { |pokemon| pokemon[:id] === pokemonId }
  pokemon.to_json
end

post "/" do |env|
  pokemonName = env.params.json["name"].as(String)
  pokemonType = env.params.json["type"].as(String)

  pokemon = {
    id: "#{pokemons.size + 1}",
    name: pokemonName,
    type: pokemonType,
  }

  pokemons.push(pokemon)

  pokemons.to_json
end

put "/:id" do |env|
  pokemonId = env.params.url["id"]
  pokemonName = env.params.json["name"].as(String)
  pokemonType = env.params.json["type"].as(String)

  pokemon = {
    id: pokemonId, name: pokemonName, type: pokemonType
  }

  pokemonIndex = pokemons.bsearch_index{ |pokemon, i| pokemon[:id] === pokemonId}

  if pokemonIndex != nil
    pokemons[pokemonIndex.as(Int32)] = pokemon
    else
      pokemons.push(pokemon) 
  end

  pokemon.to_json
end

delete "/:id" do |env|

  pokemonId = env.params.url["id"].as(String)
  pokemonIndex = pokemons.bsearch_index{|pokemon, id|pokemon[:id] === pokemonId}

  if pokemonIndex != nil
    pokemons.delete_at(pokemonIndex.as(Int32)).to_json
  end

end

Kemal.run