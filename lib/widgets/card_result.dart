import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import 'app_text_large.dart';
import 'colors.dart';

Widget cardResult(List list, int number){
  return
    SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150.0,
        mainAxisSpacing: 30,
        childAspectRatio: 1,
        mainAxisExtent: 230,
      ),
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
              alignment: Alignment.center,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 15, left: 15, right: 15),
                      child: Center(
                        child: AppTextLarge(
                          text: list[index]['name']!,
                          color: Theme.of(context).disabledColor,
                          size: 16,
                        ),
                      ),),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 8, right: 8),
                    child: Center(
                      child: AppTextLarge(
                        text: list[index]['value']!,
                        color: AppColors.activColor,
                        size: 24, // new
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                       bottom: 8, left: 8, right: 8),
                    child: Center(
                      child: Icon(
                        list[index]['icon']!,
                        color: AppColors.activColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        childCount: number,
      ),
    );
}