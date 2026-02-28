import 'package:cloud_functions/cloud_functions.dart';

class UserService {

  static Future<Map<String, dynamic>>  updateUserDetails(Map<String,dynamic> userData)async{
    final functions = FirebaseFunctions.instanceFor(region: "us-central1");
    final updateUserProfile =functions.httpsCallable("updateUserProfile");
    try{
      final response = await updateUserProfile.call(userData);
      final Map<String,dynamic> responseResult = Map<String,dynamic>.from(response.data as Map);
      final Map<String,dynamic> updatedDetails = Map<String,dynamic>.from(responseResult["user_updated"] ?? {});
      return updatedDetails;
    }
    on FirebaseFunctionsException catch (err){
      throw Exception("Failed to update user details:${err.message}");
    }
    catch(err){
      throw Exception("Failed to update user details:$err");
    }
  }
}