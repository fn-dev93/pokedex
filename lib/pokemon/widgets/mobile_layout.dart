import 'package:draftea_pokedex/pokemon/models/models.dart';
import 'package:draftea_pokedex/pokemon/widgets/widgets.dart';
import 'package:flutter/material.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({
    required this.detail,
    super.key,
  });

  final PokemonDetail detail;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ImageSection(detail: detail),
          InfoSection(detail: detail),
        ],
      ),
    );
  }
}
