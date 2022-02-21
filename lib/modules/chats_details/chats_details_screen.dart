import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class ChatsDetailsScreen extends StatelessWidget {
  SocialUserModel? socialUserModel;
  ChatsDetailsScreen({this.socialUserModel});
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        SocialCubit.get(context).getMessages(reciverId: socialUserModel!.uId!);
        return BlocConsumer<SocialCubit, SocialAppStates>(
          listener: (context, state) {
            if (state is SocialSendMessageSuccessState) {
              messageController.clear();
            }
            // if (state is SocialGetMessageSuccessState) {
            //   ScrollDragController.momentumRetainVelocityThresholdFactor;
            // }
          },
          builder: (context, state) {
            return Scaffold(
                appBar: AppBar(
                  titleSpacing: 0,
                  title: Row(
                    children: [
                      CircleAvatar(
                        radius: 20.0,
                        backgroundImage: NetworkImage(
                          '${socialUserModel!.image}',
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        '${socialUserModel!.name}',
                        style: const TextStyle(
                          fontSize: 18,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            var message =
                                SocialCubit.get(context).message[index];
                            if (SocialCubit.get(context).userModel!.uId ==
                                message.senderId)
                              return bulidMyMessage(message);

                            return bulidMessage(message);
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemCount: SocialCubit.get(context).message.length,
                        ),
                      ),
                      Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[400]!,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.emoji_emotions_outlined,
                                  color: Colors.grey,
                                  size: 28,
                                )),
                            const SizedBox(height: 10),
                            Expanded(
                              child: TextFormField(
                                controller: messageController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Message...",
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.blue,
                              height: 48,
                              child: IconButton(
                                  onPressed: () {
                                    SocialCubit.get(context).sendMessage(
                                        reciverId: socialUserModel!.uId!,
                                        dateTime: DateTime.now().toString(),
                                        text: messageController.text);
                                  },
                                  icon: const Icon(
                                    IconBroken.Send,
                                    color: Colors.white,
                                    size: 20,
                                  )),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ));
          },
        );
      },
    );
  }

  Widget bulidMessage(MessagerModel messagerModel) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(10),
              topStart: Radius.circular(10),
              topEnd: Radius.circular(10),
            ),
          ),
          child: Text("${messagerModel.text}"),
        ),
      );
  Widget bulidMyMessage(MessagerModel messagerModel) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: deffaultColor.withOpacity(0.2),
            borderRadius: const BorderRadiusDirectional.only(
              bottomStart: Radius.circular(10),
              topStart: Radius.circular(10),
              topEnd: Radius.circular(10),
            ),
          ),
          child: Text("${messagerModel.text}"),
        ),
      );
}
