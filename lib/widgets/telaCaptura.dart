import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../domain/pokemon.dart';
import '../ui/pokemonDao.dart';
import '../ui/pokemon_floor.dart';

Future<Pokemon> fetchPokemonDetails(String url) async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> pokemonData = jsonDecode(response.body);
    return Pokemon.fromJson(pokemonData);
  } else {
    throw Exception('Failed to load Pokémon details');
  }
}

Future<List<Pokemon>> fetchPokemonList(List<int> pokemonIds) async {
  final List<Pokemon> pokemonList = [];

  for (var id in pokemonIds) {
    final url = 'https://pokeapi.co/api/v2/pokemon/$id';
    final pokemon = await fetchPokemonDetails(url);
    pokemonList.add(pokemon);
  }

  return pokemonList;
}

class TelaCaptura extends StatefulWidget {
  const TelaCaptura({Key? key}) : super(key: key);

  @override
  State<TelaCaptura> createState() => _TelaCapturaState();
}

class _TelaCapturaState extends State<TelaCaptura> {
  late Future<List<Pokemon>> futurePokemonList;
  late PokemonDao pokemonDao;
  @override
  void initState() {
    super.initState();
    _initializeDao();
    // Gere 6 números aleatórios entre 0 e 1017
    final List<int> randomPokemonIds =
        List.generate(6, (index) => Random().nextInt(1018));
    futurePokemonList = fetchPokemonList(randomPokemonIds);
  }

  void _initializeDao() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    pokemonDao = database.pokemonDao;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon List'),
      ),
      body: Center(
        child: FutureBuilder<List<Pokemon>>(
          future: futurePokemonList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final pokemon = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.network(
                          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemon.id}.png',
                          height: 100,
                          width: 100,
                        ), // Adjust the size as needed
                        Text('Name: ${pokemon.name}'),
                        Text('ID: ${pokemon.id}'),
                        Text(
                            'Base Experience: ${pokemon.baseExperience.toString()}'),
                        GestureDetector(
                          onTap: () async {
                            // Marque o Pokémon como capturado
                            pokemon.capture();

                            // Verifique se o Pokémon já existe no banco de dados
                            final existingPokemon =
                                await pokemonDao.findPokemonById(pokemon.id);

                            // Se o Pokémon não existir, insira-o no banco de dados
                            if (existingPokemon == null) {
                              await pokemonDao.insertPokemon(pokemon);
                            }

                            // Atualize a UI se necessário
                            setState(() {});
                          },
                          child: Image.asset(
                            'assets/icon/pokebola.png',
                            height: 50, // Adjust the size as needed
                            width: 50,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
