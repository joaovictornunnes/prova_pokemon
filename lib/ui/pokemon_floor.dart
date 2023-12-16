import 'package:floor/floor.dart';
import 'pokemon.dart';
import 'pokemon_dao.dart';

part 'app_database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Pokemon])
abstract class AppDatabase extends FloorDatabase {
  PokemonDao get pokemonDao;
}