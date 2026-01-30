import 'package:draftea_pokedex/pokemon/data/pokemon_api_client.dart';
import 'package:draftea_pokedex/pokemon/data/pokemon_local_data_source.dart';
import 'package:draftea_pokedex/pokemon/models/models.dart';

class PokemonRepository {
  PokemonRepository({
    PokemonApiClient? apiClient,
    PokemonLocalDataSource? localDataSource,
  }) : _apiClient = apiClient ?? PokemonApiClient(),
       _localDataSource = localDataSource ?? PokemonLocalDataSource();

  final PokemonApiClient _apiClient;
  final PokemonLocalDataSource _localDataSource;

  /// Fetches Pokemon list with offline-first strategy
  /// - First tries to fetch from API
  /// - If API fails, falls back to cached data
  /// - Caches successful API responses
  Future<List<Pokemon>> getPokemonList({
    required int limit,
    required int offset,
  }) async {
    try {
      // Try to fetch from API
      final pokemonList = await _apiClient.getPokemonList(
        limit: limit,
        offset: offset,
      );

      // Cache only new Pokemon (not already in cache)
      await _localDataSource.savePokemonList(pokemonList);

      return pokemonList;
    } on Exception catch (_) {
      // If API fails, try to get cached data
      final cachedData = await _localDataSource.getPokemonList();

      if (cachedData.isEmpty) {
        throw PokemonRepositoryException(
          'No internet connection and no cached data available',
        );
      }

      // Return a subset of cached data matching the requested offset/limit
      final endIndex = offset + limit;
      if (offset >= cachedData.length) {
        return [];
      }

      final lastIndex = endIndex > cachedData.length
          ? cachedData.length
          : endIndex;
      return cachedData.sublist(offset, lastIndex);
    }
  }

  /// Fetches Pokemon detail with offline-first strategy
  /// - First tries to fetch from API
  /// - If API fails, falls back to cached data
  /// - Caches successful API responses
  Future<PokemonDetail> getPokemonDetail(int id) async {
    try {
      // Try to fetch from API
      final detail = await _apiClient.getPokemonDetail(id);

      // Cache the result
      await _localDataSource.savePokemonDetail(detail);

      return detail;
    } on Exception catch (_) {
      // If API fails, try to get cached data
      final cachedDetail = await _localDataSource.getPokemonDetail(id);

      if (cachedDetail == null) {
        throw PokemonRepositoryException(
          'No internet connection and no cached data available for '
          'Pokemon #$id',
        );
      }

      return cachedDetail;
    }
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    await _localDataSource.clearCache();
  }
}

class PokemonRepositoryException implements Exception {
  PokemonRepositoryException(this.message);
  final String message;

  @override
  String toString() => message;
}
