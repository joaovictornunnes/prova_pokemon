import 'package:floor/floor.dart';
import 'pokemon.dart';

@dao
abstract class PokemonDao {
  @Query('SELECT * FROM Pokemon')
  Future<List<Pokemon>> findAllPokemons();

  @Query('SELECT * FROM Pokemon WHERE id = :id')
  Stream<Pokemon> findPokemonById(int id);

  @insert
  Future<void> insertPokemon(Pokemon pokemon);

  @delete
  Future<void> deletePokemon(Pokemon pokemon);
}