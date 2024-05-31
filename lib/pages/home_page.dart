import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_riverpod/controllers/home_page_controller.dart';
import 'package:infinite_scroll_riverpod/models/page_data.dart';
import 'package:infinite_scroll_riverpod/providers/pokemon_data_providers.dart';
import 'package:infinite_scroll_riverpod/widgets/pokemon_list_tile.dart';

import '../models/pokemon.dart';

final homePageControllerProvider =
    StateNotifierProvider<HomePageController, HomePageData>((ref) {
  return HomePageController(HomePageData.initial());
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _allPokemonsListScrollController = ScrollController();

  late HomePageController _homePageController;
  late HomePageData _homePageData;

  late List<String> _favouritePokemons;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _allPokemonsListScrollController.addListener(() {
      _scrollListener();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _allPokemonsListScrollController.removeListener(() {
      _scrollListener();
    });
    super.dispose();
  }

  void _scrollListener() {
    if (_allPokemonsListScrollController.offset >=
            _allPokemonsListScrollController.position.maxScrollExtent * 1 &&
        !_allPokemonsListScrollController.position.outOfRange) {
      _homePageController.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _homePageController = ref.watch(homePageControllerProvider.notifier);
    _homePageData = ref.watch(homePageControllerProvider);
    _favouritePokemons = ref.watch(favouritePokemonsProvider);
    return Scaffold(body: _buildUi(context));
  }

  Widget _buildUi(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Container(
          width: MediaQuery.sizeOf(context).width,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).height * 0.02),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _favouritePokemonsList(context),
                _allPokemonsList(context)
              ],
            ),
          )),
    ));
  }

  Widget _favouritePokemonsList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        children: [
          const Text(
            'Favourites',
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.50,
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (_favouritePokemons.isNotEmpty)
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.48,
                      child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemBuilder: (context, index){
                        return Container();
                      }),
                    ),
                    if (_favouritePokemons.isEmpty)
                      const Text('No favourite pokemons yet!')
                  ]))
        ],
      ),
    );
  }

  Widget _allPokemonsList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'All pokemons',
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.60,
            child: ListView.builder(
              controller: _allPokemonsListScrollController,
              itemCount: _homePageData.data?.results?.length ?? 0,
              itemBuilder: ((context, index) {
                PokemonListResult pokemon = _homePageData.data!.results![index];
                return PokemonListTile(pokemonURL: pokemon.url!);
              }),
            ),
          )
        ],
      ),
    );
  }
}
