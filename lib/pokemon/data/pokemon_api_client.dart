import 'package:dio/dio.dart';
import 'package:draftea_pokedex/pokemon/models/models.dart';

class PokemonApiClient {
  PokemonApiClient({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: _baseUrl));

  static const _baseUrl = 'https://pokeapi.co/api/v2';
  final Dio _dio;

  /// Fetches a paginated list of Pokemon
  Future<List<Pokemon>> getPokemonList({
    required int limit,
    required int offset,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/pokemon',
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
      );

      final results = response.data?['results'] as List<dynamic>? ?? [];
      return results
          .map((json) => Pokemon.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw PokemonApiException('Failed to fetch Pokemon list: $e');
    }
  }

  /// Fetches detailed information for a specific Pokemon
  Future<PokemonDetail> getPokemonDetail(int id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/pokemon/$id');

      if (response.data == null) {
        throw PokemonApiException('Pokemon not found');
      }

      return PokemonDetail.fromJson(response.data!);
    } catch (e) {
      throw PokemonApiException('Failed to fetch Pokemon detail: $e');
    }
  }
}

class PokemonApiException implements Exception {
  PokemonApiException(this.message);
  final String message;

  @override
  String toString() => message;
}
