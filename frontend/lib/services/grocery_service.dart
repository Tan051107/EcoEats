import 'package:cloud_functions/cloud_functions.dart';
import 'package:frontend/utils.dart';

class GroceryService {

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

  static Future<void> removeShelfItem(String itemId)async{
    final functions = FirebaseFunctions.instanceFor(region: "us-central1");
    final removeShelfItem = functions.httpsCallable("removeShelfItem");
    try{
      await removeShelfItem.call({
        "item_id":itemId
      });     
    }
    on FirebaseFunctionsException catch (err){
      throw Exception("Failed to remove user's shelf items:${err.message}");
    }
    catch(err){
      throw Exception("Failed to remove user's shelf items:$err");
    }
  }

  static Future<Map<String,dynamic>> addShelfItem(Map<String,dynamic> shelfItem)async{
    List<String> unwantedKeys = ["is_packaged" , "estimated_shelf_life" , "nutrition" , "updated_at" , "created_at"];

    Map<String,dynamic> cleanedPayload = Utils.removeUnwantedKeys(shelfItem, unwantedKeys);
    final functions = FirebaseFunctions.instanceFor(region: "us-central1");
    final addShelfItem = functions.httpsCallable("addShelfItem");
    try{
      final response = await addShelfItem.call(cleanedPayload);
      final Map<String,dynamic> responseResult = Map<String,dynamic>.from(response.data);
      final Map<String,dynamic> addedShelfItem = Map<String,dynamic>.from(responseResult["item_added"]);
      return addedShelfItem;
    }
    on FirebaseFunctionsException catch (err){
      throw Exception("Failed to add user's shelf items:${err.message}");
    }
    catch(err){
      throw Exception("Failed to add user's shelf items:$err");
    }
  }

  static Future <Map<String,dynamic>> sendGroceryImagesForAnalysis(String barcode , List<String> images)async{
    final functions = FirebaseFunctions.instanceFor(region: 'us-central1');
    final analyzeGroceryImage = functions.httpsCallable("analyzeGroceryImage");
    try{
      final response = await analyzeGroceryImage.call({
        // "barcodeValue":barcode,
        "images":images
      });
      if(response.data == null){
        throw Exception("Empty response data received.");
      }
      final Map<String,dynamic> rawData = Map<String,dynamic>.from(response.data as Map);

      if(rawData["success"] !=true){
        throw Exception (rawData["message"] ?? "Grocery image analysis failed");
      }

      if (rawData["data"] == null) {
        throw Exception("No grocery analysis data returned");
      }

      final Map<String, dynamic> analyzedGroceryImageResult = Map<String, dynamic>.from(rawData["data"] as Map);

      return analyzedGroceryImageResult;

    }on FirebaseFunctionsException catch (err){
      throw Exception("Failed to retrieve grocery image result: ${err.message} ");
    }
    catch(err){
      throw Exception("Failed to retrieve grocery image result: $err ");
    }
  }
}