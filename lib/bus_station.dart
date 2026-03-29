import 'package:flutter/material.dart';

class BusStationPage extends StatelessWidget {
  const BusStationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView( 
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Header
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
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),

                const SizedBox(height: 20),

                // สาย 1
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

                // สาย 2
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
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    final filtered = widget.stations
        .where((s) => s.toLowerCase().contains(search.toLowerCase()))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // popup open/close
        GestureDetector(
          onTap: () {
            setState(() {
              isOpen = !isOpen;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: isOpen ? Colors.black87 : Colors.black,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                if (isOpen)
                  const BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Icon(
                  isOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

       
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState:
              isOpen ? CrossFadeState.showFirst : CrossFadeState.showSecond,

          firstChild: Column(
            children: [

              // Search
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
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
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Station List
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                    )
                  ],
                ),
                child: Column(
                  children: filtered.isEmpty
                      ? [
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text("ไม่พบสถานี"),
                          )
                        ]
                      : filtered.map((station) {
                          return Column(
                            children: [
                              ListTile(
                                title: Text(station),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                ),
                              ),
                              const Divider(height: 1),
                            ],
                          );
                        }).toList(),
                ),
              ),
            ],
          ),

          secondChild: const SizedBox(),
        ),
      ],
    );
  }
}