import 'package:json_annotation/json_annotation.dart';

part '../pokemon.g.dart';

@JsonSerializable()
class Pokemon {
  final int id;
  final String name;
  final int height;
  final int weight;
  final String sprite;
  final String type;

  Pokemon({required this.id, required this.name, required this.height, required this.weight, required this.sprite, required this.type});

  factory Pokemon.fromJson(Map<String, dynamic> json) => _$PokemonFromJson(json);
  Map<String, dynamic> toJson() => _$PokemonToJson(this);
}