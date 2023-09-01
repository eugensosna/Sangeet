import 'package:flutter/material.dart';

bottomSheet(context, widget) {
    return showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50.0),
                topRight: Radius.circular(50.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: widget,
            ),
          ),
        );
      }
    );
  }