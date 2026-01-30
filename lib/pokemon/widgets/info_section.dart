import 'package:draftea_pokedex/pokemon/models/models.dart';
import 'package:draftea_pokedex/pokemon/widgets/widgets.dart';
import 'package:flutter/material.dart';

class InfoSection extends StatelessWidget {
  const InfoSection({
    required this.detail,
    super.key,
  });

  final PokemonDetail detail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TypesSection(detail: detail),
          const SizedBox(height: 24),
          PhysicalInfo(detail: detail),
          const SizedBox(height: 24),
          AbilitiesSection(detail: detail),
          const SizedBox(height: 24),
          StatsSection(detail: detail),
        ],
      ),
    );
  }
}
