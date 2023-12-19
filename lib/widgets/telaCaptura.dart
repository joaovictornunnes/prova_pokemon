import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../ui/pokemon_floor.dart';
import '../domain/pokemon.dart';
import 'telaSobre.dart'; // Importe a TelaSobre

class TelaCaptura extends StatefulWidget {
  @override
  _TelaCapturaState createState() => _TelaCapturaState();
}

class _TelaCapturaState extends State<TelaCaptura> {
  List<Pokemon> pokemons = [];
  bool isConnected = false;
  int id = 0;
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    id = widget.id;
    
  }

  void checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isConnected = false;
      });
    } else {
      setState(() {
        isConnected = true;
      });
      fetchPokemons();
    }
  }

 void fetchPokemons() async {
  var random = Random();
  for (var i = 0; i < 6; i++) {
    var id = random.nextInt(1017); // Gera um id aleatório para cada Pokémon
    try {
      var response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$id'));
      // rest of your code
    } catch (e) {
      print('Failed to fetch Pokemon: $e');
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Captura'),
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
      body: isConnected
          ? ListView.builder(
  itemCount: pokemons.length,
  itemBuilder: (context, index) {
    var pokemon = pokemons[index];
    return ListTile(
      title: Column(
        children: <Widget>[
          Image.network(
            pokemon.imageUrl, // Certifique-se de que o objeto Pokemon tem uma propriedade imageUrl
            fit: BoxFit.fill,
          ),
          Text('ID: ${pokemon.id}'), // Exibe o ID do Pokemon
          Text('Name: ${pokemon.name}'), // Exibe o nome do Pokemon
        ],
      ),
      trailing: TextButton(
        child: Image.asset('prova_pokemon/assets/icon/pokebola.png'),
        onPressed: pokemon.isCaptured ? null : () => capturePokemon(pokemon),
      ),
    );
  },
)
          : Center(
              child: Text('Sem conexão com a internet.'),
            ),
    );
  }

  void capturePokemon(Pokemon pokemon) async {
    setState(() {
      pokemon.isCaptured = true;
    });

    pokemon.capture();

    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final pokemonDao = database.pokemonDao;
    await pokemonDao.insertPokemon(pokemon);
  }
}
