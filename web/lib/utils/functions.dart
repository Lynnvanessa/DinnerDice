import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message, {Toast? length}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: length ?? Toast.LENGTH_SHORT,
    timeInSecForIosWeb: 3,
  );
}
