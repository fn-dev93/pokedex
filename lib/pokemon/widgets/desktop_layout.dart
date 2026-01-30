import 'package:draftea_pokedex/pokemon/models/models.dart';
import 'package:draftea_pokedex/pokemon/widgets/widgets.dart';
import 'package:flutter/material.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({
    required this.detail,
    super.key,
  });

  final PokemonDetail detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: ImageSection(detail: detail),
          ),
        ),
        Expanded(
          flex: 4,
          child: SingleChildScrollView(
            child: InfoSection(detail: detail),
          ),
        ),
      ],
    );
  }
}
