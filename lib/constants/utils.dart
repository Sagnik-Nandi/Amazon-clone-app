import "dart:io";

import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";

void showSnackBar(BuildContext context, String message){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

void showAlertDialog({
  required BuildContext context, 
  required String title,
  required String content,
  required void Function(BuildContext) onPressedYes,
  required VoidCallback onPressedNo
}) {
  Widget yesButton = TextButton(
    onPressed: ()=> onPressedYes(context), 
    child: Text("Yes")
  );
  Widget noButton = TextButton(
    onPressed: onPressedNo, 
    child: Text("No")
  );

  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      yesButton,
      noButton
    ],
  );

  showDialog(
    context: context, 
    builder: (BuildContext context){
      return alert;
    }
  );
}

Future<List<File>> pickImages() async {
  List <File> images=[];
  try {
    var filePicked = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
  if(filePicked!= null && filePicked.files.isNotEmpty){
    for(int i=0; i<filePicked.files.length; i++){
      images.add(File(filePicked.files[i].path!));
    }
  }
  } catch (e) {
    debugPrint(e.toString());
  }
  return images;
}