import 'package:flutter/material.dart';

class BusTimePage extends StatelessWidget {
  const BusTimePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(18),
                ),
                // icons back
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: const Icon(Icons.arrow_back,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "01 จุดหอพักลาน 2",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

             // Bus times list
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xffEDEDED),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                     color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    
                    Row(
                      children: [
                        Expanded(child: buildHeader("เลขรถโดยสาร")),
                        const SizedBox(width: 6),
                        Expanded(child: buildHeader("จะถึงสถานีใน")),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Body
                    buildRow("01", "กำลังเข้าสู่สถานี"),
                    buildRow("02", "3 นาที 0 วินาที"),
                    buildRow("03", "8 นาที 5 วินาที"),
                    buildRow("04", "15 นาที 5 วินาที"),
                    buildRow("05", "20 นาที 0 วินาที"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Header
  Widget buildHeader(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Text(text),
    );
  }

  
  Widget buildRow(String busNo, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, 
        children: [
          SizedBox(
            width: 60,
            child: Text(
              busNo,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 70),
          SizedBox(
            width: 150,
            child: Text(
              time,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}