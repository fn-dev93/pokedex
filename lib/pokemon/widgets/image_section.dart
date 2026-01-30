import 'package:cached_network_image/cached_network_image.dart';
import 'package:draftea_pokedex/app/app.dart';
import 'package:draftea_pokedex/pokemon/models/models.dart';
import 'package:flutter/material.dart';

class ImageSection extends StatelessWidget {
  const ImageSection({
    required this.detail,
    super.key,
  });

  final PokemonDetail detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '#${detail.id.toString().padLeft(3, '0')}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 200,
              maxWidth: 200,
            ),
            child: Hero(
              tag: 'pokemon_${detail.id}',
              child: CachedNetworkImage(
                imageUrl: detail.imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: PokeballLoading(),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  size: 100,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            detail.name.toUpperCase(),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
