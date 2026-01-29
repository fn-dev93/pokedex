import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'pokemon_detail.g.dart';

@HiveType(typeId: 1)
class PokemonDetail extends Equatable {
  const PokemonDetail({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.height,
    required this.weight,
    required this.types,
    required this.abilities,
    required this.stats,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    final sprites = json['sprites'] as Map<String, dynamic>? ?? {};
    final other = sprites['other'] as Map<String, dynamic>? ?? {};
    final officialArtwork =
        other['official-artwork'] as Map<String, dynamic>? ?? {};

    final types = (json['types'] as List<dynamic>?)
            ?.map((t) => (t['type']['name'] as String?) ?? '')
            .toList() ??
        [];

    final abilities = (json['abilities'] as List<dynamic>?)
            ?.map((a) => (a['ability']['name'] as String?) ?? '')
            .toList() ??
        [];

    final stats = (json['stats'] as List<dynamic>?)
            ?.map(
              (s) => PokemonStat(
                name: (s['stat']['name'] as String?) ?? '',
                value: (s['base_stat'] as int?) ?? 0,
              ),
            )
            .toList() ??
        [];

    return PokemonDetail(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      imageUrl: officialArtwork['front_default'] as String? ?? '',
      height: json['height'] as int? ?? 0,
      weight: json['weight'] as int? ?? 0,
      types: types,
      abilities: abilities,
      stats: stats,
    );
  }

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final int height;

  @HiveField(4)
  final int weight;

  @HiveField(5)
  final List<String> types;

  @HiveField(6)
  final List<String> abilities;

  @HiveField(7)
  final List<PokemonStat> stats;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'height': height,
      'weight': weight,
      'types': types,
      'abilities': abilities,
      'stats': stats.map((s) => s.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props =>
      [id, name, imageUrl, height, weight, types, abilities, stats];
}

@HiveType(typeId: 2)
class PokemonStat extends Equatable {
  const PokemonStat({
    required this.name,
    required this.value,
  });

  factory PokemonStat.fromJson(Map<String, dynamic> json) {
    return PokemonStat(
      name: json['name'] as String? ?? '',
      value: json['value'] as int? ?? 0,
    );
  }

  @HiveField(0)
  final String name;

  @HiveField(1)
  final int value;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }

  @override
  List<Object?> get props => [name, value];
}
