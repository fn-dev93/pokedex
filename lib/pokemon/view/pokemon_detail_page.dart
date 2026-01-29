import 'package:cached_network_image/cached_network_image.dart';
import 'package:draftea_pokedex/app/app.dart';
import 'package:draftea_pokedex/pokemon/cubit/pokemon_detail_cubit.dart';
import 'package:draftea_pokedex/pokemon/cubit/pokemon_detail_state.dart';
import 'package:draftea_pokedex/pokemon/data/pokemon_repository.dart';
import 'package:draftea_pokedex/pokemon/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PokemonDetailPage extends StatelessWidget {
  const PokemonDetailPage({
    required this.pokemonId,
    super.key,
  });

  final int pokemonId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PokemonDetailCubit(
        repository: context.read<PokemonRepository>(),
      )..fetchPokemonDetail(pokemonId),
      child: const PokemonDetailView(),
    );
  }
}

class PokemonDetailView extends StatelessWidget {
  const PokemonDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pokemon Detail'),
        ),
        body: BlocBuilder<PokemonDetailCubit, PokemonDetailState>(
          builder: (context, state) {
            switch (state.status) {
              case PokemonDetailStatus.initial:
              case PokemonDetailStatus.loading:
                return const Center(child: PokeballLoading());

              case PokemonDetailStatus.failure:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${state.errorMessage}',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: context.pop,
                        child: const Text('Go Back'),
                      ),
                    ],
                  ),
                );

              case PokemonDetailStatus.success:
                final detail = state.pokemonDetail!;
                return _PokemonDetailContent(detail: detail);
            }
          },
        ),
      ),
    );
  }
}

class _PokemonDetailContent extends StatelessWidget {
  const _PokemonDetailContent({required this.detail});

  final PokemonDetail detail;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isDesktop || isLandscape) {
      return _buildDesktopLayout(context);
    }

    return _buildMobileLayout(context);
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildImageSection(context),
          _buildInfoSection(context),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _buildImageSection(context),
        ),
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            child: _buildInfoSection(context),
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          Text(
            '#${detail.id.toString().padLeft(3, '0')}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Hero(
            tag: 'pokemon_${detail.id}',
            child: CachedNetworkImage(
              imageUrl: detail.imageUrl,
              height: 300,
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
          const SizedBox(height: 16),
          Text(
            detail.name.toUpperCase(),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTypesSection(context),
          const SizedBox(height: 24),
          _buildPhysicalInfo(context),
          const SizedBox(height: 24),
          _buildAbilitiesSection(context),
          const SizedBox(height: 24),
          _buildStatsSection(context),
        ],
      ),
    );
  }

  Widget _buildTypesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Types',
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
                  backgroundColor: _getTypeColor(type),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildPhysicalInfo(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            context,
            'Height',
            '${(detail.height / 10).toStringAsFixed(1)} m',
            Icons.height,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildInfoCard(
            context,
            'Weight',
            '${(detail.weight / 10).toStringAsFixed(1)} kg',
            Icons.monitor_weight,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAbilitiesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Abilities',
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

  Widget _buildStatsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Base Stats',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...detail.stats.map((stat) => _buildStatBar(context, stat)),
      ],
    );
  }

  Widget _buildStatBar(BuildContext context, PokemonStat stat) {
    final maxStat = 255;
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

  Color _getTypeColor(String type) {
    const typeColors = {
      'normal': Color(0xFFA8A878),
      'fire': Color(0xFFF08030),
      'water': Color(0xFF6890F0),
      'electric': Color(0xFFF8D030),
      'grass': Color(0xFF78C850),
      'ice': Color(0xFF98D8D8),
      'fighting': Color(0xFFC03028),
      'poison': Color(0xFFA040A0),
      'ground': Color(0xFFE0C068),
      'flying': Color(0xFFA890F0),
      'psychic': Color(0xFFF85888),
      'bug': Color(0xFFA8B820),
      'rock': Color(0xFFB8A038),
      'ghost': Color(0xFF705898),
      'dragon': Color(0xFF7038F8),
      'dark': Color(0xFF705848),
      'steel': Color(0xFFB8B8D0),
      'fairy': Color(0xFFEE99AC),
    };

    return typeColors[type.toLowerCase()] ?? Colors.grey;
  }
}
