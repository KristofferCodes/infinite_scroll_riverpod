import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_riverpod/providers/pokemon_data_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../models/pokemon.dart';

class PokemonCard extends ConsumerWidget {
  final String pokemonUrl;
  late FavouritePokemonsProvider _favouritePokemonsProvider;

  PokemonCard({super.key, required this.pokemonUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _favouritePokemonsProvider = ref.watch(favouritePokemonsProvider.notifier);
    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));
    return pokemon.when(
        data: (data) {
          return _card(context, false, data);
        },
        error: (error, st) => Text(error.toString()),
        loading: () => _card(context, true, null));
  }

  Widget _card(BuildContext context, bool isLoading, Pokemon? pokemon) {
    return Skeletonizer(
      enabled: isLoading,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.03,
            vertical: MediaQuery.sizeOf(context).height * 0.01),
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.03,
            vertical: MediaQuery.sizeOf(context).height * 0.01),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pokemon?.name?.toUpperCase() ?? "Pokemon",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  "#${pokemon?.id?.toString()}",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )
              ],
            ),
            Expanded(
                child: CircleAvatar(
              backgroundImage: pokemon != null
                  ? NetworkImage(pokemon.sprites!.frontDefault!)
                  : null,
              radius: MediaQuery.sizeOf(context).height,
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${pokemon?.moves?.length} Moves",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    _favouritePokemonsProvider
                        .removeFavouritePokemon(pokemonUrl);
                  },
                  child: Icon(
                    Icons.favorite,
                    color: Colors.purpleAccent.withOpacity(0.8),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
