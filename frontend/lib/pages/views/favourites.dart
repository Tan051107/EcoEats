
import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/providers/favourite_provider.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/recipe_overview_card.dart';
import 'package:provider/provider.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {
    final FavouriteProvider favouriteProvider = context.watch<FavouriteProvider>();
    final List<Map<String,dynamic>> userFavourites = favouriteProvider.favourites;
    final int totalFavourites = userFavourites.length;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          SizedBox(height: 50.0),
          Header(
            title: "Favourites",
            isShowBackButton: false,
            subtitle: "$totalFavourites saved recipes",
          ),
          SizedBox(height: 20.0),

          // Expanded fills the remaining vertical space
          Expanded(
            child: favouriteProvider.isLoading
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Loading Favourites"),
                        SizedBox(height: 5.0),
                        CircularProgressIndicator(),
                      ],
                    ),
                  )
                : totalFavourites < 1
                    ? Center(
                        child: Text(
                          "No favourites yet",
                          style: subtitleText,
                        ),
                      )
                    : ListView.builder(
                        itemCount: totalFavourites,
                        itemBuilder: (context, index) {
                          final favouriteMeal = userFavourites[index];
                          return RecipeOverviewCard(mealData: favouriteMeal);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}