import 'package:draftea_pokedex/app/router/app_router.dart';
import 'package:draftea_pokedex/l10n/l10n.dart';
import 'package:draftea_pokedex/pokemon/pokemon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({required this.pokemonRepository, super.key});

  final PokemonRepository pokemonRepository;

  @override
  Widget build(BuildContext context) {
    final router = AppRouter().router;

    return RepositoryProvider.value(
      value: pokemonRepository,
      child: BlocProvider(
        create: (_) => PokemonListCubit(repository: pokemonRepository),
        child: MaterialApp.router(
          title: 'Pokédex',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            useMaterial3: true,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
  }
}
