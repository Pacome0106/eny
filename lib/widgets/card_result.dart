import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import 'app_text_large.dart';
import 'colors.dart';

Widget cardResult(List list){
  return
    SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150.0,
        mainAxisSpacing: 30,
        childAspectRatio: 1,
        mainAxisExtent: 190,
      ),
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
              alignment: Alignment.center,
              height: 190,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: Theme.of(context).focusColor,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 15, left: 15, right: 15),
                      child: AppTextLarge(
                        text: list[index]['name']!,
                        color: Theme.of(context).disabledColor,
                        size: 16,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 8, left: 8, right: 8),
                    child: Center(
                      child: AppTextLarge(
                        text: list[index]['value']!,
                        color: AppColors.activColor,
                        size: 28, // new
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        childCount: 3,
      ),
    );
}