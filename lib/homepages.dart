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

  // 🚍 รถ 4 คัน
  List<int> busIndexes = [0, 30, 60, 90];
  bool isMoving = true;
  List<LatLng> route = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      startBusAnimation();
    });
  }

  void startBusAnimation() {
    // เคลื่อนที่
    Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (!mounted) return;

      if (isMoving && route.isNotEmpty) {
        setState(() {
          for (int i = 0; i < busIndexes.length; i++) {
            busIndexes[i] = (busIndexes[i] + 1) % route.length;
          }
        });
      }
    });

    // หยุด/วิ่ง ทุก 5 วิ
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) return;
      setState(() {
        isMoving = !isMoving;
      });
    });
  }

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
              color: Colors.transparent,
              child: Container(
                width: 300,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.email_outlined),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Email us\nsupportit@gmail.com",
                        style: GoogleFonts.kanit(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
  }

  /// 🔥 เส้นโค้งลื่น
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
                (2 * p0.latitude -
                        5 * p1.latitude +
                        4 * p2.latitude -
                        p3.latitude) *
                    tt +
                (-p0.latitude +
                        3 * p1.latitude -
                        3 * p2.latitude +
                        p3.latitude) *
                    ttt);

        double lng = 0.5 *
            ((2 * p1.longitude) +
                (-p0.longitude + p2.longitude) * t +
                (2 * p0.longitude -
                        5 * p1.longitude +
                        4 * p2.longitude -
                        p3.longitude) *
                    tt +
                (-p0.longitude +
                        3 * p1.longitude -
                        3 * p2.longitude +
                        p3.longitude) *
                    ttt);

        result.add(LatLng(lat, lng));
      }
    }
    result.add(points.last);
    return result;
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> line1 = [
      {"name": "Station 01", "lat": 20.05896, "lng": 99.89887},
      {"name": "Station 02", "lat": 20.05708, "lng": 99.89702},
      {"name": "Station 03", "lat": 20.05087, "lng": 99.89133},
      {"name": "Station 04", "lat": 20.04889, "lng": 99.89132},
      {"name": "Station 05", "lat": 20.04821, "lng": 99.89322},
      {"name": "Station 06", "lat": 20.04723, "lng": 99.89329},
      {"name": "Station 07", "lat": 20.04560, "lng": 99.89153},
      {"name": "Station 08", "lat": 20.04399, "lng": 99.89340},
      {"name": "Station 09", "lat": 20.04389, "lng": 99.89521},
      {"name": "Station 10", "lat": 20.04334, "lng": 99.89513},
      {"name": "Station 11", "lat": 20.04578, "lng": 99.89135},
      {"name": "Station 12", "lat": 20.04898, "lng": 99.89118},
      {"name": "Station 13", "lat": 20.05134, "lng": 99.89140},
      {"name": "Station 14", "lat": 20.05476, "lng": 99.89454},
      {"name": "Station 15", "lat": 20.05672, "lng": 99.89712},
      {"name": "Station 16", "lat": 20.05827, "lng": 99.89811},
    ];

    final rawPoints =
        line1.map((e) => LatLng(e["lat"], e["lng"])).toList();

    final smoothPoints = catmullRomSpline(rawPoints);

    // 🔥 set route ให้รถวิ่ง
    route = smoothPoints;

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(20.045, 99.894),
              initialZoom: 16,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
                subdomains: ['a', 'b', 'c', 'd'],
              ),

              /// 🟢 เส้นทาง
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: smoothPoints,
                    color: Colors.green,
                    strokeWidth: 4,
                  ),
                ],
              ),

              /// 🔴 ป้าย
              MarkerLayer(
                markers: line1.map((station) {
                  return Marker(
                    point: LatLng(station["lat"], station["lng"]),
                    width: 60,
                    height: 60,
                    child: const Icon(Icons.location_on,
                        color: Colors.red, size: 35),
                  );
                }).toList(),
              ),

              /// 🚍 รถวิ่ง
              MarkerLayer(
                markers: busIndexes.map((index) {
                  return Marker(
                    point: route[index],
                    width: 50,
                    height: 50,
                    child: Image.asset('assets/bus.png'),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}