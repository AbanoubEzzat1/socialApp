import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats_details/chats_details_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/styles/colors.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.separated(
          itemBuilder: (context, index) =>
              chatItemBuilder(SocialCubit.get(context).users[index], context),
          separatorBuilder: (context, index) => const SizedBox(height: 0),
          itemCount: SocialCubit.get(context).users.length,
        );
      },
    );
  }

  Widget chatItemBuilder(SocialUserModel socialUserModel, context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: InkWell(
          onTap: () {
            navigateTo(
                context,
                ChatsDetailsScreen(
                  socialUserModel: socialUserModel,
                ));
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(
                  '${socialUserModel.image}',
                ),
              ),
              const SizedBox(width: 10.0),
              Text(
                '${socialUserModel.name}',
                style: const TextStyle(
                  height: 1.4,
                ),
              ),
              const SizedBox(
                width: 5.0,
              ),
            ],
          ),
        ),
      );
}
