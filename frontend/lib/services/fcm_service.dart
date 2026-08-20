import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:frontend/config/app_config.dart';
import 'package:cloud_functions/cloud_functions.dart';

class FcmService{

  static Future<void>setFcmToken()async{

  final functions = FirebaseFunctions.instanceFor(region: AppConfig.functionsRegion);

  final updateUserFcmToken = functions.httpsCallable("updateUserFcmToken");

  try {
    String? token = await FirebaseMessaging.instance.getToken();
    if(token != null){
      try{
        await updateUserFcmToken.call({
          "fcm_token":token
        });
      }
      on FirebaseFunctionsException catch(err){
      }
      catch(err){
      }
    }
  } catch (e) {
    // This will usually tell you if it's a "MISSING_INSTANCEID_SERVICE" 
    // or "SERVICE_NOT_AVAILABLE" error.
  }

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken)async{
      await updateUserFcmToken.call({
        "fcm_token":newToken
      });
    });
  }

}
