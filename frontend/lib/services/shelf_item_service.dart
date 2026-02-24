import 'package:cloud_functions/cloud_functions.dart';

class ShelfItemService {

  static Future<List<Map<String,dynamic>>> getShelfItems(String category)async{
    final functions = FirebaseFunctions.instanceFor(region: "us-central1");
    final getShelfItems = functions.httpsCallable("getShelfItems");
    try{
      final response = await getShelfItems.call({
        "category":category
      });

      final List<dynamic> responseData = response.data["data"];
      final List<Map<String,dynamic>> shelfItems = responseData.map((shelfItem)=>Map<String,dynamic>.from(shelfItem)).toList();
      return shelfItems;
    }
    on FirebaseFunctionsException catch (err){
      throw Exception("Failed to get user's shelf items:$err");
    }
    catch(err){
      throw Exception("Failed to get user's shelf items:$err");
    }

  } 
}