import 'package:draftea_pokedex/pokemon/view/pokemon_detail_page.dart';
import 'package:draftea_pokedex/pokemon/view/pokemon_list_page.dart';
import 'package:go_router/go_router.dart';

/// A class responsible for handling the application's routing logic.
///
/// The [AppRouter] manages navigation between different screens and defines
/// the available routes within the application.
class AppRouter {
  AppRouter();

  GoRouter get router => GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const PokemonListPage(),
        routes: [
          GoRoute(
            path: 'pokemon/:id',
            name: 'pokemon-detail',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return PokemonDetailPage(pokemonId: id);
            },
          ),
        ],
      ),
    ],
  );
}
