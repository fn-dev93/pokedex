import 'package:draftea_pokedex/pokemon/models/models.dart';
import 'package:draftea_pokedex/pokemon/widgets/widgets.dart';
import 'package:flutter/material.dart';

class PokemonDetailContent extends StatelessWidget {
  const PokemonDetailContent({
    required this.detail,
    super.key,
  });

  final PokemonDetail detail;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isDesktop || isLandscape) {
      return DesktopLayout(detail: detail);
    }

    return MobileLayout(detail: detail);
  }
}
