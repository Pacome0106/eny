import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eny/pages/datail_province.dart';
import 'package:eny/pages/home_page.dart';
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
  List provinces = [];
  List provincesSearch = [];
  List reference = [];
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
  getreference() async {
    await FirebaseFirestore.instance
        .collection("referenceValue")
        .get()
        .then((value) {

      reference= value.docs;
    });
    if (!mounted) {
      return;
    }
    setState(() {
      reference;
    });
  }

  calculs(double ref, double value){
    double result = 0.0;
    result = (value * 100)/ ref;
    return result;

  }


  @override
  void initState() {
    getreference();
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
          (context, index) {
            var provincesAll = !search ? provinces[index] : provincesSearch[index];

           double superficies = calculs(double.parse(reference.first['superficial']) ,double.parse(provincesAll['superficial']));
           double population = calculs(double.parse(reference.first['population']) ,double.parse(provincesAll['population']));

           if (data[0]['category'] == 'Superficie') {
             data[0]['sales'] = double.parse(superficies.toStringAsFixed(1));
           }
           if (data[1]['category'] == 'Population') {
             data[1]['sales'] = double.parse(population.toStringAsFixed(1));
           }
           if (data[2]['category'] == 'Density') {
             data[2]['sales'] = double.parse((double.parse(provincesAll['density'])/100).toStringAsFixed(1));
           }
           if (data[3]['category'] == 'Taux_electric') {
             data[3]['sales'] = double.parse(provincesAll['taux d\'electrification']==''?'0':provincesAll['taux d\'electrification']);
           }

            return
            Scrollbar(
              child: Hero(
            tag: "$index",
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailProvince(
                      tag: index.toString(),
                      data: provincesAll,
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
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextLarge(
                          text:
                                 provincesAll['name'][0].toUpperCase() +
                              provincesAll['name'].substring(1),

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
                                text:
                                    "${provincesAll['superficial']} km2",
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
                                text:
                                    "${provincesAll['population']} hab",
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
                                text:
                                    "${provincesAll['density']} hab/km3",
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
                              text:
                                  "${provincesAll['taux d\'electrification']} %",
                              color: Colors.black,
                              size: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 90,
                      height: 90,
                      child: Chart(
                        data: data,
                        variables: {
                          'category': Variable(
                            accessor: (Map map) => map['category'] as String,
                          ),
                          'sales': Variable(
                            accessor: (Map map) => map['sales'] as num,
                            scale: LinearScale(min: 0),
                          ),
                        },
                        marks: [
                          IntervalMark(
                            position: Varset('percent') / Varset('category')  ,
                            color: ColorEncode(
                              variable: 'category',
                              values: types.values.toList(),
                            ),
                            modifiers: [StackModifier()],
                            shape: ShapeEncode(
                              value:RectShape(
                                labelPosition: 0.5,
                                histogram: true,


                              ),

                            ),

                            label: LabelEncode(
                              encoder: (tuple) => Label(
                                tuple['sales'].toString(),
                                LabelStyle(
                                    textStyle: TextStyle(color: Colors.black, fontSize: 10)),
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
          )
          );
  },
          childCount: !search ? provinces.length : provincesSearch.length,
        ),
      )
    ]);
  }

  static List<Map<String, dynamic>> data = [
    {'category': 'Superficie', 'sales': 0},
    {'category': 'Population', 'sales': 0},
    {'category': 'Density', 'sales': 0},
    {'category': 'Taux_electric', 'sales': 0},
  ];
  final types = {
    'Type 1': Colors.green,
    'Type 2': Colors.lightBlue,
    'Type 3': Colors.amber,
    'Type 4': const Color(0xFFFF6422)
  };
}
