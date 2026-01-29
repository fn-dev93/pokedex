import 'package:draftea_pokedex/pokemon/models/models.dart';
import 'package:equatable/equatable.dart';

enum PokemonDetailStatus { initial, loading, success, failure }

class PokemonDetailState extends Equatable {
  const PokemonDetailState({
    this.status = PokemonDetailStatus.initial,
    this.pokemonDetail,
    this.errorMessage,
  });

  final PokemonDetailStatus status;
  final PokemonDetail? pokemonDetail;
  final String? errorMessage;

  PokemonDetailState copyWith({
    PokemonDetailStatus? status,
    PokemonDetail? pokemonDetail,
    String? errorMessage,
  }) {
    return PokemonDetailState(
      status: status ?? this.status,
      pokemonDetail: pokemonDetail ?? this.pokemonDetail,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, pokemonDetail, errorMessage];
}
