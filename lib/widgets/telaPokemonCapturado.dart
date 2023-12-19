import 'package:flutter/material.dart';
import '../ui/pokemon_floor.dart';
import '../domain/pokemon.dart';
import 'telaDetalhePokemon.dart';
import 'telaSoltarPokemon.dart';
import 'telaSobre.dart'; // Importe a TelaSobre

class TelaPokemonCapturado extends StatefulWidget {
  @override
  _TelaPokemonCapturadoState createState() => _TelaPokemonCapturadoState();
}

class _TelaPokemonCapturadoState extends State<TelaPokemonCapturado> {
  late Future<List<Pokemon>> futurePokemons;

  @override
  void initState() {
    super.initState();
    futurePokemons = getPokemonsCapturados();
  }

  Future<List<Pokemon>> getPokemonsCapturados() async {
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final pokemonDao = database.pokemonDao;
    return pokemonDao.findAllPokemons(); // Substitua por sua função que retorna apenas Pokémons capturados
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokémons Capturados'),
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
      body: FutureBuilder<List<Pokemon>>(
        future: futurePokemons,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            // Se algo der errado...
            return Center(child: Text('Ocorreu um erro!'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            // Se não houver Pokémons capturados...
            return Center(child: Text('Nenhum Pokémon capturado ainda.'));
          } else {
            // Se houver Pokémons capturados...
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (ctx, i) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaDetalhesPokemon(id: snapshot.data![i].id),
                    ),
                  );
                },
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaSoltarPokemon(id: snapshot.data![i].id),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(snapshot.data![i].name),
                  // Adicione mais detalhes sobre o Pokémon aqui...
                ),
              ),
            );
          }
        },
      ),
    );
  } 
}