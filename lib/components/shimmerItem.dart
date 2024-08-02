import 'package:rally/spec/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerItem({
  bool useGrid = false,
  int numOfItem = 5,
}) {
  return useGrid
      ? SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (int x = 0; x < numOfItem; ++x) ...[
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    color: BLACK,
                    height: 150,
                    width: 150,
                  ),
                ),
                SizedBox(width: 10),
              ],
            ],
          ),
        )
      : Column(
          children: [
            for (int x = 0; x < numOfItem; ++x) ...[
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    color: Colors.white,
                  ),
                  title: Container(
                    width: double.infinity,
                    height: 20,
                    color: Colors.white,
                  ),
                  subtitle: Container(
                    margin: EdgeInsets.only(top: 5),
                    width: double.infinity,
                    height: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 5),
            ]
          ],
        );
}
