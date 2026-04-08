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
  // left menu for  support admin
  OverlayEntry? overlayEntry;
  void showHelpPopup() {
    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              overlayEntry?.remove();
            },
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

      double lat = 0.5 * ((2 * p1.latitude) +
          (-p0.latitude + p2.latitude) * t +
          (2 * p0.latitude - 5 * p1.latitude + 4 * p2.latitude - p3.latitude) * tt +
          (-p0.latitude + 3 * p1.latitude - 3 * p2.latitude + p3.latitude) * ttt);

      double lng = 0.5 * ((2 * p1.longitude) +
          (-p0.longitude + p2.longitude) * t +
          (2 * p0.longitude - 5 * p1.longitude + 4 * p2.longitude - p3.longitude) * tt +
          (-p0.longitude + 3 * p1.longitude - 3 * p2.longitude + p3.longitude) * ttt);

      result.add(LatLng(lat, lng));
    }
  }
  result.add(points.last);
  return result;
}

  // Map MFU Bus
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> line1 = [
      {
        "name": "Station 01 (จุดหอพักลำดวน 2)",
        "lat": 20.05896500699539,
        "lng": 99.8988796884786,
      },
      {
        "name": "Station 02(จุดพักลำดวน 7)",
        "lat": 20.057081156842653,
        "lng": 99.89702395554524,
      },
      {
        "name": "Station 03 (จุด หอพักจีน ขาเข้า)",
        "lat": 20.050870176213458,
        "lng": 99.8913375758622,
      },
      {
        "name": "Station 04 (จุด ศูนย์จีน ขาเข้า)",
        "lat": 20.048895164537097,
        "lng": 99.89132709650245,
      },
      {
        "name": "Station 05 (จุด ลานจอดหอพัก F)",
        "lat": 20.048215214947664,
        "lng": 99.89322591378016,
      },
      {
        "name": "Station 06 (จุด อาคารโรงอาหาร D1)",
        "lat": 20.047237196545165,
        "lng": 99.89329478216467,
      },
      {
        "name": "Station 07 (จุด สระน้ำวงรี ลานดาว)",
        "lat": 20.045606104291842,
        "lng": 99.89153621441135,
      },
      {
        "name": "Station 08 (จุด อาคารโรงอาหาร E2 ขาเข้า)",
        "lat": 20.04399637202456,
        "lng": 99.893402801156,
      },
      {
        "name": "Station 09 (จุด อาคารเรียนรวม C3 C2 และ หอประชุมสมเด็จย่า C4)",
        "lat": 20.043895277649657,
        "lng": 99.89521575716422,
      },
      {
        "name": "Station 10 (จุด อาคารเรียนรวม C5 )",
        "lat": 20.043346224233225,
        "lng": 99.89513551300819,
      },
      {
        "name": "Station 11 (จุด อาคาร m - square)",
        "lat": 20.045780781087203,
        "lng": 99.89135359185909,
      },
      {
        "name": "Station 12 (จุด ศูนย์จีน ขาออก)",
        "lat": 20.048986374924546,
        "lng": 99.89118215098704,
      },
      {
        "name": "Station 13 (จุด หอพักจีน ขาออก)",
        "lat": 20.05134933875068,
        "lng": 99.8914018941547,
      },
      {
        "name": "Station 14 (จุด สนามกีฬากลาง)",
        "lat": 20.054763275437402,
        "lng": 99.89454537873918,
      },
      {
        "name": "Station 15 (จุด หอพักลำดวน 7)",
        "lat": 20.056724686542545,
        "lng": 99.89712571588397,
      },
      {
        "name": "Station 16 (จุด ครัวลำดวน)",
        "lat": 20.058276924103307,
        "lng": 99.89811278167763,
      },
    ];

    final rawPoints = line1.map((e) => LatLng(e["lat"], e["lng"])).toList();

    print(rawPoints);

    final smoothPoints = catmullRomSpline(rawPoints);

    return Scaffold(
      body: Stack(
        children: [
          // MFU Map
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
              // Line

              // Markers
              MarkerLayer(
                markers: line1.map((station) {
                  return Marker(
                    point: LatLng(station["lat"], station["lng"]),
                    width: 60,
                    height: 60,
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (_) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text(
                              "${station["name"]}\nจำนวนผู้โดยสารที่รออยู่ : 0 คน",
                              style: GoogleFonts.kanit(fontSize: 18),
                            ),
                          ),
                        );
                      },
                      child: Transform.translate(
                        offset: const Offset(0, -10), // ลอยขึ้น 10 px
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 36,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              // route bus line
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: smoothPoints,
                    color: Colors.green,
                    strokeWidth: 4,
                  ),
                ],
              ),
            ],
          ),

          // App bar
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
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // left menu support admin
                  Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: IconButton(
                      icon: const Icon(Icons.help_outline),
                      onPressed: showHelpPopup,
                    ),
                  ),

                  // right menu line of bus
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
          //  Menu bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 70,
            right: 70,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Menu Home
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = 0;
                      });
                    },
                    child: Transform.translate(
                      offset: const Offset(0, -20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,

                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.home, color: Colors.black),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Home",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Menu Bus
                  Center(child: Image.asset('assets/bus.png', height: 50)),

                  // Menu Profile
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
                      children: [
                        Icon(
                          Icons.person,
                          color: currentIndex == 2
                              ? Colors.white
                              : Colors.white70,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Account",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
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

  int currentIndex = 0;
}
