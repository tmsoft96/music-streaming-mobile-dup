import 'package:flutter/material.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/repository/repo.dart';
import 'package:rally/models/bannersModel.dart';
import 'package:rally/pages/modules/bannerDetails/bannerDetails.dart';
import 'package:rally/providers/bannersProvider.dart';

import 'widget/allBannersWidget.dart';

class AllBanners extends StatefulWidget {
  const AllBanners({Key? key}) : super(key: key);

  @override
  State<AllBanners> createState() => _AllBannersState();
}

class _AllBannersState extends State<AllBanners> {
  
  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  void _loadFile() {
    Repository repo = new Repository();
    repo.fetchAllBanner(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Banners")),
      body: StreamBuilder(
        stream: allBannersModelStream,
        initialData: allBannersModel ?? null,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.ok)
              return _mainContent(snapshot.data);
            else
              return allBannersModel == null
                  ? emptyBox(context, msg: "${snapshot.data.msg}")
                  : _mainContent(allBannersModel!);
          } else if (snapshot.hasError) {
            return emptyBox(context, msg: "No data available");
          }
          return shimmerItem();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigation(context: context, pageName: "addBanner"),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _mainContent(AllBannersModel model) {
    return allBannersWidget(
      context: context,
      onBanner: (AllBannersData data) => _onBanner(data),
      model: model,
    );
  }

  void _onBanner(AllBannersData data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BannerDetails(
          allBannersData: data,
          fromAdmin: true,
        ),
      ),
    );
  }
}
