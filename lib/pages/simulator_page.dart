import 'package:eny/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/colors.dart';

class SimulatorPage extends StatefulWidget {
  const SimulatorPage({super.key});

  @override
  State<SimulatorPage> createState() => _SimulatorPageState();
}

class _SimulatorPageState extends State<SimulatorPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      CupertinoSliverNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        largeTitle: const Text(
          'Simulateur',
          style: TextStyle(
            color: AppColors.activColor,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
          ),
        ),
        stretch: true,
        border: Border(),
      ),
    SliverGrid(
    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 350.0,
    mainAxisSpacing: 30,
    childAspectRatio: 1,
    mainAxisExtent: 180,
    ),
    delegate: SliverChildBuilderDelegate((context, index) => Hero(
        tag: '$index',
        child: GestureDetector(
          onTap: () {
          // Presentation de la selection de l'energie à simuler
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 150,
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
                        padding:
                        const EdgeInsets.only(top: 15, left: 15, right: 15),
                        child: Text(
                          'jalkfdj',
                          style: TextStyle(
                              color: Theme.of(context).disabledColor,
                              fontSize: 14,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0),
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis, // new
                        )
                        //     : Container(
                        //   height: 14,
                        //   decoration: BoxDecoration(
                        //     borderRadius: borderRadius,
                        //     color: Theme.of(context).hoverColor,
                        //   ),
                        // ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 8, left: 8, right: 8),
                        child: Text(
                          'kjkjldsaf',
                          style: TextStyle(
                              color: Theme.of(context).disabledColor,
                              fontSize: 14,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0),
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis, // new
                        )
                            // : const SizedBox(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          'lsjdlfa',
                          style: TextStyle(
                              color: Theme.of(context).cardColor,
                              fontSize: 14,
                              fontFamily: 'Nunito',
                              decoration: TextDecoration.none,
                              letterSpacing: 0),
                          softWrap: false,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis, // new
                        )
                            // : const SizedBox(),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'jkalkjsadf',
                        style: TextStyle(
                            color: Theme.of(context).cardColor,
                            fontSize: 14,
                            fontFamily: 'Nunito',
                            letterSpacing: 0),
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, // new
                      ),
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: Theme.of(context).hintColor,
                      )
                    ],
                  )
                  //     : Container(
                  //   alignment: Alignment.centerRight,
                  //   decoration: BoxDecoration(
                  //     borderRadius: borderRadius,
                  //     color: Theme.of(context).hoverColor,
                  //   ),
                  //   child: Container(
                  //     height: 14,
                  //     width: 14,
                  //     decoration: BoxDecoration(
                  //       shape: BoxShape.circle,
                  //       color: Theme.of(context).hintColor,
                  //       border: Border.all(
                  //         color: Theme.of(context).backgroundColor,
                  //         width: 2,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                )
              ],
            ),
          ),
        ),
      ),),),
    ]);
  }
}
