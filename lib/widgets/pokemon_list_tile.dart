import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_riverpod/providers/pokemon_data_providers.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemonURL;

  PokemonListTile({required this.pokemonURL});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(pokemonDataProvider(pokemonURL));
    return pokemon.when(data: (data) {
      return _tile(context);
    }, error: (error, st) {
      return Text('Error: $error');
    }, loading: () {
      return _tile(context);
    });
  }

  Widget _tile(BuildContext context) {
    return ListTile(
      title: Text(pokemonURL),
    );
  }
}
