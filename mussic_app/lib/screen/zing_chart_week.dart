import 'package:flutter/material.dart';
import 'package:mussic_app/model/charts.dart';
import 'package:mussic_app/screen/list_song_tab_screen.dart';
import 'package:mussic_app/widget/container_icon_arraw_back.dart';
import 'package:mussic_app/component/app_color.dart';

class ZingChartWeekScreen extends StatefulWidget {
  const ZingChartWeekScreen({super.key, required this.weekChart, required this.index});

  final WeekChart weekChart;
  final int index;

  @override
  State<ZingChartWeekScreen> createState() => _ZingChartWeekScreenState();
}

class _ZingChartWeekScreenState extends State<ZingChartWeekScreen> {

  late int indexTab;
 
  @override
  void initState() {
    // TODO: implement initState
    indexTab = widget.index;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: indexTab,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appColor.primaryColor,
          leading: containerBack(context),
          title: const Text("ZINGCHART TUẦN",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
          tabs: [
              Tab(
                child: Text("V-Pop",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Tab(
                child: Text("US_UK",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Tab(
                child: Text("K-Pop",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ]
          )
        ),
        body: TabBarView(
          children: [
            ListSongTabScreen(listSong: widget.weekChart.vn!.songs!,),
            ListSongTabScreen(listSong: widget.weekChart.us!.songs!,),
            ListSongTabScreen(listSong: widget.weekChart.korea!.songs!,),
          ]
        ),
      ),
    );
  }
}