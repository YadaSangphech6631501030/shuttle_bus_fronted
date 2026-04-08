import 'package:flutter/material.dart';
import 'package:shuttle_bus_fronted/bus_time.dart';

class BusStationPage extends StatelessWidget {
  const BusStationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2), // 🔥 เทาอ่อนเหมือนรูป
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔹 Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "MFU Transit",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // ❗ ปุ่ม X มีกรอบเขียว
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // 🔹 สาย 1
              const LineSection(
                title: "สาย 1",
                stations: [
                  "01 จุดหอพักลาน 2",
                  "02 จุดอาคาร F",
                  "03 จุดอาคาร M-square",
                  "04 จุดศูนย์จีน ขาออก",
                  "05 จุดทางเข้าสระว่ายน้ำ",
                ],
              ),

              const SizedBox(height: 20),

              // 🔹 สาย 2
              const LineSection(
                title: "สาย 2(โรงพยาบาลแม่ฟ้าหลวง)",
                stations: [
                  "01 จุดหอพักลาน 2",
                  "02 จุดอาคาร F",
                  "03 จุดอาคาร M-square",
                  "04 จุดศูนย์จีน ขาออก",
                  "05 จุดทางเข้าสระว่ายน้ำ",
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LineSection extends StatefulWidget {
  final String title;
  final List<String> stations;

  const LineSection({
    super.key,
    required this.title,
    required this.stations,
  });

  @override
  State<LineSection> createState() => _LineSectionState();
}

class _LineSectionState extends State<LineSection> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // 🔥 ปุ่มดำเหมือนในรูป
        GestureDetector(
          onTap: () {
            setState(() {
              isOpen = !isOpen;
            });
          },
          child: Container(
            height: 60,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.add_circle_outline, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        // 🔽 แสดง list เมื่อกด
        if (isOpen)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: const Color(0xffEDEDED),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: widget.stations.map((station) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(station),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BusTimePage(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                  ],
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}