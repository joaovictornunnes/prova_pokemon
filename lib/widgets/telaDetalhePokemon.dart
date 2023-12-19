import 'package:flutter/material.dart';
import '../domain/pokemon.dart';
import '../ui/pokemonDao.dart';
import '../ui/pokemon_floor.dart';
import 'telaSobre.dart'; // Importe a TelaSobre

class TelaDetalhesPokemon extends StatefulWidget {
  final int id;

  TelaDetalhesPokemon({required this.id});

  @override
  _TelaDetalhesPokemonState createState() => _TelaDetalhesPokemonState();
}

class _TelaDetalhesPokemonState extends State<TelaDetalhesPokemon> {
  late Future<Pokemon>? futurePokemon;
  late PokemonDao pokemonDao;

  @override
  void initState() {
    super.initState();
    initializeDbAndDao();
    futurePokemon = getPokemon();
  }

  void initializeDbAndDao() async {
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    pokemonDao = database.pokemonDao;
  }

  Future<Pokemon> getPokemon() async {
    final pokemon = await pokemonDao.findPokemonById(widget.id);
    if (pokemon != null) {
      return pokemon;
    } else {
      throw Exception('Pokemon not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Pokémon'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaSobre()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Pokemon>(
        future: futurePokemon,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            // Se algo der errado...
            return Center(child: Text('Ocorreu um erro!'));
          } else if (snapshot.data == null) {
            // Se não houver dados...
            return Center(child: Text('Nenhum dado encontrado.'));
          } else {
            // Se houver dados...
            return Column(
              children: <Widget>[
                Text('Nome: ${snapshot.data!.name}'),
                Text('ID: ${snapshot.data!.id}'),
                // Adicione mais detalhes sobre o Pokémon aqui...
              ],
            );
          }
        },
      ),
    );
  }
}