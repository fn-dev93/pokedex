import 'package:draftea_pokedex/pokemon/models/models.dart';
import 'package:flutter/material.dart';

class StatBar extends StatelessWidget {
  const StatBar({
    required this.stat,
    super.key,
  });

  final PokemonStat stat;

  @override
  Widget build(BuildContext context) {
    const maxStat = 255;
    final percentage = stat.value / maxStat;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatStatName(stat.name),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                stat.value.toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              _getStatColor(percentage),
            ),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  String _formatStatName(String name) {
    return name
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  Color _getStatColor(double percentage) {
    if (percentage >= 0.7) return Colors.green;
    if (percentage >= 0.4) return Colors.orange;
    return Colors.red;
  }
}
