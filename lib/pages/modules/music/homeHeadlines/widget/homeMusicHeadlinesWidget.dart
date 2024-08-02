import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/models/bannersModel.dart';
import 'package:rally/spec/colors.dart';

Widget homeMusicHeadlinesWidget({
  @required BuildContext? context,
  @required CarouselController? carouselController,
  @required int? currentContent,
  @required
      void Function(int index, CarouselPageChangedReason reason)? onPageChanged,
  @required void Function(int index)? onHeadline,
  @required AllBannersModel? model,
}) {
  return model!.data == null || model.data!.length == 0
      ? Container()
      : Container(
          height: 140,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [
              CarouselSlider(
                carouselController: carouselController,
                items: [
                  for (int x = 0; x < model.data!.length; ++x)
                    GestureDetector(
                      onTap: () => onHeadline!(x),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: cachedImage(
                          context: context,
                          image: "${model.data![x].cover}",
                          height: 140,
                          width: double.maxFinite,
                          diskCache: 200,
                        ),
                      ),
                    ),
                ],
                options: CarouselOptions(
                  height: 140,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 7),
                  autoPlayAnimationDuration: Duration(milliseconds: 500),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) =>
                      onPageChanged!(index, reason),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int x = 0; x < model.data!.length; ++x)
                      GestureDetector(
                        onTap: () => carouselController!.animateToPage(x),
                        child: Container(
                          width: 10,
                          height: 10,
                          margin: EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 4.0,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                x == currentContent ? PRIMARYCOLOR : ASHDEEP1,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
}
