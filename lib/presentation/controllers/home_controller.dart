import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngdemo22/core/services/log_service.dart';
import 'package:ngdemo22/core/services/utils_service.dart';

import '../../data/models/message_model.dart';
import '../../data/repositories/gemini_talk_repository_impl.dart';
import '../../domain/usecases/gemini_text_and_image_usecase.dart';
import '../../domain/usecases/gemini_text_only_usecase.dart';

class HomeController extends GetxController {
  GeminiTextOnlyUseCase textOnlyUseCase = GeminiTextOnlyUseCase(GeminiTalkRepositoryImpl());
  GeminiTextAndImageUseCase textAndImageUseCase = GeminiTextAndImageUseCase(GeminiTalkRepositoryImpl());

  TextEditingController textController = TextEditingController();
  List<MessageModel> messages = [];
  String pickedImage64 = "";

  void askToGemini() {
    String message = textController.text.toString().trim();
    if (message.isEmpty) {
      return;
    }

    if (pickedImage64.isNotEmpty) {
      MessageModel mine = MessageModel(isMine: true, message: message, base64: pickedImage64);
      updateMessages(mine);
      apiTextAndImage(message, pickedImage64);
    } else {
      MessageModel mine = MessageModel(isMine: true, message: message);
      updateMessages(mine);

      apiTextOnly(message);
    }

    textController.clear();
    removePickedImage();
  }

  updateMessages(MessageModel messageModel) {
    messages.add(messageModel);
    update();
  }

  apiTextOnly(String message) async {
    var either = await textOnlyUseCase.call(message);
    either.fold((l) {
      MessageModel gemini = MessageModel(isMine: false, message: l);
      updateMessages(gemini);
    }, (r) {
      MessageModel gemini = MessageModel(isMine: false, message: r);
      updateMessages(gemini);
    });
  }

  apiTextAndImage(String message, String pickedImage64)async{
    var either = await textAndImageUseCase.call(message, pickedImage64);
    either.fold((l) {
      LogService.e(l);
      MessageModel gemini = MessageModel(isMine: false, message: l);
      updateMessages(gemini);
    }, (r) {
      LogService.i(r);
      MessageModel gemini = MessageModel(isMine: false, message: r);
      updateMessages(gemini);
    });
  }

  void pickImageFromGallery() async {
    var result = await Utils.pickAndConvertImage();
    LogService.i(result);
    pickedImage64 = result;
    update();
  }

  void removePickedImage() {
    pickedImage64 = "";
    update();
  }
}
