import 'package:flutter/material.dart';

class ErroScreen extends StatelessWidget {
  const ErroScreen({super.key, required this.onTapRefresh});

  final Function() onTapRefresh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 80,
          width: 200,
          alignment: Alignment.center,
          child: Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: onTapRefresh,
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Stack(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(25)
                        ),
                      ),
                      const Center(
                        child: Icon(Icons.refresh, color: Colors.white, size: 20,),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              const Text("Không có kết nối Intenet",
                style: TextStyle(color: Colors.white, fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}