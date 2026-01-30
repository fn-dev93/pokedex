import 'package:draftea_pokedex/l10n/l10n.dart';
import 'package:draftea_pokedex/pokemon/helpers/helpers.dart';
import 'package:draftea_pokedex/pokemon/models/models.dart';
import 'package:flutter/material.dart';

class TypesSection extends StatelessWidget {
  const TypesSection({
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
          context.l10n.types,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: detail.types
              .map(
                (type) => Chip(
                  label: Text(
                    type.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: getTypeColor(type),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
