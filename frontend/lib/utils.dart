import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Utils {

  static String timeStampToDate(Timestamp timestamp){
    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

    return formattedDate;
  }

  static String timeStamptoAMPM(Timestamp timestamp){
    DateTime dateTime = timestamp.toDate();
    String time = DateFormat('hh:mm a').format(dateTime);
    return time;
  }

  static Map<String, dynamic> removeUnwantedKeys(
    Map<String, dynamic> source,
    List<String> unwantedKeys,
  ) {
    return Map<String, dynamic>.fromEntries(
      source.entries.where((entry) => !unwantedKeys.contains(entry.key)),
    );
  }
}