import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shuttle_bus_fronted/bus_station.dart';
import 'package:shuttle_bus_fronted/custom_bottom_bar.dart';
import 'package:shuttle_bus_fronted/services/api_service.dart';

class Homepages extends StatefulWidget {
  const Homepages({super.key});

  @override
  State<Homepages> createState() => _HomepagesState();
}

class _HomepagesState extends State<Homepages> {
  OverlayEntry? overlayEntry;
  int currentIndex = 0;

  String selectedLine = "line1";
  final MapController mapController = MapController();
  double currentZoom = 16;

  List<dynamic> stationData = [];
  Future<void> fetchStations() async {
    try {
      final data = await ApiService.getStations(selectedLine);
      setState(() {
        stationData = data;
      });
    } catch (e) {
      print("API ERROR: $e");
    }
  }

  //Markers color by status
  Color getColor(String status) {
    switch (status) {
      case "LOW":
        return Colors.green;
      case "MEDIUM":
        return Colors.orange;
      case "HIGH":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  //line 1
  final List<Map<String, dynamic>> line1 = [
    {
      "name": "Station 01 (จุดหอพักลำดวน 2)",
      "lat": 20.05896500699539,
      "lng": 99.8988796884786,
    },
    {
      "name": "Station 02(จุดพักลำดวน 7 ขาเข้า)",
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
      "name": "Station 15 (จุด หอพักลำดวน 7 ขาออก)",
      "lat": 20.056724686542545,
      "lng": 99.89712571588397,
    },
    {
      "name": "Station 16 (จุด ครัวลำดวน)",
      "lat": 20.058276924103307,
      "lng": 99.89811278167763,
    },
  ];

  //line 2
  final List<Map<String, dynamic>> line2 = [
    {
      "name": "Station 01 (จุดหอพักลำดวน 2)",
      "lat": 20.05896500699539,
      "lng": 99.8988796884786,
    },
    {
      "name": "Station 02(จุดพักลำดวน 7 ขาเข้า)",
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
      "name": "Station 09 (จุด โรงพยาบาลแม่ฟ้าหลวง)",
      "lat": 20.041278409327774,
      "lng": 99.89430864493072,
    },
    {
      "name": "Station 10 (จุด อาคาร m - square)",
      "lat": 20.045780781087203,
      "lng": 99.89135359185909,
    },
    {
      "name": "Station 11 (จุด ศูนย์จีน ขาออก)",
      "lat": 20.048986374924546,
      "lng": 99.89118215098704,
    },
    {
      "name": "Station 12 (จุด หอพักจีน ขาออก)",
      "lat": 20.05134933875068,
      "lng": 99.8914018941547,
    },
    {
      "name": "Station 13 (จุด สนามกีฬากลาง)",
      "lat": 20.054763275437402,
      "lng": 99.89454537873918,
    },
    {
      "name": "Station 14 (จุด หอพักลำดวน 7 ขาออก)",
      "lat": 20.056724686542545,
      "lng": 99.89712571588397,
    },
    {
      "name": "Station 15 (จุด ครัวลำดวน)",
      "lat": 20.058276924103307,
      "lng": 99.89811278167763,
    },
  ];

  List<Map<String, dynamic>> getSelectedLine() {
    return selectedLine == "line1" ? line1 : line2;
  }

  Future<List<LatLng>> fetchRealRoute() async {
    final points = getSelectedLine();

    // 🔥 สร้างพิกัด lng,lat (สำคัญมาก)
    String coords = points.map((p) => "${p["lng"]},${p["lat"]}").join(";");

    final url =
        "https://router.project-osrm.org/route/v1/driving/$coords?overview=full&geometries=geojson";

    try {
      final res = await http.get(Uri.parse(url));
      final data = jsonDecode(res.body);

      final routeCoords = data["routes"][0]["geometry"]["coordinates"];

      return routeCoords.map<LatLng>((c) {
        return LatLng(c[1], c[0]); // lat,lng
      }).toList();
    } catch (e) {
      print("❌ ROUTE ERROR: $e");
      return [];
    }
  }

  List<LatLng> route = [];

  void updateRoute() async {
    final newRoute = await fetchRealRoute();

    setState(() {
      route = newRoute;
    });
  }

  //bus animation
  List<int> busIndexes = [0, 10, 20, 30];
  bool isMoving = true;

  @override
  void initState() {
    super.initState();
    updateRoute();
    startBusAnimation();

    fetchStations(); //
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

        double lat =
            0.5 *
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

        double lng =
            0.5 *
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

  // Support-it Email
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: const LatLng(20.045, 99.894),
              initialZoom: currentZoom,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png",
                subdomains: ['a', 'b', 'c', 'd'],
              ),

              // Route Line
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: route,
                    color: selectedLine == "line1"
                        ? Colors
                              .grey // line1
                        : Colors.lightGreen, // line 2
                    strokeWidth: 4,
                  ),
                ],
              ),

              // Stations Markers
              MarkerLayer(
                markers: getSelectedLine().map((station) {
                  // 🔥 หา station จาก DB ด้วย lat/lng (ไม่ใช้ index → ไม่พัง)
                  var real = stationData.isNotEmpty
                      ? stationData.firstWhere(
                          (s) =>
                              s["lat"] == station["lat"] &&
                              s["lng"] == station["lng"],
                          orElse: () => null,
                        )
                      : null;

                  int waiting = real != null ? real["waiting"] ?? 0 : 0;
                  String status = real != null
                      ? real["status"] ?? "LOW"
                      : "LOW";

                  return Marker(
                    point: LatLng(station["lat"], station["lng"]),
                    width: 60,
                    height: 60,
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            content: Text(
                              "${station["name"]}\n"
                              "จำนวนผู้โดยสาร: $waiting คน\n"
                              "รถจะมาถึงในอีก: 5 นาที",
                              style: GoogleFonts.kanit(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      },

                      // 🔥 เปลี่ยนตรงนี้
                      child: Icon(
                        Icons.location_on,
                        color: getColor(status), // 🔥 ใช้สีจาก DB
                        size: 35,
                      ),
                    ),
                  );
                }).toList(),
              ),

              // BUS
              MarkerLayer(
                markers: busIndexes.map((i) {
                  if (route.isEmpty)
                    return const Marker(point: LatLng(0, 0), child: SizedBox());

                  return Marker(
                    point: route[i % route.length],
                    width: 50,
                    height: 50,
                    child: Image.asset('assets/bus.png'),
                  );
                }).toList(),
              ),
            ],
          ),

          // Zoom Map Button
          Positioned(
            bottom: 120,
            right: 20,
            child: Column(
              children: [
                // Zoom In
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        currentZoom += 0.5;
                      });
                      mapController.move(
                        mapController.camera.center,
                        currentZoom,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // Zoom Out
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        currentZoom -= 0.5;
                      });
                      mapController.move(
                        mapController.camera.center,
                        currentZoom,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          //Selected Line Button
          Positioned(
            top: 120,
            left: 20,
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedLine == "line1"
                        ? Colors.black
                        : Colors.white,
                    foregroundColor: selectedLine == "line1"
                        ? Colors.white
                        : Colors.black,
                    side: const BorderSide(color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedLine = "line1";
                    });
                    updateRoute();
                  },
                  child: const Text("Line 1"),
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedLine == "line2"
                        ? Colors.green
                        : Colors.white,
                    foregroundColor: selectedLine == "line2"
                        ? Colors.white
                        : Colors.black,
                    side: const BorderSide(color: Colors.white),
                  ),
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
                  // Help button
                  IconButton(
                    icon: const Icon(Icons.help_outline),
                    onPressed: showHelpPopup,
                  ),

                  // Menu button
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

          //bottom bar => custom_bottom_bar.dart
          CustomBottomBar(currentIndex: 0),
        ],
      ),
    );
  }
}
