// Ignore for testing purposes
// ignore_for_file: prefer_const_constructors

import 'package:draftea_pokedex/app/app.dart';
import 'package:draftea_pokedex/pokemon/pokemon.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App', () {
    testWidgets('renders PokemonListPage', (tester) async {
      await tester.pumpWidget(
        App(pokemonRepository: PokemonRepository()),
      );
      expect(find.byType(PokemonListPage), findsOneWidget);
    });
  });
}
