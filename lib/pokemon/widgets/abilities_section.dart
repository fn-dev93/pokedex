import 'package:draftea_pokedex/l10n/l10n.dart';
import 'package:draftea_pokedex/pokemon/models/models.dart';
import 'package:flutter/material.dart';

class AbilitiesSection extends StatelessWidget {
  const AbilitiesSection({
    required this.detail,
    super.key,
  });

  final PokemonDetail detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.abilities,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: detail.abilities
              .map(
                (ability) => Chip(
                  label: Text(ability.replaceAll('-', ' ').toUpperCase()),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
