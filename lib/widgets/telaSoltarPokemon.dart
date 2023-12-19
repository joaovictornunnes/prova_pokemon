import 'package:flutter/material.dart';
import '../domain/pokemon.dart';
import '../ui/pokemonDao.dart';
import '../ui/pokemon_floor.dart';
import 'telaSobre.dart'; // Importe a TelaSobre

class TelaSoltarPokemon extends StatefulWidget {
  final int id;

  TelaSoltarPokemon({required this.id});

  @override
  _TelaSoltarPokemonState createState() => _TelaSoltarPokemonState();
}

class _TelaSoltarPokemonState extends State<TelaSoltarPokemon> {
  late Future<Pokemon?> futurePokemon;
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

  Future<Pokemon?> getPokemon() async {
    return pokemonDao.findPokemonById(widget.id);
  }

  void deletePokemon(Pokemon pokemon) async {
    await pokemonDao.deletePokemon(pokemon);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Soltar Pokémon'),
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
      body: FutureBuilder<Pokemon?>(
        future: futurePokemon,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return Center(child: Text('Ocorreu um erro!'));
          } else if (snapshot.data == null) {
            return Center(child: Text('Nenhum dado encontrado.'));
          } else {
            return Column(
              children: <Widget>[
                Text('Nome: ${snapshot.data!.name}'),
                Text('ID: ${snapshot.data!.id}'),
                // Adicione a imagem do Pokémon aqui...
                ElevatedButton(
                  onPressed: () => deletePokemon(snapshot.data!),
                  child: Text('Confirmar'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}