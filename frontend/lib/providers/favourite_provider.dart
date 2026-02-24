import 'package:flutter/material.dart';
import '../services/favourite_service.dart';


class FavouriteProvider extends ChangeNotifier{
  List<Map<String,dynamic>> _favourites = [];
  bool _isLoading = false;

  List<Map<String,dynamic>> get favourites => _favourites;
  bool get isLoading => _isLoading;

  Future<void> fetchFavourites()async{
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();
    try{
      _favourites =  await FavouriteService.fetchFavourites();
    }
    catch(err){
      throw Exception(err);
    }
    _isLoading = false;
    notifyListeners();
  } 

  Future<void>addToFavourite(Map<String,dynamic>newFavourite)async{
    bool isAlreadyFavourite = _favourites.any((fav)=>fav["recipeId"] == newFavourite["recipeId"]);
    if(isAlreadyFavourite){
      _favourites.removeWhere((fav)=>fav["recipeId"] == newFavourite["recipeId"]);
    }
    else{
      _favourites.add(newFavourite);
    }
    notifyListeners();
    try{
      await FavouriteService.addToFavourite(newFavourite["recipeId"]);
    }catch(err){
      throw Exception(err);
    }
    notifyListeners();
  }

  bool isFavourite(String recipeId){
    return _favourites.any((fav)=>fav["recipeId"] == recipeId);
  }
}