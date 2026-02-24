import 'package:cloud_functions/cloud_functions.dart';

class SummaryService {
    static Future<Map<String,dynamic>>getDailySummary()async{
      final functions  = FirebaseFunctions.instanceFor(region: "us-central1");
      final getDailySummary = functions.httpsCallable("getDailySummary");
      try{
        final response = await getDailySummary.call({});
        print("Daily Summary Response: ${response.data}");

        if(response.data == null){
          throw Exception ("Empty response received");
        } 

        final Map<String,dynamic> rawData = Map<String,dynamic>.from(response.data as Map);

        if(rawData["success"] != true){
            throw Exception (rawData["message"] ?? "Daily summary failed");
          }

        if (rawData["data"] == null) {
            throw Exception("No daily summary data returned");
          }

        final Map<String,dynamic> summaryData = Map<String,dynamic>.from(rawData["data"] as Map);

        return summaryData;
      }on FirebaseFunctionsException catch(err){
        throw Exception('Failed to get daily summary:$err');
      }
      catch(err){
        throw Exception('Failed to get daily summary:$err');
      }
    }
}