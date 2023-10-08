import 'package:eny/widgets/colors.dart';
import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import 'app_text_large.dart';

Widget button (context,String title, IconData icon){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Expanded(child: SizedBox()),
      Container(
        margin: const EdgeInsets.all(20),
        padding:const EdgeInsets.all(8) ,
        alignment: Alignment.center,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.activColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppTextLarge(
              text: title,
              color: Theme.of(context).scaffoldBackgroundColor,
              size: 24,
            ),
            sizedbox2,
            Icon(
              icon,
              color: Theme.of(context).scaffoldBackgroundColor,
              size: 30,
            )
          ],
        ),
      ),
    ],
  );
}