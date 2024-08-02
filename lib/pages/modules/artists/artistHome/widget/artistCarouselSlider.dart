import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/pages/modules/artists/artistContent/homeArtistAlbumContent/homeArtistAlbumContent.dart';
import 'package:rally/pages/modules/artists/artistContent/homeArtistAudioContent/homeArtistAudioContent.dart';
import 'package:rally/pages/modules/artists/artistContent/homeArtistVideoContent/homeArtistVideoContent.dart';
import 'package:rally/spec/colors.dart';

class ArtistCarouselSlider extends StatefulWidget {
  final String? artistId;

  ArtistCarouselSlider({
    @required this.artistId,
  });

  @override
  State<ArtistCarouselSlider> createState() => _ArtistCarouselSliderState();
}

class _ArtistCarouselSliderState extends State<ArtistCarouselSlider> {
  int _currentContent = 0;
  final CarouselController _carouselController = CarouselController();

  void _onPageChanged(int index, CarouselPageChangedReason reason) =>
      setState(() => _currentContent = index);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          items: [
            HomeArtistAudioContent(
              noOfContentDisplay: 1,
              artistId: widget.artistId ?? userModel!.data!.user!.userid,
            ),
            HomeArtistAlbumContent(
              noOfContentDisplay: 1,
              artistId: widget.artistId ?? userModel!.data!.user!.userid,
            ),
            HomeArtistVideoContent(
              noOfContentDisplay: 1,
              artistId: widget.artistId ?? userModel!.data!.user!.userid,
            ),
          ],
          options: CarouselOptions(
            height: 120,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: false,
            autoPlayInterval: Duration(seconds: 5),
            autoPlayAnimationDuration: Duration(milliseconds: 500),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) => _onPageChanged(index, reason),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int x = 0; x < 3; ++x)
              GestureDetector(
                onTap: () => _carouselController.animateToPage(x),
                child: Container(
                  width: 12,
                  height: 12,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: x == _currentContent ? PRIMARYCOLOR : ASHDEEP1,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
