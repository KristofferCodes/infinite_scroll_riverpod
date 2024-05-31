import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_riverpod/providers/pokemon_data_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../models/pokemon.dart';
import 'pokemon_stats_card.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemonURL;

  late FavouritePokemonsProvider _favouritePokemonsProvider;
  late List<String> _favouritePokemons;

  PokemonListTile({required this.pokemonURL});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _favouritePokemonsProvider = ref.watch(favouritePokemonsProvider.notifier);
    _favouritePokemons = ref.watch(favouritePokemonsProvider);
    final pokemon = ref.watch(pokemonDataProvider(pokemonURL));
    return pokemon.when(data: (data) {
      return _tile(context, false, data);
    }, error: (error, st) {
      return Text('Error: $error');
    }, loading: () {
      return _tile(context, true, null);
    });
  }

  Widget _tile(BuildContext context, bool isLoading, Pokemon? pokemon) {
    return Skeletonizer(
      enabled: isLoading,
      child: GestureDetector(
        onTap: () {
          if (!isLoading) {
            showDialog(
                context: context,
                builder: (_) {
                  return PokemonStatsCard(pokemonUrl: pokemonURL);
                });
          }
        },
        child: ListTile(
          leading: pokemon != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(pokemon.sprites!.frontDefault!),
                )
              : const CircleAvatar(),
          trailing: IconButton(
              onPressed: () {
                if (_favouritePokemons.contains(pokemonURL)) {
                  _favouritePokemonsProvider.removeFavouritePokemon(pokemonURL);
                } else {
                  _favouritePokemonsProvider.addFavouritePokemon(pokemonURL);
                }
              },
              icon: Icon(_favouritePokemons.contains(pokemonURL)
                  ? Icons.favorite
                  : Icons.favorite_border_rounded)),
          title: Text(pokemon != null
              ? pokemon.name!.toUpperCase()
              : "currently loading name for pokemon"),
          subtitle: Text("Has ${pokemon?.moves?.length.toString() ?? 0} moves"),
        ),
      ),
    );
  }
}
