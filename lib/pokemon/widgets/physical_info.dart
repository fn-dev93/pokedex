import 'package:draftea_pokedex/l10n/l10n.dart';
import 'package:draftea_pokedex/pokemon/models/models.dart';
import 'package:draftea_pokedex/pokemon/widgets/widgets.dart';
import 'package:flutter/material.dart';

class PhysicalInfo extends StatelessWidget {
  const PhysicalInfo({
    required this.detail,
    super.key,
  });

  final PokemonDetail detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InfoCard(
            label: context.l10n.height,
            value: '${(detail.height / 10).toStringAsFixed(1)} m',
            icon: Icons.height,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: InfoCard(
            label: context.l10n.weight,
            value: '${(detail.weight / 10).toStringAsFixed(1)} kg',
            icon: Icons.monitor_weight,
          ),
        ),
      ],
    );
  }
}
