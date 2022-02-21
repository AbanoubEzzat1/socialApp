import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/modules/comment_screen/comment_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/styles/colors.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class FeedScreen extends StatelessWidget {
  FeedScreen({Key? key}) : super(key: key);
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialAppStates>(
      listener: (context, state) {
        if (state is SocialAppSucsesslState) {
          SocialCubit.get(context).getPosts();
        }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return BuildCondition(
          condition: SocialCubit.get(context).posts.length > 0 &&
              SocialCubit.get(context).userModel != null,
          builder: (context) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // Card(
                //   clipBehavior: Clip.antiAliasWithSaveLayer,
                //   elevation: 5.0,
                //   margin: const EdgeInsets.all(8.0),
                //   child: Stack(
                //     alignment: AlignmentDirectional.bottomEnd,
                //     children: [
                //       const Image(
                //         image: NetworkImage(
                //           'https://image.freepik.com/free-photo/horizontal-shot-smiling-curly-haired-woman-indicates-free-space-demonstrates-place-your-advertisement-attracts-attention-sale-wears-green-turtleneck-isolated-vibrant-pink-wall_273609-42770.jpg',
                //         ),
                //         fit: BoxFit.cover,
                //         height: 200.0,
                //         width: double.infinity,
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Text(
                //           'communicate with friends',
                //           style:
                //               Theme.of(context).textTheme.subtitle1!.copyWith(
                //                     color: Colors.white,
                //                   ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>
                      buildPostItem(cubit.posts[index], context, index),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8.0),
                  itemCount: cubit.posts.length,
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
          fallback: (context) =>
              const Center(child: (CircularProgressIndicator())),
        );
      },
    );
  }
}

Widget buildPostItem(PostModel postModel, context, index) => Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(
                    '${postModel.image}',
                  ),
                ),
                const SizedBox(width: 15.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${postModel.name}',
                            style: const TextStyle(
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          const Icon(
                            Icons.check_circle,
                            color: defaultColor,
                            size: 16.0,
                          ),
                        ],
                      ),
                      Text(
                        '${postModel.dateTime}',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              height: 1.4,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15.0),
                IconButton(
                  icon: const Icon(
                    Icons.more_horiz,
                    size: 16.0,
                  ),
                  onPressed: () {
                    ShowModel(context, postModel);
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15.0,
              ),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
            Text(
              '${postModel.text}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            if (postModel.postImage != '')
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 15.0),
                child: Container(
                  height: 140.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      4.0,
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                        '${postModel.postImage}',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              IconBroken.Heart,
                              size: 16.0,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              '${SocialCubit.get(context).likes[index]}',
                              //'555',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        // SocialCubit.get(context).getFavoritesList();
                      },
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              IconBroken.Chat,
                              size: 16.0,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              '0 comment',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 10.0,
              ),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18.0,
                          backgroundImage: NetworkImage(
                            '${SocialCubit.get(context).userModel!.image}',
                          ),
                        ),
                        const SizedBox(width: 15.0),
                        Text(
                          'write a comment ...',
                          style:
                              Theme.of(context).textTheme.caption!.copyWith(),
                        ),
                      ],
                    ),
                    onTap: () {
                      navigateTo(
                          context,
                          CommentScreen(
                            uIdIndex: SocialCubit.get(context).postsId[index],
                          ));
                    },
                  ),
                ),
                InkWell(
                  child: Row(
                    children: [
                      const Icon(
                        IconBroken.Heart,
                        size: 16.0,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 5.0),
                      Text(
                        'Like',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                  onTap: () {
                    SocialCubit.get(context)
                        .likePost(SocialCubit.get(context).postsId[index]);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );

void ShowModel(context, PostModel) {
  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          padding: const EdgeInsetsDirectional.only(top: 10),
          decoration: const BoxDecoration(
            //color: Colors.grey[300],
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(20),
              topEnd: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    SocialCubit.get(context).addToFavorites(
                      dateTime: PostModel.dateTime,
                      image: PostModel.image,
                      name: PostModel.name,
                      postImage: PostModel.postImage,
                      postsId: PostModel.uId,
                      uId: PostModel.uId,
                    );
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      const Icon(
                        IconBroken.Heart,
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Add to favorites",
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Add this to your favorites item",
                              style: Theme.of(context).textTheme.caption,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  height: 1,
                  width: double.infinity,
                  color: Colors.grey,
                ),
                InkWell(
                  onTap: () {
                    SocialCubit.get(context).addToWatchLater(
                      dateTime: PostModel.dateTime,
                      image: PostModel.image,
                      name: PostModel.name,
                      postImage: PostModel.postImage,
                      postsId: PostModel.uId,
                      uId: PostModel.uId,
                    );
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      const Icon(
                        IconBroken.Time_Circle,
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Add to watch later",
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Add this to your watch later item",
                              style: Theme.of(context).textTheme.caption,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  height: 1,
                  width: double.infinity,
                  color: Colors.grey,
                ),
                InkWell(
                  child: Row(
                    children: [
                      const Icon(
                        IconBroken.Delete,
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Remove",
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Remove this from your timeline",
                              style: Theme.of(context).textTheme.caption,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
