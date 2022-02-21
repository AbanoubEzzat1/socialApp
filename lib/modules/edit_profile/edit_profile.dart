// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/styles/colors.dart';
import 'package:social_app/shared/components/styles/colors.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = SocialCubit.get(context).userModel;
        var profileImageFile = SocialCubit.get(context).profileImageFile;
        var coverImageFile = SocialCubit.get(context).coverImageFile;
        nameController.text = model!.name!;
        phoneController.text = model.phone!;
        bioController.text = model.bio == null ? 'bio' : model.bio!;
        return Scaffold(
            appBar: AppBar(
              title: const Text("Edit Profile"),
              titleSpacing: 0,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    IconBroken.Arrow___Left_2,
                  )),
              actions: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    end: 10,
                  ),
                  child: deffaultTextButton(
                      onPressed: () async {
                        SocialCubit.get(context).updateUser(
                          name: nameController.text,
                          bio: bioController.text,
                          phone: phoneController.text,
                        );
                      },
                      text: "update"),
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (state is SocialUpdateUserloadingStates)
                      LinearProgressIndicator(),
                    SizedBox(height: 10),
                    Container(
                      height: 200.0,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Align(
                                child: Container(
                                  height: 160.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                        4.0,
                                      ),
                                      topRight: Radius.circular(
                                        4.0,
                                      ),
                                    ),
                                    image: DecorationImage(
                                      image: coverImageFile == null
                                          ? NetworkImage(
                                              "${model.cover}",
                                            )
                                          : FileImage(coverImageFile)
                                              as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                alignment: AlignmentDirectional.topCenter,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  backgroundColor: defaultColor,
                                  radius: 20,
                                  child: IconButton(
                                      onPressed: () {
                                        SocialCubit.get(context)
                                            .getCoverImage();
                                      },
                                      icon: Icon(
                                        IconBroken.Camera,
                                      )),
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 65.0,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  radius: 60.0,
                                  backgroundImage: profileImageFile == null
                                      ? NetworkImage("${model.image}")
                                      : FileImage(profileImageFile)
                                          as ImageProvider,
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: defaultColor,
                                radius: 20,
                                child: IconButton(
                                    onPressed: () {
                                      SocialCubit.get(context)
                                          .getProfileImage();
                                    },
                                    icon: Icon(
                                      IconBroken.Camera,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      "${model.name}",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      "${model.bio}",
                      style: Theme.of(context).textTheme.caption,
                    ),
                    if (SocialCubit.get(context).profileImage != null ||
                        SocialCubit.get(context).coverImage != null)
                      SizedBox(height: 15),
                    if (SocialCubit.get(context).profileImage != null ||
                        SocialCubit.get(context).coverImage != null)
                      Row(
                        children: [
                          if (SocialCubit.get(context).coverImage != null)
                            Expanded(
                                child: Column(
                              children: [
                                deffaultButton(
                                    function: () {
                                      SocialCubit.get(context).uplodCoverImage(
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        bio: bioController.text,
                                      );
                                    },
                                    text: "update cover"),
                                SizedBox(height: 5),
                                if (state
                                    is SocialUserImagesUpdateloadingStates)
                                  LinearProgressIndicator(),
                              ],
                            )),
                          SizedBox(width: 5),
                          if (SocialCubit.get(context).profileImage != null)
                            Expanded(
                                child: Column(
                              children: [
                                deffaultButton(
                                    function: () {
                                      SocialCubit.get(context)
                                          .uploadProfileImage(
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        bio: bioController.text,
                                      );
                                    },
                                    text: "update image"),
                                SizedBox(height: 5),
                                if (state
                                    is SocialUserImagesUpdateloadingStates)
                                  LinearProgressIndicator(),
                              ],
                            )),
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          deffaultFormField(
                            controller: nameController,
                            labelText: "Name",
                            prefix: IconBroken.User,
                          ),
                          SizedBox(height: 15),
                          deffaultFormField(
                            controller: bioController,
                            labelText: "Bio",
                            prefix: IconBroken.Info_Circle,
                          ),
                          SizedBox(height: 15),
                          deffaultFormField(
                            controller: phoneController,
                            labelText: "Phone",
                            prefix: IconBroken.Call,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
