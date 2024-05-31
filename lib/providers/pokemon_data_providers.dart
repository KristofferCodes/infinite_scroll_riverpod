import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_riverpod/services/http_service.dart';

import '../models/pokemon.dart';

final pokemonDataProvider = FutureProvider.family<Pokemon?, String>((ref, url) async {
  HTTPService _httpService = GetIt.instance.get<HTTPService>();
  Response? res = await _httpService.get(url);
  if (res != null && res.data != null){
    return Pokemon.fromJson(res.data!);
  }
  return null;
});

final favouritePokemonsProvider = StateNotifierProvider<FavouritePokemonsProvider, List<String>>((ref) {
  return FavouritePokemonsProvider([]);
});


class FavouritePokemonsProvider extends StateNotifier<List<String>>{
  FavouritePokemonsProvider(super._state){
  _setup();
  }

  Future<void> _setup() async {

  }

  void addFavouritePokemon(String url){
    state = [...state, url];
  }

  void removeFavouritePokemon(String url){
    state = state.where((e) => e != url).toList();
  }
}