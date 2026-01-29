import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'pokemon.g.dart';

@HiveType(typeId: 0)
class Pokemon extends Equatable {
  const Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final id = _extractIdFromUrl(json['url'] as String? ?? '');
    return Pokemon(
      id: id,
      name: json['name'] as String? ?? '',
      imageUrl: _getImageUrl(id),
    );
  }

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String imageUrl;

  static int _extractIdFromUrl(String url) {
    final parts = url.split('/').where((p) => p.isNotEmpty).toList();
    return int.tryParse(parts.last) ?? 0;
  }

  static String _getImageUrl(int id) {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  @override
  List<Object?> get props => [id, name, imageUrl];
}
