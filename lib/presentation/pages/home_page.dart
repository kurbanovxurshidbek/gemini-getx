import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngdemo22/core/services/log_service.dart';
import 'package:ngdemo22/core/services/utils_service.dart';
import 'package:ngdemo22/data/repositories/gemini_talk_repository_impl.dart';
import 'package:ngdemo22/domain/usecases/gemini_text_and_image_usecase.dart';
import 'package:ngdemo22/presentation/controllers/home_controller.dart';
import 'package:ngdemo22/presentation/widgets/item_of_gemini_message.dart';

import '../../domain/usecases/gemini_text_only_usecase.dart';
import '../widgets/item_of_user_message.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GetBuilder<HomeController>(
        builder: (_) {
          return Container(
            padding: EdgeInsets.only(bottom: 20, top: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 45,
                  child: Image(
                    image: AssetImage('assets/images/gemini_logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: homeController.messages.isNotEmpty
                      ? ListView.builder(
                          itemCount: homeController.messages.length,
                          itemBuilder: (context, index) {
                            var message = homeController.messages[index];

                            if (message.isMine!) {
                              return itemOfUserMessage(message);
                            } else {
                              return itemOfGeminiMessage(message);
                            }
                          },
                        )
                      : Center(
                          child: SizedBox(
                            height: 70,
                            width: 70,
                            child: Image.asset('assets/images/gemini_icon.png'),
                          ),
                        ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(right: 20, left: 20),
                  padding: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey, width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      homeController.pickedImage64.isNotEmpty
                          ? Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.white)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.memory(
                                      base64Decode(
                                          homeController.pickedImage64),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.white)),
                                  child: Center(
                                    child: IconButton(
                                      onPressed: () {
                                        homeController.removePickedImage();
                                      },
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: homeController.textController,
                              maxLines: null,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Message",
                                  hintStyle: TextStyle(color: Colors.grey)),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              homeController.pickImageFromGallery();
                            },
                            icon: Icon(
                              Icons.attach_file,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              homeController.askToGemini();
                            },
                            icon: Icon(
                              Icons.send,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
