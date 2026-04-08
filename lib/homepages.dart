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
  int currentIndex = 0;
  OverlayEntry? overlayEntry;

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

  /// 🔥 สร้างเส้นโค้ง
  List<LatLng> createCurve(List<LatLng> points) {
    List<LatLng> result = [];

    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];

      result.add(p1);

      final mid = LatLng(
        (p1.latitude + p2.latitude) / 2 + 0.0001,
        (p1.longitude + p2.longitude) / 2,
      );

      result.add(mid);
    }

    result.add(points.last);
    return result;
  }

  /// 🔥 หาจุดที่ใกล้เส้นที่สุด (ทำให้หมุดติดเส้น)
  LatLng getClosestPoint(LatLng target, List<LatLng> curve) {
    LatLng closest = curve.first;
    double minDist = double.infinity;

    for (var point in curve) {
      final dist = Distance().as(LengthUnit.Meter, target, point);

      if (dist < minDist) {
        minDist = dist;
        closest = point;
      }
    }

    return closest;
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> line1 = [
      {"name": "Station 01", "lat": 20.05896500699539, "lng": 99.8988796884786},
      {"name": "Station 02", "lat": 20.057081156842653, "lng": 99.89702395554524},
      {"name": "Station 03", "lat": 20.050870176213458, "lng": 99.8913375758622},
      {"name": "Station 04", "lat": 20.048895164537097, "lng": 99.89132709650245},
      {"name": "Station 05", "lat": 20.048215214947664, "lng": 99.89322591378016},
      {"name": "Station 06", "lat": 20.047237196545165, "lng": 99.89329478216467},
      {"name": "Station 07", "lat": 20.045606104291842, "lng": 99.89153621441135},
      {"name": "Station 08", "lat": 20.04399637202456, "lng": 99.893402801156},
      {"name": "Station 09", "lat": 20.043895277649657, "lng": 99.89521575716422},
      {"name": "Station 10", "lat": 20.043346224233225, "lng": 99.89513551300819},
      {"name": "Station 11", "lat": 20.045780781087203, "lng": 99.89135359185909},
      {"name": "Station 12", "lat": 20.048986374924546, "lng": 99.89118215098704},
      {"name": "Station 13", "lat": 20.05134933875068, "lng": 99.8914018941547},
      {"name": "Station 14", "lat": 20.054763275437402, "lng": 99.89454537873918},
      {"name": "Station 15", "lat": 20.056724686542545, "lng": 99.89712571588397},
      {"name": "Station 16", "lat": 20.058276924103307, "lng": 99.89811278167763},
    ];

    final rawPoints =
        line1.map((e) => LatLng(e["lat"], e["lng"])).toList();

    final curvePoints = createCurve(rawPoints);

    return Scaffold(
      body: Stack(
        children: [
          /// 🌍 MAP
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

              /// 🟢 เส้นโค้ง
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: curvePoints,
                    color: Colors.green,
                    strokeWidth: 4,
                  ),
                ],
              ),

              /// 🔴 หมุด (snap ไปบนเส้น)
              MarkerLayer(
                markers: line1.map((station) {
                  final original =
                      LatLng(station["lat"], station["lng"]);

                  final snappedPoint =
                      getClosestPoint(original, curvePoints);

                  return Marker(
                    point: snappedPoint,
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(
                              station["name"],
                              style: GoogleFonts.kanit(fontSize: 18),
                            ),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 35,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          /// 🔝 APP BAR
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                left: 16,
                right: 16,
              ),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.help_outline),
                    onPressed: showHelpPopup,
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BusStationPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          /// 🔻 BOTTOM MENU
          Positioned(
            bottom: 20,
            left: 70,
            right: 70,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.home, color: Colors.white),
                        SizedBox(height: 4),
                        Text("Home",
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ),
                  Image.asset('assets/bus.png', height: 40),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AccountUser(),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.person, color: Colors.white),
                        SizedBox(height: 4),
                        Text("Account",
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
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