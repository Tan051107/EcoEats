import 'package:cloud_functions/cloud_functions.dart';

class FavouriteService {
  static Future<List<Map<String,dynamic>>> fetchFavourites()async{
    final functions = FirebaseFunctions.instanceFor(region: "us-central1");
    final getFavourites = functions.httpsCallable("getUsersFavourite");
    try{
      final response = await getFavourites.call({});
      final List<dynamic> responseData = response.data['data'];
      final List<Map<String,dynamic>> favouriteRecipes = responseData.map((recipe)=>Map<String,dynamic>.from(recipe)).toList();

      return favouriteRecipes;
    }on FirebaseFunctionsException catch(err){
      throw Exception("Failed to get user's favourite: $err");
    }
    catch(err){
      throw Exception("Failed to get user's favourite: $err");
    }
  }

  static Future<void> addToFavourite(String recipeId)async{
    final functions = FirebaseFunctions.instanceFor(region: "us-central1");
    final addToFavourite = functions.httpsCallable("addUsersFavourite");
    if(recipeId.isEmpty){
      throw Exception("Recipe id is empty");
    }
    try{
      await addToFavourite.call(
        { 
        "recipe_id":recipeId
        }
      );
    }on FirebaseFunctionsException catch(err){
      throw Exception("Failed to add to user's favourite: $err");
    }
    catch(err){
      throw Exception("Failed to add to user's favourite: $err");
    }
  }
}