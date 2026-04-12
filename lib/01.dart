import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shuttle_bus_fronted/account_user.dart';
import 'package:shuttle_bus_fronted/bus_station.dart';

class Homepages extends StatefulWidget {
  const Homepages({super.key});

  @override
  State<Homepages> createState() => _HomepagesState();
}

class _HomepagesState extends State<Homepages> {
  OverlayEntry? overlayEntry;

  // =========================
  // LINE CONTROL
  // =========================
  String selectedLine = "line1";

  final List<Map<String, dynamic>> line1 = [
    {"name": "Station 01", "lat": 20.05896500699539, "lng": 99.8988796884786},
    {"name": "Station 02", "lat": 20.057081156842653, "lng": 99.89702395554524},
    {"name": "Station 03", "lat": 20.050870176213458, "lng": 99.8913375758622},
    {"name": "Station 04", "lat": 20.048895164537097, "lng": 99.89132709650245},
    {"name": "Station 05", "lat": 20.048215214947664, "lng": 99.89322591378016},
    {"name": "Station 06", "lat": 20.047237196545165, "lng": 99.89329478216467},
    {"name": "Station 07", "lat": 20.045606104291842, "lng": 99.89153621441135},
    {"name": "Station 08", "lat": 20.04399637202456, "lng": 99.893402801156},
  ];

  final List<Map<String, dynamic>> line2 = [
    {"name": "Station 01", "lat": 20.05896500699539, "lng": 99.8988796884786},
    {"name": "Station 02", "lat": 20.057081156842653, "lng": 99.89702395554524},
    {"name": "Station 03", "lat": 20.050870176213458, "lng": 99.8913375758622},
    {"name": "Station 04", "lat": 20.048895164537097, "lng": 99.89132709650245},
    {"name": "Hospital", "lat": 20.041278409327774, "lng": 99.89430864493072},
    {"name": "Station 10", "lat": 20.045780781087203, "lng": 99.89135359185909},
  ];

  List<Map<String, dynamic>> getSelectedLine() {
    return selectedLine == "line1" ? line1 : line2;
  }

  // =========================
  // ROUTE
  // =========================
  List<LatLng> route = [];

  void updateRoute() {
    final points = getSelectedLine()
        .map((e) => LatLng(
              (e["lat"] as double),
              (e["lng"] as double),
            ))
        .toList();

    setState(() {
      route = catmullRomSpline(points);
    });
  }

  // =========================
  // BUS ANIMATION
  // =========================
  List<int> busIndexes = [0, 10, 20, 30];
  bool isMoving = true;

  @override
  void initState() {
    super.initState();
    updateRoute(); // ✅ สำคัญมาก
    startBusAnimation();
  }

  void startBusAnimation() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted) return;

      if (isMoving && route.isNotEmpty) {
        setState(() {
          for (int i = 0; i < busIndexes.length; i++) {
            busIndexes[i] = (busIndexes[i] + 1) % route.length;
          }
        });
      }
    });

    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) return;
      setState(() {
        isMoving = !isMoving;
      });
    });
  }

  // =========================
  // SMOOTH ROUTE
  // =========================
  List<LatLng> catmullRomSpline(List<LatLng> points, {int segments = 10}) {
    List<LatLng> result = [];

    for (int i = 0; i < points.length - 1; i++) {
      LatLng p0 = i > 0 ? points[i - 1] : points[i];
      LatLng p1 = points[i];
      LatLng p2 = points[i + 1];
      LatLng p3 = i < points.length - 2 ? points[i + 2] : points[i + 1];

      for (int j = 0; j <= segments; j++) {
        double t = j / segments;
        double tt = t * t;
        double ttt = tt * t;

        double lat = 0.5 *
            ((2 * p1.latitude) +
                (-p0.latitude + p2.latitude) * t +
                (2 * p0.latitude - 5 * p1.latitude + 4 * p2.latitude - p3.latitude) * tt +
                (-p0.latitude + 3 * p1.latitude - 3 * p2.latitude + p3.latitude) * ttt);

        double lng = 0.5 *
            ((2 * p1.longitude) +
                (-p0.longitude + p2.longitude) * t +
                (2 * p0.longitude - 5 * p1.longitude + 4 * p2.longitude - p3.longitude) * tt +
                (-p0.longitude + 3 * p1.longitude - 3 * p2.longitude + p3.longitude) * ttt);

        result.add(LatLng(lat, lng));
      }
    }

    result.add(points.last);
    return result;
  }

  // =========================
  // HELP POPUP
  // =========================
  void showHelpPopup() {
    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () => overlayEntry?.remove(),
            child: Container(color: Colors.transparent),
          ),
          Positioned(
            top: 100,
            left: 20,
            child: Material(
              child: Container(
                padding: const EdgeInsets.all(16),
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text("supportit@gmail.com"),
              ),
            ),
          )
        ],
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(20.045, 99.894),
              initialZoom: 16,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
                subdomains: ['a', 'b', 'c', 'd'],
              ),

              // ROUTE
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: route,
                    color: Colors.green,
                    strokeWidth: 4,
                  ),
                ],
              ),

              // STATIONS
              MarkerLayer(
                markers: getSelectedLine().map((station) {
                  return Marker(
                    point: LatLng(station["lat"], station["lng"]),
                    width: 60,
                    height: 60,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 35,
                    ),
                  );
                }).toList(),
              ),

              // BUS
              MarkerLayer(
                markers: busIndexes.map((i) {
                  if (route.isEmpty) return const Marker(point: LatLng(0, 0), child: SizedBox());

                  return Marker(
                    point: route[i % route.length], // ✅ กัน crash
                    width: 50,
                    height: 50,
                    child: Image.asset('assets/bus.png'),
                  );
                }).toList(),
              ),
            ],
          ),

          // =========================
          // SWITCH LINE BUTTON
          // =========================
          Positioned(
            top: 120,
            left: 20,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedLine = "line1";
                    });
                    updateRoute();
                  },
                  child: const Text("Line 1"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedLine = "line2";
                    });
                    updateRoute();
                  },
                  child: const Text("Line 2"),
                ),
              ],
            ),
          ),

          // APP BAR
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.help_outline),
                    onPressed: showHelpPopup,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}