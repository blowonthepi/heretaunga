import 'dart:convert';
import 'dart:math';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:heretaunga/tools/ColourGenerator.dart';
import 'package:heretaunga/tools/CheckIsConnected.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapScreen extends StatefulWidget {
  final String query;

  MapScreen({this.query});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapboxMapController controller;
  var props;
  bool isNetConnect = false;

  void _onMapCreated(MapboxMapController controller) async {
    setState(() {
      this.controller = controller;
    });
  }

  @override
  void initState() {
    checkInternet();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result != ConnectivityResult.none) {
        setState(() {
          isNetConnect = true;
        });
      }
    });
    super.initState();
  }

  checkInternet() async {
    bool connected = await isConnected;
    setState(() {
      isNetConnect = connected;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Text(isNetConnect
              ? "Loading Map"
              : "This map is not yet available offline."),
        ),
        isNetConnect
            ? MapboxMap(
                accessToken:
                    "pk.eyJ1IjoiaXRzbGlhbWVkd2FyZHMiLCJhIjoiY2pxMWJ1ajR6MHZ6YTQ5cW16amQ4bDN3OCJ9.7VZSoLi7x7z7-d10c7kqkw",
                initialCameraPosition: CameraPosition(
                  target: LatLng(-41.12918, 175.054443),
                  bearing: 89.6,
                  zoom: 17,
                ),
                onMapCreated: _onMapCreated,
                onMapClick: (point, latLng) async {
                  List properties = await controller.queryRenderedFeatures(
                      point, ['hc-buildings', 'hc-bounds'], null);
                  if (properties.length > 0) {
                    Map props = jsonDecode(properties[0]);

                    setState(() {
                      this.props = props;
                    });
                  } else {
                    setState(() {
                      this.props = null;
                    });
                  }
                },
                cameraTargetBounds: CameraTargetBounds(
                  LatLngBounds(
                    southwest: LatLng(-47.258509, 165.427739),
                    northeast: LatLng(-33.759342, 179.232647),
                  ),
                ),
                styleString:
                    "mapbox://styles/itsliamedwards/ckkrwqyvm0cvf17qzktb395cy",
                rotateGesturesEnabled: false,
                tiltGesturesEnabled: false,
                myLocationEnabled: true,
                trackCameraPosition: true,
                compassEnabled: false,
                myLocationTrackingMode: MyLocationTrackingMode.Tracking,
              )
            : Container(),
        isNetConnect
            ? props != null
                ? bottomCard(
                    props['properties']['name'] ?? "No title given",
                    props['properties']['subject'] ??
                        "No extra information given",
                    props['properties']['cypher'])
                : bottomCard(null, "Tap a tile to learn about that area.", null)
            : Container(),
      ],
    );
  }

  bottomCard(String title, String subtitle, String cypher) {
    // Enforce written line breaks
    if (subtitle.contains("\\n")) {
      subtitle = subtitle.replaceAll("\\n", "\n");
    }
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - (16 * 2)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
          color: Theme.of(context).backgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              title != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          cypher != null
                              ? Chip(
                                  backgroundColor:
                                      Theme.of(context).accentColor,
                                  label: Text(
                                    "Code: $cypher",
                                    style: TextStyle(
                                      color: contrastingTextColor(
                                          Theme.of(context).accentColor),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              : Container(),
                          Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
