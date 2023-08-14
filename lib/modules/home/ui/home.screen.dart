// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:demo/common/theme/app_theme.dart';
import 'package:demo/controllers/api.post.dart';
import 'package:demo/models/chat_user.dart';
import 'package:demo/models/posts.dart';
import 'package:demo/modules/home/ui/view.image.screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/theme/color.dart';
import '../../../common/widget/toast.dart';
import '../bloc/home_bloc.dart';
import 'package:intl/intl.dart';

import 'up.posts.popup.dart';

//home screen -- where all available contacts are shown
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Posts> listPosts = [];
  ChatUser? chatUser;
  @override
  void initState() {
    super.initState();
    chatUser = ChatUser(
        id: '',
        about: '',
        email: '',
        createdAt: '',
        image: '',
        isOnline: false,
        lastActive: '',
        name: '',
        pushToken: '', background: '', phone: '', birth: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(),
        flexibleSpace: Image(
          image: AssetImage('assets/background/img.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background/background2.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeLoading) {
              onLoading(context);
              return;
            } else if (state is GetPostsState) {
              Navigator.pop(context);
              listPosts = state.listPosts;
              chatUser = state.chatUser;
            } else if (state is UpPostsSucces) {
              Navigator.pop(context);
              listPosts = state.listPosts;
            } else if (state is DelPostsSucces) {
              Navigator.pop(context);
              listPosts = state.listPosts;
            } else if (state is ErorrStatus) {
              Navigator.pop(context);
              showToast(
                  context: context,
                  msg: state.error,
                  color: colorErorr,
                  icon: const Icon(Icons.warning));
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 255, 255, 255),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ]),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context, builder: (_) => UpPostsPopUp());
                    },
                    child: Row(
                      children: [
                        Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(140)),
                            child: (chatUser != null && chatUser!.image != "")
                                ? ClipOval(
                                    child: FadeInImage.assetNetwork(
                                      placeholder:
                                          'assets/images/no-avatar.png',
                                      image: chatUser!.image,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/images/no-avatar.png'),
                                  )),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            height: 40,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 2, color: AppTheme.blue1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "     Bạn đang nghĩ gì?",
                                  style: TextStyle(
                                      color: AppTheme.blue1,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: ListView(
                      children: [
                        for (var element in listPosts)
                          _buildCardPosts(post: element)
                        //  _buildCardPosts(element)
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  _buildCardPosts({required Posts post}) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, top: 10),
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(140),
                    child: Container(
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(140)),
                      height: 58,
                      width: 60,
                      child: Stack(
                        children: <Widget>[
                          Container(
                              height: 78,
                              width: 74,
                              margin: const EdgeInsets.only(
                                  left: 0.0, right: 0, top: 0, bottom: 0),
                              padding: const EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.circular(140)),
                              child: (post.userUp != null &&
                                      post.userUp!.image != "")
                                  ? ClipOval(
                                      child: FadeInImage.assetNetwork(
                                        placeholder:
                                            'assets/images/no-avatar.png',
                                        image: post.userUp!.image,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : CircleAvatar(
                                      backgroundImage: AssetImage(
                                          'assets/images/no-avatar.png'),
                                    )),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 13),
                        child: Text(
                            (post.userUp != null && post.userUp!.name != "")
                                ? post.userUp!.name
                                : "",
                            style: AppTheme.nameUerPosts),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 10),
                        child: Text(
                          DateFormat('HH:mm   dd-MM-yyyy').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(post.createdAt))),
                          style: AppTheme.timePosts,
                        ),
                      ),
                    ],
                  ),
                ]),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
              width: MediaQuery.of(context).size.width,
              child: Text(
                post.title,
                style: AppTheme.titlePost,
              ),
            ),
            if (post.image != "")
              InkWell(
                onTap: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => ViewImageScreen(
                        url: post.image,
                        fileName: post.uid,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 227, 227, 227)
                            .withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // Điều chỉnh vị trí của bóng
                      ),
                    ],
                  ),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/gif/giphy1.webp',
                    image: post.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2, left: 28.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              if (post.listLike.contains(chatUser!.id)) {
                                post.listLike.remove(chatUser!.id);
                              } else {
                                post.listLike.add(chatUser!.id);
                              }
                            });
                            await PostsService().updateLikePosts(post: post);
                          },
                          child: Icon(
                            Icons.favorite,
                            size: 30,
                            color: (post.listLike.contains(chatUser!.id))
                                ? AppTheme.red
                                : AppTheme.white,
                          ),
                        ),
                      ),
                      Text(
                        '${post.listLike.length}',
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 22,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2, right: 28.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: (chatUser!.id == post.userUp!.id)
                            ? InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        backgroundColor: AppTheme.mainColors,
                                            content: SizedBox(
                                              width: 150,
                                              height: 65,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Xác nhận xoá",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 10),
                                                        width: 100,
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                            color: Colors.blue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                        child: InkWell(
                                                          onTap: () async {
                                                            Navigator.pop(
                                                                context);
                                                            context
                                                                .read<
                                                                    HomeBloc>()
                                                                .add(DeletePostsEvent(
                                                                    id: post
                                                                        .id));
                                                          },
                                                          child: const Center(
                                                              child: Text(
                                                            "Xác nhận",
                                                            style: AppTheme
                                                                .textButtonWhite,
                                                          )),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 100,
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Colors.orange,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                        child: InkWell(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Center(
                                                              child: Text(
                                                            "Huỷ",
                                                            style: AppTheme
                                                                .textButtonWhite,
                                                          )),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ));
                                },
                                child: Icon(
                                  Icons.delete,
                                  size: 30,
                                  color: Colors.red,
                                ),
                              )
                            : Text(""),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: Divider(),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
