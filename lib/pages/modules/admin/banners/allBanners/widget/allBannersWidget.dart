import 'package:flutter/material.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/models/bannersModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget allBannersWidget({
  @required BuildContext? context,
  @required void Function(AllBannersData data)? onBanner,
  @required AllBannersModel? model,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10),
          if (model!.data!.length == 0)
            emptyBox(context!, msg: "No data available"),
          if (model.data!.length > 0)
            for (var data in model.data!) ...[
              GestureDetector(
                onTap: () => onBanner!(data),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: PRIMARYCOLOR1,
                    child: Column(
                      children: [
                        Container(
                          color: BLACK,
                          child: cachedImage(
                            context: context,
                            image: "${data.cover}",
                            height: 150,
                            width: double.maxFinite,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "${data.title}",
                                  style: h6WhiteBold,
                                ),
                              ),
                              Text("${data.dateCreated}", style: h6WhiteBold),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
        ],
      ),
    ),
  );
}
