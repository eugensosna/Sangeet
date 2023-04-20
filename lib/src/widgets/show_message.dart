import 'package:fluttertoast/fluttertoast.dart';

showMessage(String msg) {
  return Fluttertoast.showToast(
    msg: msg,
    gravity: ToastGravity.BOTTOM
  );
}