import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/social_auth/login_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialAppStates> {
  SocialCubit() : super(SocialAppInitialState());
  static SocialCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  void changeBottomNavigationBarItems(int index) {
    if (index == 3) {
      getFavoritesList();
      getWatchLaterList();
    }
    if (index == 4) {
      getUserPotstsLength();
      //emit(SocialGetUserPostsLengthLoadingState());
    }
    if (index == 1) {
      getAllUsers();
    }
    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(SocialChangeBottomNavigationBarItemsState());
    }
  }

  List<BottomNavigationBarItem> items = const [
    BottomNavigationBarItem(
      icon: Icon(IconBroken.Home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(IconBroken.Chat),
      label: 'Chats',
    ),
    BottomNavigationBarItem(
      icon: Icon(IconBroken.Paper_Upload),
      label: 'Post',
    ),
    BottomNavigationBarItem(
      icon: Icon(IconBroken.Location),
      label: 'Account',
    ),
    BottomNavigationBarItem(
      icon: Icon(IconBroken.Setting),
      label: 'Settings',
    ),
  ];

  List<Widget> screens = [
    FeedScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UserScreen(),
    SettingScreen(),
  ];
  List<String> titles = [
    "News Feed",
    "Chats",
    "Create Post",
    "Account",
    "Settings",
  ];

  SocialUserModel? userModel;
  void getUserData() {
    emit(SocialAppLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel =
          SocialUserModel.fromJson(value.data() as Map<String, dynamic>);
      emit(SocialAppSucsesslState());
    }).catchError((erorr) {
      emit(SocialAppErorrState(erorr));
    });
  }

  final ImagePicker picker = ImagePicker();
  XFile? coverImage;
  File? coverImageFile;
  Future<void> getCoverImage() async {
    coverImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (coverImage != null) {
      coverImageFile = File(coverImage!.path);
      emit(SocialCoverImagePickedSuccessState());
    } else {
      print("please selected image");
      emit(SocialCoverImagePickedErorrState());
    }
  }

  XFile? profileImage;
  File? profileImageFile;
  Future<void> getProfileImage() async {
    profileImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (profileImage != null) {
      profileImageFile = File(profileImage!.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      print("please selected image");
      emit(SocialProfileImagePickedErorrState());
    }
  }

  String profileImageUrl = "";
  void uploadProfileImage({
    required String? name,
    required String? phone,
    required String? bio,
  }) async {
    emit(SocialUserImagesUpdateloadingStates());
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImageFile!) //image waslet el storage
        .then((value) {
      value.ref.getDownloadURL().then(
        (value) {
          profileImageUrl = value;
          updateUser(
            name: name,
            phone: phone,
            bio: bio,
            image: value,
          );
          //emit(SocialUploadImageProfileSuccessStates());
        },
      ).catchError(
        (error) {
          emit(SocialUploadImageProfileErorrStates());
        },
      );
    }).catchError(
      (error) {
        print(error.toString());
        emit(SocialUploadImageProfileErorrStates());
      },
    );
  }

  String coverImageUrl = "";
  void uplodCoverImage({
    required String? name,
    required String? phone,
    required String? bio,
  }) async {
    emit(SocialUserImagesUpdateloadingStates());
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImageFile!) //image waslet el storage
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        coverImageUrl = value;
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          cover: value,
        );
        //emit(SocialUploadImageCoverSuccessStates());
      }).catchError((erorr) {
        print(erorr);
        emit(SocialUploadImageCoverErorrStates());
      });
    }).catchError((erorr) {
      print(erorr);
      emit(SocialUploadImageCoverErorrStates());
    });
  }

  void updateUser({
    required String? name,
    required String? phone,
    required String? bio,
    String? cover,
    String? image,
  }) {
    emit(SocialUpdateUserloadingStates());
    SocialUserModel socialUserModel = SocialUserModel(
      name: name,
      phone: phone,
      bio: bio,
      uId: uId,
      email: userModel!.email,
      cover: cover ?? userModel!.cover,
      image: image ?? userModel!.image,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(socialUserModel.toMap())
        .then((value) {
      getUserData();
    }).catchError((erorr) {
      print(erorr);
      emit(SocialUserUpdateErorrStates());
    });
  }

  XFile? postImage;
  File? postImageFile;
  Future<void> getPostImage() async {
    postImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (postImage != null) {
      postImageFile = File(postImage!.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      print("please selected image");
      emit(SocialPostImagePickedErorrState());
    }
  }

  void uploadPostImage({
    required String? dateTime,
    required String? text,
  }) {
    emit(SocialCreatePostLoadingStates());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("posts/${Uri.file(postImage!.path).pathSegments.last}")
        .putFile(postImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(
          dateTime: dateTime,
          text: text,
          postImage: value,
        );
        //emit(SocialUploadPostImageSuccessStates());
      }).catchError((erorr) {
        emit(SocialUploadPostImageErorrStates());
      });
    }).catchError((erorr) {
      emit(SocialUploadPostImageErorrStates());
    });
  }

  void createPost({
    required String? dateTime,
    required String? text,
    String? postImage,
  }) {
    emit(SocialCreatePostLoadingStates());
    PostModel postModel = PostModel(
      image: userModel!.image,
      name: userModel!.name,
      uId: userModel!.uId,
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? '',
    );
    FirebaseFirestore.instance
        .collection("posts")
        .add(postModel.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessStates());
    }).catchError((erorr) {
      emit(SocialCreatePostErorrStates());
    });
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageStates());
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];
  PostModel? post_model;
  void getPosts() {
    emit(SocialGetPostsLoadingState());
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);

          postsId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
        }).catchError((error) {});
      });
      emit(SocialGetPostsSucsessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetPostsErorrState(error.toString()));
    });
  }

  List<int> userPosts = [];
  var postLength;
  var PostUId;
  void getUserPotstsLength() {
    emit(SocialGetMessageLoginState());
    userPosts = [];
    var userPostsCount = FirebaseFirestore.instance.collection('posts');
    userPostsCount.where('uId', isEqualTo: uId).get().then((value) {
      value.docs.forEach((element) {
        // postLength = element;
        userPosts.add(element.data().length);
      });
      postLength = userPosts.length;

      emit(SocialGetUserPostsLengthSuccessState());
    }).catchError((erorr) {
      print(erorr.toString());
      emit(SocialGetUserPostsLengthErorrState());
    });
  }

  List<dynamic> follrwersLength = [];
  var follrwersCount;

  void getUserFolloewrsLength() {
    emit(SocialGetUserFollowersLengthLoadingState());
    follrwersLength = [];
    var userFollowersCount = FirebaseFirestore.instance.collection('users');
    userFollowersCount.doc(uId).collection("chats").get().then((value) {
      follrwersCount = value.docs.length;
      //follrwersCount = follrwersLength;
      print(follrwersCount);

      emit(SocialGetUserFollowersLengthSuccessState());
    }).catchError((erorr) {
      print(erorr.toString());
      emit(SocialGetUserFollowersLengthErorrState());
    });
  }

  void addToFavorites({
    String? name,
    String? uId,
    String? image,
    String? dateTime,
    String? text,
    String? postImage,
    String? postsId,
  }) {
    emit(SocialAddToFavoritesLoadingState());
    PostModel postModel = PostModel(
        dateTime: dateTime,
        uId: uId,
        image: image,
        name: name,
        postImage: postImage ?? '',
        text: text ?? '');
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel!.uId)
        .collection("favoritesList")
        .add(postModel.toMap())
        .then((value) {
      emit(SocialAddToFavoritesSuccessState());
    }).catchError((erorr) {
      print(erorr.toString());
      emit(SocialAddToFavoritesErorrState());
    });
  }

  List<PostModel> favoritesList = [];
  void getFavoritesList() {
    favoritesList = [];
    emit(SocialGetFavoritesLoadingState());
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel!.uId)
        .collection("favoritesList")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        favoritesList.add(PostModel.fromJson(element.data()));
      });
      print(favoritesList.length);
      emit(SocialGetFavoritesSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetFavoritesErorrState());
    });
  }

  void removeFromFavorites(postid) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel!.uId)
        .collection("favoritesList")
        .doc(postid)
        .delete()
        .then((value) {
      emit(SocialRemoveFromFavoritesSuccessState());
    }).catchError((erorr) {
      emit(SocialRemoveFromFavoritesErorrState());

      print(erorr);
    });
  }

  void addToWatchLater({
    String? name,
    String? uId,
    String? image,
    String? dateTime,
    String? text,
    String? postImage,
    String? postsId,
  }) {
    emit(SocialAddToWatchLaterLoadingState());
    PostModel postModel = PostModel(
        dateTime: dateTime,
        uId: uId,
        image: image,
        name: name,
        postImage: postImage ?? '',
        text: text ?? '');
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel!.uId)
        .collection("watchlaterList")
        .add(postModel.toMap())
        .then((value) {
      emit(SocialAddToWatchLaterSuccessState());
    }).catchError((erorr) {
      print(erorr.toString());
      emit(SocialAddToWatchLaterErorrState());
    });
  }

  List<PostModel> watchLaterList = [];
  void getWatchLaterList() {
    watchLaterList = [];
    emit(SocialGetWatchLaterLoadingState());
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel!.uId)
        .collection("watchlaterList")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        watchLaterList.add(PostModel.fromJson(element.data()));
      });
      print(favoritesList.length);
      emit(SocialGetWatchLaterSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetWatchLaterErorrState());
    });
  }

  void likePost(String postId) {
    emit(SocialPostLikesLoadingState());
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("likes")
        .doc(userModel!.uId)
        .set({
      'likes': true,
    }).then((value) {
      emit(SocialPostLikesSucsessState());
    }).catchError((erorr) {
      emit(SocialPostLikesErorrState(erorr));
    });
  }

  XFile? commentImage;
  File? commentImageFile;
  Future<void> getCommentImage() async {
    commentImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (commentImage != null) {
      commentImageFile = File(commentImage!.path);
      emit(SocialCommentImagePickedSuccessState());
    } else {
      print("please selected image");
      emit(SocialCommentImagePickedErorrState());
    }
  }

  void uploadCommentImage({
    required String uidComment,
    required String textComment,
    String? postId,
  }) {
    emit(SocialCreatePostLoadingStates());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("comments/${Uri.file(commentImage!.path).pathSegments.last}")
        .putFile(commentImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createComment(
          uidComment: uidComment,
          textComment: textComment,
          imageComment: value,
          postId: postId!,
        );
      }).catchError((erorr) {
        emit(SocialUploadCommentImageErorrStates());
      });
    }).catchError((erorr) {
      emit(SocialUploadCommentImageErorrStates());
    });
  }

  void createComment({
    required String uidComment,
    required String textComment,
    String? imageComment,
    String? postId,
  }) {
    emit(SocialCreateCommentLoadingStates());
    CommentModel commentModel = CommentModel(
      name: userModel!.name,
      textComment: textComment,
      image: userModel!.image,
      uId: userModel!.uId,
      imageComment: imageComment,
      postId: postId,
    );
    FirebaseFirestore.instance
        .collection("posts")
        .doc(uidComment)
        .collection("comments")
        .doc(userModel!.uId)
        .set(commentModel.toMap())
        .then((value) {
      emit(SocialCreateCommentSuccessStates());
    }).catchError((erorr) {
      emit(SocialCreateCommentErorrStates());
    });
  }

  List<CommentModel> commentsModel = [];
  List<String> postsIdComment = [];

  List<int> comments = [];

  void getComments() {
    emit(SocialGetCommentsLoadingState());
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('comments').get().then((value) {
          comments.add(value.docs.length);
          postsIdComment.add(element.id);
          commentsModel.add(CommentModel.fromJson(element.data()));
        }).catchError((error) {});
      });
      emit(SocialGetCommentsSuccsessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetCommentsErorrState(error.toString()));
    });
  }

  List<SocialUserModel> users = [];
  void getAllUsers() {
    emit(SocialGetAllUsersLoadingState());
    if (users.isEmpty) //3lshan msh kol mra yro7 ygep elUsers keda ygep elUsers
    //lma tkon el lest fadya bs ya3ny awel m aft7 el chats bs ygep kol elUser
    //f lma adeef 7ad gded hegepo brdo 3lshan begep lma bfta7 elChat
    {
      FirebaseFirestore.instance.collection("users").get().then((value) {
        value.docs.forEach((element) {
          if (element['uId'] != userModel!.uId) {
            users.add(SocialUserModel.fromJson(element.data()));
          }
          emit(SocialGetAllUsersSuccessState());
        });
      }).catchError((erorr) {
        print(erorr.toString());
        emit(SocialGetAllUsersErorrState(erorr.toString()));
      });
    }
  }

  void sendMessage({
    required String reciverId,
    required String text,
    required String dateTime,
  }) {
    emit(SocialSendMessageLoadingState());
    MessagerModel messagerModel = MessagerModel(
      senderId: userModel!.uId,
      reciverId: reciverId,
      text: text,
      dateTime: dateTime,
    );
    // my message
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel!.uId)
        .collection("chats")
        .doc(reciverId)
        .collection("messages")
        .add(messagerModel.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((erorr) {
      emit(SocialSendMessageErorrState(erorr));
    });
    // reciver message
    FirebaseFirestore.instance
        .collection("users")
        .doc(reciverId)
        .collection("chats")
        .doc(userModel!.uId)
        .collection("messages")
        .add(messagerModel.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((erorr) {
      emit(SocialSendMessageErorrState(erorr));
    });
  }

  List<MessagerModel> message = [];
  void getMessages({
    required String reciverId,
  }) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel!.uId)
        .collection("chats")
        .doc(reciverId)
        .collection("messages")
        .orderBy("dateTime")
        .snapshots()
        .listen((event) {
      message = [];
      event.docs.forEach((element) {
        message.add(
          MessagerModel.fromJson(element.data()),
        );
      });
      emit(SocialGetMessageSuccessState());
    });
  }

  void signOut(context) {
    FirebaseAuth.instance.signOut().then((value) {
      navigateTo(context, LoginScreen());
      emit(SocialUserSignOutSuccessState());
    }).catchError((erorr) {
      print(erorr.toString());
      emit(SocialUserSignOutErorrState());
    });
  }
}
