import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_riverpod/providers/pokemon_data_providers.dart';

import '../models/pokemon.dart';

class PokemonCard extends ConsumerWidget {
  final String pokemonUrl;

  const PokemonCard({super.key, required this.pokemonUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));
    return pokemon.when(
        data: (data) {
          return _card(context, false, data);
        },
        error: (error, st) => Text(error.toString()),
        loading: () => _card(context, true, null));
  }

  Widget _card(BuildContext context, bool isLoading, Pokemon? pokemon) {
    return Container();
  }
}
