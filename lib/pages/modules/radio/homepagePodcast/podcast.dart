import 'package:flutter/material.dart';
import 'package:rally/bloc/allPodcastBloc.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/circular.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

import 'widget/homePodcastWidget.dart';

class Podcast extends StatefulWidget {
  const Podcast({Key? key}) : super(key: key);

  @override
  State<Podcast> createState() => _PodcastState();
}

class _PodcastState extends State<Podcast> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: h2WhiteBold,
        centerTitle: false,
        title: Text("Listen Now"),
        actions: [
          GestureDetector(
            onTap: () => navigation(context: context, pageName: "account"),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: circular(
                child: cachedImage(
                  context: context,
                  image: "${userModel!.data!.user!.picture!}",
                  height: 40,
                  width: 40,
                  placeholder: DEFAULTPROFILEPICOFFLINE,
                ),
                size: 40,
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(),
        child: homePodcastWidget(
          onSearch: () => navigation(context: context, pageName: "searchradio"),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    await allPodcastBloc.fetch();
    return await Future.delayed(Duration(seconds: 3));
  }
}
