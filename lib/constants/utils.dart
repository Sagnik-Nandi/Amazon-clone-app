import "dart:io";

import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";

void showSnackBar(BuildContext context, String message){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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