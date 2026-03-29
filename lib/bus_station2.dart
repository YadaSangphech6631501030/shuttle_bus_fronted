import 'package:flutter/material.dart';

class BusStation2Page extends StatelessWidget {
  const BusStation2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], 
      body: SafeArea(
        child: SingleChildScrollView( 
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                      
                      ),
                      child: const Icon(Icons.close),
                    )
                  ],
                ),

                const SizedBox(height: 8),

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

                const SizedBox(height: 16),

                // 🔹 สาย 2
                const LineSection(
                  title: "สาย 2 (โรงพยาบาลแม่ฟ้าหลวง)",
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
  String search = "";

  @override
  Widget build(BuildContext context) {
    final filtered = widget.stations
        .where((s) => s.toLowerCase().contains(search.toLowerCase()))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 ปุ่มดำ (แก้ layout ให้ตรงจริง)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              const Icon(Icons.remove_circle_outline, color: Colors.white),
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

        const SizedBox(height: 10),

        // 🔍 Search
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 3,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: TextField(
            onChanged: (value) {
              setState(() {
                search = value;
              });
            },
            decoration: const InputDecoration(
              hintText: "Find Station...",
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),

        const SizedBox(height: 10),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: filtered.isEmpty
                ? [const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text("ไม่พบสถานี"),
                  )]
                : filtered.map((station) {
                    return Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(station),
                          const Icon(Icons.arrow_forward_ios,size: 14),
                        ],
                      ),
                    );
                  }).toList(),
          ),
        ),
      ],
    );
  }
}