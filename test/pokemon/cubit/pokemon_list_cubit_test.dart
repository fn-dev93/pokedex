import 'package:bloc_test/bloc_test.dart';
import 'package:draftea_pokedex/pokemon/cubit/pokemon_list_cubit.dart';
import 'package:draftea_pokedex/pokemon/cubit/pokemon_list_state.dart';
import 'package:draftea_pokedex/pokemon/data/pokemon_repository.dart';
import 'package:draftea_pokedex/pokemon/models/pokemon.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

void main() {
  group('PokemonListCubit', () {
    late MockPokemonRepository mockRepository;
    late PokemonListCubit pokemonListCubit;

    const testPokemon = [
      Pokemon(
        id: 1,
        name: 'Bulbasaur',
        imageUrl: 'https://example.com/bulbasaur.png',
      ),
      Pokemon(
        id: 2,
        name: 'Ivysaur',
        imageUrl: 'https://example.com/ivysaur.png',
      ),
    ];

    setUp(() {
      mockRepository = MockPokemonRepository();
      pokemonListCubit = PokemonListCubit(repository: mockRepository);
    });

    tearDown(() {
      pokemonListCubit.close();
    });

    group('fetchPokemon', () {
      blocTest<PokemonListCubit, PokemonListState>(
        'emits loading and success states when Pokemon are fetched '
        'successfully',
        build: () {
          when(
            () => mockRepository.getPokemonList(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
            ),
          ).thenAnswer((_) async => testPokemon);
          return pokemonListCubit;
        },
        act: (cubit) => cubit.fetchPokemon(),
        expect: () => [
          const PokemonListState(status: PokemonListStatus.loading),
          const PokemonListState(
            status: PokemonListStatus.success,
            pokemonList: testPokemon,
            hasReachedMax: true,
            currentPage: 1,
          ),
        ],
      );

      blocTest<PokemonListCubit, PokemonListState>(
        'emits loading and failure states when fetching Pokemon fails',
        build: () {
          when(
            () => mockRepository.getPokemonList(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
            ),
          ).thenThrow(Exception('Failed to fetch'));
          return pokemonListCubit;
        },
        act: (cubit) => cubit.fetchPokemon(),
        expect: () => [
          const PokemonListState(status: PokemonListStatus.loading),
          isA<PokemonListState>()
              .having(
                (state) => state.status,
                'status',
                PokemonListStatus.failure,
              )
              .having((state) => state.errorMessage, 'errorMessage', isNotNull),
        ],
      );

      blocTest<PokemonListCubit, PokemonListState>(
        'sets hasReachedMax to true when fetched list is '
        'smaller than page size',
        build: () {
          when(
            () => mockRepository.getPokemonList(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
            ),
          ).thenAnswer(
            (_) async => const [
              Pokemon(
                id: 1,
                name: 'Bulbasaur',
                imageUrl: 'https://example.com/bulbasaur.png',
              ),
            ],
          );
          return pokemonListCubit;
        },
        act: (cubit) => cubit.fetchPokemon(),
        expect: () => [
          const PokemonListState(status: PokemonListStatus.loading),
          isA<PokemonListState>()
              .having(
                (state) => state.status,
                'status',
                PokemonListStatus.success,
              )
              .having((state) => state.hasReachedMax, 'hasReachedMax', true),
        ],
      );

      blocTest<PokemonListCubit, PokemonListState>(
        'does not fetch if already loading',
        build: () {
          when(
            () => mockRepository.getPokemonList(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
            ),
          ).thenAnswer((_) async => testPokemon);
          return pokemonListCubit;
        },
        act: (cubit) async {
          await cubit.fetchPokemon();
        },
        expect: () => [
          const PokemonListState(status: PokemonListStatus.loading),
          const PokemonListState(
            status: PokemonListStatus.success,
            pokemonList: testPokemon,
            hasReachedMax: true,
            currentPage: 1,
          ),
        ],
      );
    });

    group('fetchMorePokemon', () {
      blocTest<PokemonListCubit, PokemonListState>(
        'appends new Pokemon to existing list',
        build: () {
          when(
            () => mockRepository.getPokemonList(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
            ),
          ).thenAnswer((_) async => testPokemon);
          return pokemonListCubit;
        },
        seed: () => const PokemonListState(
          status: PokemonListStatus.success,
          pokemonList: testPokemon,
        ),
        act: (cubit) => cubit.fetchMorePokemon(),
        expect: () => [
          isA<PokemonListState>().having(
            (state) => state.pokemonList.length,
            'length',
            2,
          ),
        ],
      );

      blocTest<PokemonListCubit, PokemonListState>(
        'does not fetch more if max has been reached',
        build: () {
          when(
            () => mockRepository.getPokemonList(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
            ),
          ).thenAnswer((_) async => testPokemon);
          return pokemonListCubit;
        },
        seed: () => const PokemonListState(
          status: PokemonListStatus.success,
          hasReachedMax: true,
          pokemonList: testPokemon,
        ),
        act: (cubit) => cubit.fetchMorePokemon(),
        expect: () => <PokemonListState>[],
        verify: (cubit) {
          verifyNever(
            () => mockRepository.getPokemonList(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
            ),
          );
        },
      );
    });

    group('refreshPokemon', () {
      blocTest<PokemonListCubit, PokemonListState>(
        'resets state and fetches fresh data',
        build: () {
          when(
            () => mockRepository.getPokemonList(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
            ),
          ).thenAnswer((_) async => testPokemon);
          return pokemonListCubit;
        },
        seed: () => const PokemonListState(
          status: PokemonListStatus.success,
          pokemonList: testPokemon,
          currentPage: 2,
        ),
        act: (cubit) => cubit.refreshPokemon(),
        expect: () => [
          const PokemonListState(),
          const PokemonListState(status: PokemonListStatus.loading),
          const PokemonListState(
            status: PokemonListStatus.success,
            pokemonList: testPokemon,
            hasReachedMax: true,
            currentPage: 1,
          ),
        ],
      );
    });

    group('clearCache', () {
      test('calls repository clearCache', () async {
        when(() => mockRepository.clearCache()).thenAnswer((_) async => {});

        await pokemonListCubit.clearCache();

        verify(() => mockRepository.clearCache()).called(1);
      });
    });
  });
}
