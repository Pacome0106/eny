import 'dart:ui';
import 'package:eny/widgets/app_text_large.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

import '../widgets/notification.dart';

class DetailProvince extends StatefulWidget {
  const DetailProvince({
    super.key,
    required this.tag,
    required this.name,
  });

  final String tag;
  final String name;

  @override
  State<DetailProvince> createState() => _DetailProvinceState();
}

class _DetailProvinceState extends State<DetailProvince> {
  bool isLocalisation = false;
  double latitude = 0.0;
  double longitude = 0.0;

  getProvinceLocation() async {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   showDialog(
    //       context: context,
    //       builder: (context) {
    //         return
    //           Icon(CupertinoIcons.arrow_2_circlepath);
    //       }
    //   );
    // });

    try {
      List<Location> locations = await locationFromAddress(
          "${widget.name} République démocratique du congo");
      if (locations.isEmpty) {
        // Impossible de trouver la province spécifiée
        notification(
            context, "Impossible de trouver la province spécifiée!", 50);
        return;
      }
      Location location = locations.first;
      setState(() {
        latitude = location.latitude;
        longitude = location.longitude;
        isLocalisation = true;
      });
      print(' Latitude: $latitude, Longitude: $longitude');
    } catch (e) {
      print(e.toString());
      if (e.toString() ==
          "PlatformException(IO_ERROR, A network error occurred trying to lookup the address ''., null, null)") {
        notification(context, "Vérifier votre connexion internet !!!", 50);
      }
    }
  }

  @override
  void initState() {
    getProvinceLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Hero(
        tag: widget.tag,
        child: CustomScrollView(slivers: [
          SliverAppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
            ),
            expandedHeight: MediaQuery.of(context).size.height * 0.6,
            elevation: 0.0,
            pinned: true,
            stretch: true,
            automaticallyImplyLeading: true,
            forceElevated: true,
            flexibleSpace: FlexibleSpaceBar(
              background: isLocalisation
                  ? FlutterMap(
                      options: MapOptions(
                        center: LatLng(latitude, longitude),
                        // Centre de la carte
                        zoom: 10.0, // Niveau de zoom initial
                      ),
                      nonRotatedChildren: const [
                        RichAttributionWidget(
                          animationConfig: ScaleRAWA(),
                          // Or `FadeRAWA` as is default
                          attributions: [
                            TextSourceAttribution(
                              'OpenStreetMap contributors',
                              //   onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                            ),
                          ],
                        ),
                      ],
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                          userAgentPackageName: 'com.example.app',
                        ),
                      ],
                    )
                  : const Center(
                      child: Icon(
                        CupertinoIcons.arrow_2_circlepath,
                        size: 35,
                      ),
                    ),
              stretchModes: const <StretchMode>[
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0.0),
              child: Container(
                padding: const EdgeInsets.only(left: 15),
                height: 50,
                width: double.maxFinite,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: AppTextLarge(
                  text: widget.name,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
