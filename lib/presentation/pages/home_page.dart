import 'package:flutter/material.dart';
import 'package:ngdemo22/core/services/log_service.dart';
import 'package:ngdemo22/core/services/utils_service.dart';
import 'package:ngdemo22/data/repositories/gemini_talk_repository_impl.dart';
import 'package:ngdemo22/domain/usecases/gemini_text_and_image_usecase.dart';

import '../../domain/usecases/gemini_text_only_usecase.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  testTextOnly() async {
    GeminiTextOnlyUseCase useCase = GeminiTextOnlyUseCase(GeminiTalkRepositoryImpl());
    var result = await useCase.call("How to learn Flutter faster?");
    result.fold((l) {
      LogService.i(l);
    }, (r) {
      LogService.i(r);
    });
  }

  testTextAndImage(String base64Image) async{
    GeminiTextAndImageUseCase useCase = GeminiTextAndImageUseCase(GeminiTalkRepositoryImpl());

    var result = await useCase.call("What is it?", base64Image);
    result.fold((l) {
      LogService.i(l);
    }, (r) {
      LogService.i(r);
    });
  }

  pickGalleryImage() async{
    var result = await Utils.pickAndConvertImage();
    LogService.w(result);

    testTextAndImage(result);
  }

  @override
  void initState() {
    super.initState();
    //testTextOnly();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Gemini"),
      ),

      body: Center(
        child: MaterialButton(
          color: Colors.blue,
          child: Text("Pick image"),
          onPressed: (){
              pickGalleryImage();
          },
        ),
      ),
    );
  }
}
