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
  /// Maintains order by using sequential indices
  Future<void> savePokemonList(List<Pokemon> pokemonList) async {
    final box = await _pokemonBox;
    
    // Get current list from cache
    final currentList = await getPokemonList();
    final existingIds = currentList.map((p) => p.id).toSet();

    // Only add Pokemon that don't exist yet
    final newPokemon = pokemonList
        .where((p) => !existingIds.contains(p.id))
        .toList();

    if (newPokemon.isEmpty) return;

    // Append new Pokemon to the existing list maintaining order
    final updatedList = {...currentList, ...newPokemon}.toList();

    // Clear and save the complete list with sequential keys to maintain order
    await box.clear();
    for (var i = 0; i < updatedList.length; i++) {
      await box.put(i, updatedList[i]);
    }
  }

  /// Get Pokemon list from local storage
  /// Returns list in the order it was stored
  Future<List<Pokemon>> getPokemonList() async {
    final box = await _pokemonBox;
    if (box.isEmpty) return [];

    // Get all keys, sort them, and retrieve values in order
    final keys = box.keys.toList()..sort();
    return keys.map((key) => box.get(key)!).toList();
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
