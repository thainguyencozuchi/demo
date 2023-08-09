import 'package:demo/models/posts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/theme/color.dart';
import '../../../common/widget/toast.dart';
import '../bloc/home_bloc.dart';

//home screen -- where all available contacts are shown
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Posts> listPosts = [];
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
            print(listPosts.map((e) => e.toJson()));
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
          return Container(
            child: ListView(
              children: [
                for (var element in listPosts)
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 100,
                    height: 50,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 110, 110, 110)),
                    child: Text("${element}"),
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
