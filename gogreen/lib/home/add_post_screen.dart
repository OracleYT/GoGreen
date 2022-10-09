import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../constant.dart';
import '../onboarding/firestore_methods.dart';
import '../providers/user_provider.dart';
import '../widget/textField.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void postImage(
    String uid,
    String username,
    // String profImage
  ) async {
    setState(() {
      isLoading = true;
    });
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        _descriptionController.text,
        _file,
        uid,
        username,
        // profImage,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Posted!"),
        ));

        clearImage();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(res),
        ));
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err.toString()),
      ));
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 350,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 8, 20, 0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Divider(
                          thickness: 3,
                          indent: 150,
                          endIndent: 150,
                          color: Color(0xFFDBE2E7),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 4),
                          child: Container(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  _file == null
                                      ? Center(
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 70,
                                              ),
                                              Text(
                                                "The World wanna know you...",
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 166, 172, 179),
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 16.0,
                                              ),
                                              GestureDetector(
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    child: Container(
                                                      color: Utils.buttonColor
                                                          .withOpacity(0.6),
                                                      width: 80,
                                                      height: 80,
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      child: BackdropFilter(
                                                          filter:
                                                              ImageFilter.blur(
                                                                  sigmaX: 10,
                                                                  sigmaY: 10),
                                                          child: Container(
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                            child: Container(
                                                              child: Center(
                                                                child: Icon(
                                                                  FontAwesomeIcons
                                                                      .add,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          )),
                                                    )),
                                                onTap: () =>
                                                    _selectImage(context),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            isLoading
                                                ? const LinearProgressIndicator()
                                                : const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 0.0)),
                                            Text(
                                              "The whole World can see you...",
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 166, 172, 179),
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 16.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.6,
                                                  child: CustomTextField(
                                                    minLines: 3,
                                                    maxLines: 6,
                                                    hint:
                                                        "Write about it here...",
                                                    obsecure: false,
                                                    autofocus: false,
                                                    textController:
                                                        _descriptionController,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 60.0,
                                                  width: 60.0,
                                                  child: AspectRatio(
                                                    aspectRatio: 487 / 451,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          image:
                                                              DecorationImage(
                                                            fit: BoxFit.fill,
                                                            alignment:
                                                                FractionalOffset
                                                                    .topCenter,
                                                            image: MemoryImage(
                                                                _file),
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 24,
                                            ),
                                            // AppText(text: "If you don't have a fitbit account, then you'll need to create one first.",color: Colors.black,),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                    onPressed: clearImage,
                                                    icon: Icon(Icons
                                                        .arrow_back_ios_new_rounded)),
                                                SizedBox(
                                                  width: 24,
                                                ),
                                                GestureDetector(
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      child: Container(
                                                          color: Utils
                                                              .buttonColor
                                                              .withOpacity(0.6),
                                                          width: 100,
                                                          height: 60,
                                                          padding:
                                                              EdgeInsets.all(2),
                                                          child: BackdropFilter(
                                                            filter: ImageFilter
                                                                .blur(
                                                                    sigmaX: 10,
                                                                    sigmaY: 10),
                                                            child: Container(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                child:
                                                                    Container(
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Confirm",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                )),
                                                          )),
                                                    ),
                                                    onTap: () {
                                                      postImage(
                                                        userProvider
                                                            .getUser.uid,
                                                        userProvider
                                                            .getUser.username,
                                                      );
                                                      Get.back();
                                                      Get.back();
                                                    }),
                                              ],
                                            )
                                          ],
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

// SizedBox(
//                                     height: 16,
//                                   ),
//                                   Text(
//                                     "Hey there,\nHow many leaves you want to collect?",
//                                     style: TextStyle(
//                                       color: Color.fromARGB(255, 166, 172, 179),
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 16.0,
//                                   ),

//                                   CustomTextField(
//                                     hint: "Amount",
//                                     icon: const Icon(Icons.people),
//                                     obsecure: false,
//                                     autofocus: false,
//                                     textController: amounts,
//                                   ),
//                                   SizedBox(
//                                     height: 16,
//                                   ),
//                                   // AppText(text: "If you don't have a fitbit account, then you'll need to create one first.",color: Colors.black,),
//                                   GestureDetector(
//                                       child: ClipRRect(
//                                         borderRadius: BorderRadius.circular(30),
//                                         child: Container(
//                                             color: Utils.buttonColor
//                                                 .withOpacity(0.6),
//                                             width: 100,
//                                             height: 60,
//                                             padding: EdgeInsets.all(2),
//                                             child: BackdropFilter(
//                                               filter: ImageFilter.blur(
//                                                   sigmaX: 10, sigmaY: 10),
//                                               child: Container(
//                                                   alignment:
//                                                       Alignment.bottomCenter,
//                                                   child: Container(
//                                                     child: Center(
//                                                       child: Text(
//                                                         "Confirm",
//                                                         style: TextStyle(
//                                                             color: Colors.white,
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .bold),
//                                                       ),
//                                                     ),
//                                                   )),
//                                             )),
//                                       ),
//                                       onTap: () {
//                                         if (navigationController.coins.value >
//                                             int.parse(amounts.text.trim())) {
//                                           addmoney(user.uid,
//                                               int.parse(amounts.text.trim()));
//                                           Get.back();
//                                           getData();
//                                           setState(() {
//                                             navigationController.coins.value;
//                                           });
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(SnackBar(
//                                             content: Text(
//                                                 "You have Successfully get those leaves  :)"),
//                                           ));
//                                         } else {
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(SnackBar(
//                                             content:
//                                                 Text("Please try again :("),
//                                           ));
//                                         }
//                                       })
  }
}

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No Image Selected');
}
