import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget deffaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  double height = 45,
  required VoidCallback? function,
  required String? text,
  bool isUpperCase = true,
  Color textColor = Colors.white,
  double fontSize = 20.0,
}) =>
    Container(
      width: width,
      color: background,
      child: MaterialButton(
        height: height,
        onPressed: function,
        child: Text(
          isUpperCase ? text!.toUpperCase() : text!,
          style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: fontSize),
        ),
      ),
    );
Widget deffaultFormField(
        {required TextEditingController? controller,
        TextInputType? type,
        bool isPassword = false,
        required String? labelText,
        required IconData? prefix,
        IconData? suffix,
        //@required var validatee,
        //@required FormFieldValidator? validate,
        final FormFieldValidator<String>? validate,
        VoidCallback? suffixPressed,
        VoidCallback? onTap,
        bool isClickable = true,
        ValueChanged<String>? onFieldSubmitted}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefix),
        suffixIcon: IconButton(onPressed: suffixPressed, icon: Icon(suffix)),
        border: const OutlineInputBorder(),
      ),
      onFieldSubmitted: onFieldSubmitted,
      validator: validate,
      onTap: onTap,
      enabled: isClickable,
    );
Widget deffaultTextButton({
  required VoidCallback? onPressed,
  required String text,
}) =>
    TextButton(
      onPressed: onPressed,
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.blue,
        ),
      ),
    );
void navigateTo(context, Widget) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Widget,
    ));

void navigateAndFinish(context, Widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => Widget,
      ),
      (Route<dynamic> route) => false,
    );

Widget myDivider() => Container(
      height: 1,
      width: double.infinity,
      color: Colors.grey,
    );
void showToast({
  required String text,
  required ToastState state,
}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: choseToasteColor(state),
        textColor: Colors.white,
        fontSize: 16.0);
enum ToastState { SUCCESS, ERORR, WORNING }
Color choseToasteColor(ToastState state) {
  Color color;
  switch (state) {
    case ToastState.SUCCESS:
      color = Colors.green;
      break;
    case ToastState.ERORR:
      color = Colors.red;
      break;
    case ToastState.WORNING:
      color = Colors.amber;
      break;
  }
  return color;
}

productImage({
  required String imageUrl,
  double height = 120,
  double width = 120,
}) =>
    CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: imageUrl,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
