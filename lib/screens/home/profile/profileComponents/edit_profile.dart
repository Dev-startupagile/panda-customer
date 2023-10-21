import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panda/screens/home/profile/profileComponents/edit_specific_component.dart';
import 'package:panda/screens/home/profile/profileComponents/list_tile.dart';
import 'package:panda/util/constants.dart';
import 'package:provider/provider.dart';

import '../../../../commonComponents/image_picker_bottomsheet.dart';
import '../../../../commonComponents/profile_avatar.dart';
import '../../../../commonComponents/skeletal/custom_profile_skeletal.dart';
import '../../../../function/image_cropper.dart';
import '../../../../function/shared_prefs.dart';
import '../../../../provider/profile_provider.dart';
import '../../../../provider/uploader_provider.dart';
import '../../../../util/ui_constant.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _image;
  String? email;
  final sharedPrefs = SharedPrefs();

  Future _pickImage(ImageSource source) async {
    try {
      await sharedPrefs.saveIsFromImagePicker(true);
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await cropImage(imageFile: img);
      await sharedPrefs.saveIsFromImagePicker(true);
      setState(() {
        _image = img;
        _uploadProfilePic(context);
        Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      Navigator.of(context).pop();
    }
  }

  Future _uploadProfilePic(BuildContext context) async {
    if (_image != null) {
      await context.read<UploaderProvider>().imageUploader(context, _image!);
    }
  }

  void updateProfilePic() {
    final requestBody = {
      "profilePicture": context.read<UploaderProvider>().uplodedFile,
    };

    context
        .read<ProfileProvider>()
        .editProfileInformation(context, email, requestBody);
  }

  void editPressed(editType, editData) {
    final profileData =
        context.read<ProfileProvider>().customerprofile?.personalInformation;
    List editAddressData = [
      profileData?.city,
      profileData?.state,
      profileData?.zipCode,
      profileData?.street
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditSpecificComponent(
          email: email ?? "",
          editType: editType,
          editData: editData,
          editAddressData: editAddressData,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        email = context
            .read<ProfileProvider>()
            .customerprofile
            ?.personalInformation
            .id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Edit Profile',
            style: KProfilePicAppBarTextStyle,
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: KPColor,
            ),
          ),
        ),
        body: Consumer<ProfileProvider>(builder: (context, value, child) {
          return value.isLoading
              ? const CustomProfileSkeletal()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Stack(children: [
                        InkWell(
                          onTap: () {},
                          child: profileAvatar(
                              value.customerprofile?.personalInformation
                                  .profilePicture,
                              _image,
                              false),
                        ),
                        if (context.watch<UploaderProvider>().isLoading)
                          const Positioned(
                            top: 45,
                            right: 47,
                            child: CircularProgressIndicator(
                              color: kPrimaryColor,
                            ),
                          ),
                        Positioned(
                          bottom: 0,
                          right: 5,
                          child: InkWell(
                            onTap: () {
                              showSelectPhotoOptions(context, _pickImage);
                            },
                            child: const CircleAvatar(
                                backgroundColor: kPrimaryColor,
                                child: Icon(Icons.edit,
                                    size: 23, color: Colors.white)),
                          ),
                        )
                      ]),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      customEditProfile(
                          fullNameConst,
                          value.customerprofile?.personalInformation.fullName ??
                              "",
                          editPressed),
                      customEditProfile(
                          emailConst,
                          value.customerprofile?.personalInformation.id ?? "",
                          editPressed),
                      customEditProfile(
                          phoneNumberConst,
                          value.customerprofile?.personalInformation
                                  .phoneNumber ??
                              "",
                          editPressed),
                      customEditProfile(addressConst, "", editPressed),
                      customEditProfile(passwordConst, "", editPressed),
                      Visibility(
                        visible: _image != null,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MaterialButton(
                              onPressed: () {
                                updateProfilePic();
                              },
                              height: 40,
                              minWidth: double.infinity,
                              color: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child:
                                  const Text("Save", style: KWhiteTextStyle)),
                        ),
                      )
                    ],
                  ),
                );
        }));
  }
}
