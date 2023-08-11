import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mussic_app/component/appState.dart';
import 'package:mussic_app/component/app_assets.dart';
import 'package:mussic_app/component/app_color.dart';
import 'package:mussic_app/model/charts.dart';
import 'package:mussic_app/screen/play_mussic_screen.dart';
import 'package:mussic_app/screen/zing_chart_week.dart';
import 'package:mussic_app/widget/container_app_bar.dart';
import 'package:mussic_app/widget/container_button.dart';
import 'package:mussic_app/widget/container_list_top_music.dart';
import 'package:mussic_app/widget/container_zingcharts_week.dart';

class ZingCharts extends StatefulWidget {
  const ZingCharts({super.key, required this.chart});

  final Chart chart;

  @override
  State<ZingCharts> createState() => _ZingChartsState();
}

class _ZingChartsState extends State<ZingCharts> {

  int lengthZingCharts = 20;
  final DateTime now = DateTime.now();
  final StreamController<int> _controller = StreamController<int>.broadcast();

  @override
  void initState() {
    _controller.sink.add(20);
    super.initState();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          containerAppBar(
            imageNetWork: widget.chart.rTChart!.songs![0].thumbnailM!,
            title: "ZINGCHART",
            subTitle: "Cập nhật ${now.day}/${now.month}/${now.year}",
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){},
                  child: Container(
                    height: 30,
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: 24),
                    child: Image.asset(appAsset.iconDowloadAll),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 24),
                child: ContainerButton(
                  ontap: (){
                    appState.currentSong = widget.chart.rTChart!.songs![0];
                    appState.listSong = widget.chart.rTChart!.songs!.sublist(0);
                    appState.isShuffle = null;
                    appState.indexSong = 0;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => playMussicScreen(),));
                  }, 
                  height: 40, 
                  width: 40, 
                  radius: 20, 
                  child: Image.asset(appAsset.iconPlay)
                ),
              )
            ]
          ),
          StreamBuilder<Object>(
            stream: _controller.stream,
            builder: (context, snapshot) {
              return Container(
                  height: lengthZingCharts == 20 ? 1300 : 6100,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: lengthZingCharts * 60+40,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: lengthZingCharts,
                          itemBuilder: (context, index) {
                            return ContainerTopMussic(
                              position: index+1,
                              song: widget.chart.rTChart!.songs![index], 
                              ontap: () { 
                                appState.currentSong = widget.chart.rTChart!.songs![index];
                                appState.listSong = widget.chart.rTChart!.songs!.sublist(0);
                                appState.isShuffle = null;
                                appState.indexSong = index;
                                Navigator.push(context, MaterialPageRoute(builder: (context) => playMussicScreen(),));
                              },  
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24,),
                      GestureDetector(
                        onTap: (){
                          if(lengthZingCharts == 20){
                            lengthZingCharts = widget.chart.rTChart!.songs!.length;
                            _controller.sink.add(widget.chart.rTChart!.songs!.length);
                          }else{
                            lengthZingCharts = 20;
                            _controller.sink.add(20);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 30,
                          width: 120,
                          decoration: BoxDecoration(
                            color: appColor.darkGrey,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: StreamBuilder<int>(
                            stream: _controller.stream,
                            builder: (context, snapshot) {
                              return Text(lengthZingCharts == 20 ? "Xem Thêm" : "Thu nhỏ",
                                style: const TextStyle(color: appColor.LightGray, fontWeight: FontWeight.w500),
                              );
                            }
                          ),
                        ),
                      )
                    ],
                  ),
                );
            }
          ),
            const SizedBox(height: 20,),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: const Text('ZINGCHART Tuần ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20,),
            containerZingChartsWeek(
              itemWeekChart: widget.chart.weekChart!.vn!,
              ontap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ZingChartWeekScreen(weekChart: widget.chart.weekChart!, index: 0),));
              },
            ),
            containerZingChartsWeek(
              itemWeekChart: widget.chart.weekChart!.us!,
              ontap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ZingChartWeekScreen(weekChart: widget.chart.weekChart!, index: 1),));
              },
            ),
            containerZingChartsWeek(
              itemWeekChart: widget.chart.weekChart!.korea!,
              ontap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ZingChartWeekScreen(weekChart: widget.chart.weekChart!, index: 2),));
              },
            ),
          ]
        )
      )
    );
  }
}



