import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sangeet/src/widgets/bottom_sheet.dart';
import 'package:sangeet/src/widgets/custom_button.dart';
import 'package:sangeet/src/widgets/custom_dialog.dart';
import 'package:sangeet/src/widgets/custom_textfield.dart';

addRenamePlaylist(context, [id]) {
  final TextEditingController textFldCon = TextEditingController();
  return bottomSheet(
    context,
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Text(
            id == null ? 'Add Playlist' : 'Rename Playlist',
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        const Text(
          'Enter Playlist name',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10.0),
        CustomTextField(
          controller: textFldCon,
        ),
        const SizedBox(height: 20.0),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: id == null ? 'Create Playlist' : 'Rename Playlist',
                fontSize: 16.0,
                color: Theme.of(context).primaryColor,
                onPressed: () async {
                  if(id == null) {
                    Get.back();
                    // con.addPlaylist(textFldCon.text);
                    textFldCon.clear();
                  } else {
                    // String name = textFldCon.text;
                    customAlertDialog(
                      'Yes',
                      () async {
                        // bool success = await con.renamePlaylist(id, name);
                        // if(success) {
                        //   textFldCon.clear();
                        // }
                      },
                      'Cancel',
                      null,
                      'You are about to rename a playlist. \n Are you sure?'
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: CustomButton(
                text: 'Cancel',
                fontSize: 16.0,
                color: Colors.grey[700],
                onPressed: () {
                  textFldCon.clear();
                  Get.back();
                },
              ),
            )
          ],
        )
      ],
    )
  );
}