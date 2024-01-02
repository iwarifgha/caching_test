import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'loading_screen _controller.dart';

class LoadingScreen{
  LoadingScreenController? loadingScreenController;

  LoadingScreenController showLoadingDialog({
    required BuildContext buildContext,
    required String text,
}){
    final textStream = StreamController<String>();
    textStream.add(text);

    final state = Overlay.of(buildContext);
   final  renderSize = buildContext.findRenderObject() as RenderBox;
   final size = renderSize.size;

   final overlay = OverlayEntry(
       builder: (context){
         return Material(

         );
       }
   );
  }

}