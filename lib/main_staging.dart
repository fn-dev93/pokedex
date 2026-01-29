import 'package:draftea_pokedex/app/app.dart';
import 'package:draftea_pokedex/bootstrap.dart';
import 'package:draftea_pokedex/pokemon/pokemon.dart';

Future<void> main() async {
  await bootstrap(() => App(pokemonRepository: PokemonRepository()));
}
