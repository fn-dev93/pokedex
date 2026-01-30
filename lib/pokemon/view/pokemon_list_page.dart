import 'package:draftea_pokedex/app/app.dart';
import 'package:draftea_pokedex/l10n/l10n.dart';
import 'package:draftea_pokedex/pokemon/cubit/pokemon_list_cubit.dart';
import 'package:draftea_pokedex/pokemon/cubit/pokemon_list_state.dart';
import 'package:draftea_pokedex/pokemon/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PokemonListPage extends StatelessWidget {
  const PokemonListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PokemonListView();
  }
}

class PokemonListView extends StatefulWidget {
  const PokemonListView({super.key});

  @override
  State<PokemonListView> createState() => _PokemonListViewState();
}

class _PokemonListViewState extends State<PokemonListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<PokemonListCubit>().fetchPokemon();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PokemonListCubit>().fetchMorePokemon();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  Future<bool> _onWillPop(BuildContext context) async {
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.exitAppTitle),
        content: Text(context.l10n.exitAppMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.l10n.exit),
          ),
        ],
      ),
    );
    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop(context);
        if (shouldPop && context.mounted) {
          await SystemNavigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.pokedexTitle),
          actions: [
            if (kDebugMode)
              IconButton(
                icon: const Icon(Icons.delete_forever),
                onPressed: context.read<PokemonListCubit>().clearCache,
              ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: context.read<PokemonListCubit>().refreshPokemon,
            ),
          ],
        ),
        body: BlocBuilder<PokemonListCubit, PokemonListState>(
          builder: (context, state) {
            switch (state.status) {
              case PokemonListStatus.initial:
              case PokemonListStatus.loading:
                if (state.pokemonList.isEmpty) {
                  return const Center(child: PokeballLoading());
                }
                return _buildPokemonList(state, hasMore: true);

              case PokemonListStatus.failure:
                if (state.pokemonList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          context.l10n.errorMessage(
                            state.errorMessage ?? context.l10n.unknownError,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<PokemonListCubit>().fetchPokemon();
                          },
                          child: Text(context.l10n.retry),
                        ),
                      ],
                    ),
                  );
                }
                return _buildPokemonList(state);

              case PokemonListStatus.success:
                if (state.pokemonList.isEmpty) {
                  return Center(
                    child: Text(context.l10n.noPokemonFound),
                  );
                }
                return _buildPokemonList(
                  state,
                  hasMore: !state.hasReachedMax,
                );
            }
          },
        ),
      ),
    );
  }

  Widget _buildPokemonList(PokemonListState state, {bool hasMore = false}) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = _getCrossAxisCount(width);

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<PokemonListCubit>().refreshPokemon();
      },
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: hasMore
            ? state.pokemonList.length + 1
            : state.pokemonList.length,
        itemBuilder: (context, index) {
          if (index >= state.pokemonList.length) {
            return const Center(child: PokeballLoading());
          }
          return PokemonCard(pokemon: state.pokemonList[index]);
        },
      ),
    );
  }

  int _getCrossAxisCount(double width) {
    if (width >= 1400) return 8;
    if (width >= 1200) return 6;
    if (width >= 900) return 5;
    if (width >= 600) return 4;
    return 2;
  }
}
