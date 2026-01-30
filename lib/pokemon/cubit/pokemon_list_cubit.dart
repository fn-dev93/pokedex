import 'package:bloc/bloc.dart';
import 'package:draftea_pokedex/pokemon/cubit/pokemon_list_state.dart';
import 'package:draftea_pokedex/pokemon/data/pokemon_repository.dart';

class PokemonListCubit extends Cubit<PokemonListState> {
  PokemonListCubit({
    required PokemonRepository repository,
  }) : _repository = repository,
       super(const PokemonListState());

  final PokemonRepository _repository;
  static const int _pageSize = 20;

  /// Fetch the initial page of Pokemon
  Future<void> fetchPokemon() async {
    if (state.status == PokemonListStatus.loading) return;

    emit(state.copyWith(status: PokemonListStatus.loading));

    try {
      final pokemonList = await _repository.getPokemonList(
        limit: _pageSize,
        offset: 0,
      );

      emit(
        state.copyWith(
          status: PokemonListStatus.success,
          pokemonList: pokemonList,
          hasReachedMax: pokemonList.length < _pageSize,
          currentPage: 1,
        ),
      );
    } on Exception catch (error) {
      emit(
        state.copyWith(
          status: PokemonListStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  /// Fetch the next page of Pokemon (for pagination)
  Future<void> fetchMorePokemon() async {
    if (state.hasReachedMax || state.status == PokemonListStatus.loading) {
      return;
    }

    try {
      // Use the actual length of pokemonList as offset to ensure continuity
      final offset = state.pokemonList.length;
      final newPokemon = await _repository.getPokemonList(
        limit: _pageSize,
        offset: offset,
      );

      if (newPokemon.isEmpty) {
        emit(state.copyWith(hasReachedMax: true));
      } else {
        emit(
          state.copyWith(
            status: PokemonListStatus.success,
            pokemonList: {...state.pokemonList, ...newPokemon}.toList(),
            hasReachedMax: newPokemon.length < _pageSize,
            currentPage: state.currentPage + 1,
          ),
        );
      }
    } on Exception catch (error) {
      emit(
        state.copyWith(
          status: PokemonListStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  /// Refresh the Pokemon list
  Future<void> refreshPokemon() async {
    emit(const PokemonListState());
    await fetchPokemon();
  }

  /// Clear cached data
  Future<void> clearCache() async {
    await _repository.clearCache();
  }
}
