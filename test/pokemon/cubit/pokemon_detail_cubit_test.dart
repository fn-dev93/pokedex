import 'package:bloc_test/bloc_test.dart';
import 'package:draftea_pokedex/pokemon/cubit/pokemon_detail_cubit.dart';
import 'package:draftea_pokedex/pokemon/cubit/pokemon_detail_state.dart';
import 'package:draftea_pokedex/pokemon/data/pokemon_repository.dart';
import 'package:draftea_pokedex/pokemon/models/pokemon_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

void main() {
  group('PokemonDetailCubit', () {
    late MockPokemonRepository mockRepository;
    late PokemonDetailCubit pokemonDetailCubit;

    const testPokemonDetail = PokemonDetail(
      id: 1,
      name: 'Bulbasaur',
      height: 7,
      weight: 69,
      types: ['grass', 'poison'],
      abilities: ['overgrow'],
      imageUrl: 'https://example.com/bulbasaur.png',
      stats: [],
    );

    setUp(() {
      mockRepository = MockPokemonRepository();
      pokemonDetailCubit = PokemonDetailCubit(repository: mockRepository);
    });

    tearDown(() {
      pokemonDetailCubit.close();
    });

    group('fetchPokemonDetail', () {
      blocTest<PokemonDetailCubit, PokemonDetailState>(
        'emits loading and success states when Pokemon '
        'detail is fetched successfully',
        build: () {
          when(
            () => mockRepository.getPokemonDetail(any()),
          ).thenAnswer((_) async => testPokemonDetail);
          return pokemonDetailCubit;
        },
        act: (cubit) => cubit.fetchPokemonDetail(1),
        expect: () => [
          const PokemonDetailState(status: PokemonDetailStatus.loading),
          const PokemonDetailState(
            status: PokemonDetailStatus.success,
            pokemonDetail: testPokemonDetail,
          ),
        ],
      );

      blocTest<PokemonDetailCubit, PokemonDetailState>(
        'emits loading and failure states when fetching Pokemon detail fails',
        build: () {
          when(
            () => mockRepository.getPokemonDetail(any()),
          ).thenThrow(Exception('Failed to fetch detail'));
          return pokemonDetailCubit;
        },
        act: (cubit) => cubit.fetchPokemonDetail(1),
        expect: () => [
          const PokemonDetailState(status: PokemonDetailStatus.loading),
          isA<PokemonDetailState>()
              .having(
                (state) => state.status,
                'status',
                PokemonDetailStatus.failure,
              )
              .having((state) => state.errorMessage, 'errorMessage', isNotNull),
        ],
      );

      test('calls repository with correct ID', () async {
        when(
          () => mockRepository.getPokemonDetail(any()),
        ).thenAnswer((_) async => testPokemonDetail);

        await pokemonDetailCubit.fetchPokemonDetail(25);

        verify(() => mockRepository.getPokemonDetail(25)).called(1);
      });

      blocTest<PokemonDetailCubit, PokemonDetailState>(
        'updates state with new detail when fetching different Pokemon',
        build: () {
          when(
            () => mockRepository.getPokemonDetail(any()),
          ).thenAnswer((_) async => testPokemonDetail);
          return pokemonDetailCubit;
        },
        seed: () => const PokemonDetailState(
          status: PokemonDetailStatus.success,
          pokemonDetail: testPokemonDetail,
        ),
        act: (cubit) => cubit.fetchPokemonDetail(2),
        expect: () => [
          isA<PokemonDetailState>().having(
            (state) => state.status,
            'status',
            PokemonDetailStatus.loading,
          ),
          const PokemonDetailState(
            status: PokemonDetailStatus.success,
            pokemonDetail: testPokemonDetail,
          ),
        ],
      );
    });

    group('clearDetail', () {
      blocTest<PokemonDetailCubit, PokemonDetailState>(
        'resets state to initial state',
        build: () => pokemonDetailCubit,
        seed: () => const PokemonDetailState(
          status: PokemonDetailStatus.success,
          pokemonDetail: testPokemonDetail,
        ),
        act: (cubit) => cubit.clearDetail(),
        expect: () => [
          const PokemonDetailState(),
        ],
      );

      blocTest<PokemonDetailCubit, PokemonDetailState>(
        'clears error message when in failure state',
        build: () => pokemonDetailCubit,
        seed: () => const PokemonDetailState(
          status: PokemonDetailStatus.failure,
          errorMessage: 'Error occurred',
        ),
        act: (cubit) => cubit.clearDetail(),
        expect: () => [
          const PokemonDetailState(),
        ],
      );
    });
  });
}
