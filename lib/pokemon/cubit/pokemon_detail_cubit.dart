import 'package:bloc/bloc.dart';
import 'package:draftea_pokedex/pokemon/cubit/pokemon_detail_state.dart';
import 'package:draftea_pokedex/pokemon/data/pokemon_repository.dart';

class PokemonDetailCubit extends Cubit<PokemonDetailState> {
  PokemonDetailCubit({
    required PokemonRepository repository,
  })  : _repository = repository,
        super(const PokemonDetailState());

  final PokemonRepository _repository;

  /// Fetch Pokemon detail by ID
  Future<void> fetchPokemonDetail(int id) async {
    emit(state.copyWith(status: PokemonDetailStatus.loading));

    try {
      final detail = await _repository.getPokemonDetail(id);

      emit(
        state.copyWith(
          status: PokemonDetailStatus.success,
          pokemonDetail: detail,
        ),
      );
    } on Exception catch (error) {
      emit(
        state.copyWith(
          status: PokemonDetailStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  /// Clear the current Pokemon detail
  void clearDetail() {
    emit(const PokemonDetailState());
  }
}
