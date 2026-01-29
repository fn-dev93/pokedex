import 'package:draftea_pokedex/pokemon/models/models.dart';
import 'package:equatable/equatable.dart';

enum PokemonListStatus { initial, loading, success, failure }

class PokemonListState extends Equatable {
  const PokemonListState({
    this.status = PokemonListStatus.initial,
    this.pokemonList = const [],
    this.hasReachedMax = false,
    this.errorMessage,
    this.currentPage = 0,
  });

  final PokemonListStatus status;
  final List<Pokemon> pokemonList;
  final bool hasReachedMax;
  final String? errorMessage;
  final int currentPage;

  PokemonListState copyWith({
    PokemonListStatus? status,
    List<Pokemon>? pokemonList,
    bool? hasReachedMax,
    String? errorMessage,
    int? currentPage,
  }) {
    return PokemonListState(
      status: status ?? this.status,
      pokemonList: pokemonList ?? this.pokemonList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props =>
      [status, pokemonList, hasReachedMax, errorMessage, currentPage];
}
