import 'package:draftea_pokedex/pokemon/models/models.dart';
import 'package:hive/hive.dart';

class PokemonLocalDataSource {
  static const String _pokemonBoxName = 'pokemon_box';
  static const String _pokemonDetailBoxName = 'pokemon_detail_box';

  Future<Box<Pokemon>> get _pokemonBox async {
    if (!Hive.isBoxOpen(_pokemonBoxName)) {
      return Hive.openBox<Pokemon>(_pokemonBoxName);
    }
    return Hive.box<Pokemon>(_pokemonBoxName);
  }

  Future<Box<PokemonDetail>> get _pokemonDetailBox async {
    if (!Hive.isBoxOpen(_pokemonDetailBoxName)) {
      return Hive.openBox<PokemonDetail>(_pokemonDetailBoxName);
    }
    return Hive.box<PokemonDetail>(_pokemonDetailBoxName);
  }

  /// Save Pokemon list to local storage
  Future<void> savePokemonList(List<Pokemon> pokemonList) async {
    final box = await _pokemonBox;
    final pokemonMap = {for (final p in pokemonList) p.id: p};
    await box.putAll(pokemonMap);
  }

  /// Get Pokemon list from local storage
  Future<List<Pokemon>> getPokemonList() async {
    final box = await _pokemonBox;
    return box.values.toList()..sort((a, b) => a.id.compareTo(b.id));
  }

  /// Save Pokemon detail to local storage
  Future<void> savePokemonDetail(PokemonDetail detail) async {
    final box = await _pokemonDetailBox;
    await box.put(detail.id, detail);
  }

  /// Get Pokemon detail from local storage
  Future<PokemonDetail?> getPokemonDetail(int id) async {
    final box = await _pokemonDetailBox;
    return box.get(id);
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    final pokemonBox = await _pokemonBox;
    final detailBox = await _pokemonDetailBox;
    await pokemonBox.clear();
    await detailBox.clear();
  }
}
