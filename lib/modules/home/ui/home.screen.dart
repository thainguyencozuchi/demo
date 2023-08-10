// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:demo/models/chat_user.dart';
import 'package:demo/models/posts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(),
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
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
                    color: const Color.fromARGB(255, 255, 255, 255)
                        .withOpacity(0.5),
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
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(140)),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              (chatUser != null && chatUser!.image != "")
                                  ? chatUser!.image
                                  : "https://firebasestorage.googleapis.com/v0/b/fir-7dc77.appspot.com/o/images%2Fnoavater.jpeg?alt=media",
                            ),
                          )),
                      Expanded(
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "     Bạn đang nghĩ gì?",
                                style: GoogleFonts.lato(
                                    color: const Color.fromARGB(
                                        255, 119, 119, 119),
                                    fontSize: 13,
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
                      for (var element in listPosts) _buildCardPosts(element)
                      //  _buildCardPosts(element)
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  _buildCardPosts(Posts post) {
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
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(140)),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              (post.userUp != null && post.userUp!.image != "")
                                  ? post.userUp!.image
                                  : "https://firebasestorage.googleapis.com/v0/b/fir-7dc77.appspot.com/o/images%2Fnoavater.jpeg?alt=media",
                            ),
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
                      style: GoogleFonts.lato(
                          color: Colors.grey[700],
                          fontSize: 18,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold),
                    ),
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
                      style: GoogleFonts.lato(
                          color: Colors.grey[700],
                          fontSize: 13,
                          letterSpacing: 1,
                          fontWeight: FontWeight.normal),
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
            style: GoogleFonts.lato(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 14,
                letterSpacing: 1,
                fontWeight: FontWeight.normal),
          ),
        ),
        if (post.image != "")
          Container(
            padding: EdgeInsets.all(10),
            height: 300,
            child: Image.network(post.image),
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
                    child: Icon(
                      Icons.favorite,
                      size: 35,
                    ),
                  ),
                  Text(
                    '${post.listLike.length}',
                    style: GoogleFonts.averageSans(
                        color: Colors.grey[700],
                        fontSize: 22,
                        letterSpacing: 1,
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
                    child: (chatUser!.uid.toString() == post.uid)
                        ? Icon(
                            Icons.delete,
                            size: 35,
                          )
                        : Text(""),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10),
          child: Divider(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
