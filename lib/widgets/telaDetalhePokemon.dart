import 'package:flutter/material.dart';
import '../domain/pokemon.dart';
import '../ui/pokemonDao.dart';
import '../ui/pokemon_floor.dart';
import 'telaSobre.dart';

class TelaDetalhesPokemon extends StatefulWidget {
  final int id;

  TelaDetalhesPokemon({required this.id});

  @override
  _TelaDetalhesPokemonState createState() => _TelaDetalhesPokemonState();
}

class _TelaDetalhesPokemonState extends State<TelaDetalhesPokemon> {
  Future<Pokemon?>? futurePokemon;
  late Future<PokemonDao> pokemonDao;

  @override
  void initState() {
    super.initState();
    pokemonDao = initializeDbAndDao();
    pokemonDao.then((dao) {
      setState(() {
        futurePokemon = getPokemon(dao);
      });
    });
  }


  Future<PokemonDao> initializeDbAndDao() async {
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    return database.pokemonDao;
  }

  Future<Pokemon?> getPokemon(PokemonDao dao) async {
  return dao.findPokemonById(widget.id);
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
      body: FutureBuilder<Pokemon?>(
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
                Image.network(
                  'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${snapshot.data!.id}.png',
                  height: 100,
                  width: 100,
                ),
                Text('Nome: ${snapshot.data!.name}'),
                Text('ID: ${snapshot.data!.id}'),
                Text('Base Experience: ${snapshot.data!.baseExperience}'),
                Text('Altura: ${snapshot.data!.height}'),
                Text('Peso: ${snapshot.data!.weight}'),
                
              ],
            );
          }
        },
      ),
    );
  }
}
