import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:rally/components/emptyBoxLinear.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/models/bannersModel.dart';
import 'package:rally/pages/modules/bannerDetails/bannerDetails.dart';
import 'package:rally/providers/bannersProvider.dart';

import 'widget/homeMusicHeadlinesWidget.dart';

class HomeMusicHeadlines extends StatefulWidget {
  const HomeMusicHeadlines({Key? key}) : super(key: key);

  @override
  State<HomeMusicHeadlines> createState() => _HomeMusicHeadlinesState();
}

class _HomeMusicHeadlinesState extends State<HomeMusicHeadlines> {
  final CarouselController _carouselController = CarouselController();

  int _currentContent = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: allBannersModelStream,
      initialData: allBannersModel ?? null,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.ok)
            return _mainContent(snapshot.data);
          else
            return allBannersModel == null
                ? emptyBoxLinear(context, msg: "${snapshot.data.msg}")
                : _mainContent(allBannersModel!);
        } else if (snapshot.hasError) {
          return emptyBoxLinear(context, msg: "No data available");
        }
        return shimmerItem(numOfItem: 1);
      },
    );
  }

  Widget _mainContent(AllBannersModel model) {
    return homeMusicHeadlinesWidget(
      carouselController: _carouselController,
      currentContent: _currentContent,
      onPageChanged: (int index, CarouselPageChangedReason reason) =>
          setState(() => _currentContent = index),
      context: context,
      onHeadline: (int index) => _onHeadline(index, model.data![index]),
      model: model,
    );
  }

  void _onHeadline(int index, AllBannersData data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BannerDetails(allBannersData: data),
      ),
    );
  }
}
