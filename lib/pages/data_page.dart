import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eny/pages/datail_province.dart';
import 'package:eny/widgets/app_text_large.dart';
import 'package:eny/widgets/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:provider/provider.dart';

import '../provider/dark_theme_provider.dart';

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  List provinces = [
  ];
  List provincesSearch = [];
  bool search = false;
  TextEditingController textController = TextEditingController();

  getprovince() async {
    await FirebaseFirestore.instance
        .collection("provinces")
        .orderBy('name')
        .get()
        .then((value) {
      for (var province in value.docs) {
        provinces.add(province);
      }
    });
    if (!mounted) {
      return;
    }
    setState(() {
      provinces;
    });
  }
  @override
  void initState() {
   getprovince();
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    bool isTheme = themeChange.darkTheme;
    return CustomScrollView(slivers: [
      CupertinoSliverNavigationBar(
        backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,
        largeTitle: const Text(
          'Statistiques',
          style: TextStyle(
            color: AppColors.activColor,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
          ),
        ),
        stretch: true,
        border: Border(),
        trailing: GestureDetector(
          onTap: () {
            isTheme = !isTheme;
            themeChange.darkTheme = isTheme;
            setState(
                  () {
                isTheme;
              },
            );
          },
          child: !isTheme
              ? const Icon(CupertinoIcons.moon_stars_fill)
              : const Icon(CupertinoIcons.brightness_solid),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: CupertinoSearchTextField(
            controller: textController,
            onChanged: (String value) {
              provincesSearch = [];
              for (int i = 0; i < provinces.length; i++) {
                String string = provinces[i]['name'];
                if (string.contains(value.trim())) {
                  provincesSearch.add(provinces[i]);
                }
              }
              setState(() {
                provincesSearch;
                search = true;
              });
            },
          ),
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) =>
              Scrollbar(
                  child: Hero(
                    tag: "$index",
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailProvince(
                                  tag: index.toString(),
                                  name: !search
                                      ? provinces[index]['name']
                                      : provincesSearch[index]['name'],
                                ),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        height: 160,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppTextLarge(
                                  text: !search
                                      ?provinces.isNotEmpty? provinces[index]['name']:''
                                      : provincesSearch[index]['name'],
                                  size: 26,
                                  color: AppColors.activColor,
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      height: 18,
                                      width: 18,
                                      color: Colors.green,
                                    ),
                                    AppTextLarge(
                                        text: "Superficie: ",
                                        color: Colors.black,
                                        size: 16),
                                    AppTextLarge(
                                        text: " 1874 ",
                                        color: Colors.black,
                                        size: 16),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      height: 18,
                                      width: 18,
                                      color: Colors.lightBlue,
                                    ),
                                    AppTextLarge(
                                        text: "Population: ",
                                        color: Colors.black,
                                        size: 16),
                                    AppTextLarge(
                                        text: "4379875",
                                        color: Colors.black,
                                        size: 16),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      height: 18,
                                      width: 18,
                                      color: Colors.amber,
                                    ),
                                    AppTextLarge(
                                        text: "Densité: ",
                                        color: Colors.black,
                                        size: 16),
                                    AppTextLarge(
                                        text: "47497 ",
                                        color: Colors.black,
                                        size: 16),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      height: 18,
                                      width: 18,
                                      color: Colors.deepOrange,
                                    ),
                                    AppTextLarge(
                                        text: "Taux d'électrification: ",
                                        color: Colors.black,
                                        size: 16),
                                    AppTextLarge(
                                        text: " 47839",
                                        color: Colors.black,
                                        size: 16),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 80,
                              height: 80,
                              child: Chart(
                                data: data,
                                variables: {
                                  'category': Variable(
                                    accessor: (
                                        Map map) => map['category'] as String,
                                  ),
                                  'sales': Variable(
                                    accessor: (Map map) => map['sales'] as num,
                                    scale: LinearScale(min: 0),
                                  ),
                                },
                                marks: [
                                  IntervalMark(
                                    position: Varset('percent') /
                                        Varset('category'),
                                    color: ColorEncode(
                                      variable: 'category',
                                      values: types.values.toList(),
                                    ),
                                    modifiers: [StackModifier()],
                                    shape: ShapeEncode(
                                      value: RectShape(
                                        labelPosition: 0.5,
                                      ),
                                    ),
                                    label: LabelEncode(
                                      encoder: (tuple) =>
                                          Label(
                                            tuple['sales'].toString(),
                                            LabelStyle(
                                                textStyle: TextStyle(
                                                    color: Colors.black)),
                                          ),
                                    ),
                                  ),
                                ],
                                transforms: [
                                  Proportion(
                                    variable: 'sales',
                                    as: 'percent',
                                  ),
                                ],
                                coord: PolarCoord(
                                  transposed: true,
                                  dimCount: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
          childCount: !search ? provinces.length : provincesSearch.length,
        ),
      )
    ]);
  }

  static const data = [
    {'category': 'Superficie', 'sales': 10},
    {'category': 'Population', 'sales': 20},
    {'category': 'Density', 'sales': 36},
    {'category': 'Taux_electric', 'sales': 56},
  ];
  final types = {
    'Type 1': Colors.green,
    'Type 2': Colors.lightBlue,
    'Type 3': Colors.amber,
    'Type 4': const Color(0xFFFF6422)
  };
}
