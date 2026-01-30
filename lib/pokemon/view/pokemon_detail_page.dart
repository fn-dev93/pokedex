import 'package:draftea_pokedex/app/app.dart';
import 'package:draftea_pokedex/l10n/l10n.dart';
import 'package:draftea_pokedex/pokemon/cubit/pokemon_detail_cubit.dart';
import 'package:draftea_pokedex/pokemon/cubit/pokemon_detail_state.dart';
import 'package:draftea_pokedex/pokemon/data/pokemon_repository.dart';
import 'package:draftea_pokedex/pokemon/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PokemonDetailPage extends StatelessWidget {
  const PokemonDetailPage({
    required this.pokemonId,
    super.key,
  });

  final int pokemonId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PokemonDetailCubit(
        repository: context.read<PokemonRepository>(),
      )..fetchPokemonDetail(pokemonId),
      child: const PokemonDetailView(),
    );
  }
}

class PokemonDetailView extends StatelessWidget {
  const PokemonDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.pokemonDetail),
        ),
        body: BlocBuilder<PokemonDetailCubit, PokemonDetailState>(
          builder: (context, state) {
            switch (state.status) {
              case PokemonDetailStatus.initial:
              case PokemonDetailStatus.loading:
                return const Center(child: PokeballLoading());

              case PokemonDetailStatus.failure:
                return NoInternetConnetion(
                  errorMessage: state.errorMessage ?? context.l10n.unknownError,
                );

              case PokemonDetailStatus.success:
                final detail = state.pokemonDetail!;
                return PokemonDetailContent(detail: detail);
            }
          },
        ),
      ),
    );
  }
}
