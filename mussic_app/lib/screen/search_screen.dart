import 'package:flutter/material.dart';
import 'package:mussic_app/component/app_assets.dart';
import 'package:mussic_app/component/app_color.dart';
import 'package:mussic_app/screen/result_search.screen.dart';
import 'package:mussic_app/widget/container_icon_arraw_back.dart';
import 'package:mussic_app/component/appDiaLog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mussic_app/component/appKey.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

    final TextEditingController _textController = TextEditingController();
    late final SharedPreferences _prefs;
    List<String> recentSearch = [];

  @override
  void initState() {
    getRecentSearch();
    super.initState();
    
  }

  Future<void> getRecentSearch() async {
    _prefs = await SharedPreferences.getInstance();
    if(_prefs.getStringList(appKey.recentSearch) != null){
      recentSearch = _prefs.getStringList(appKey.recentSearch)!.sublist(0);
    }
    setState(() {
      
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 48,),
            Container(
              margin: const  EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  containerBack(context,),
                  Expanded(
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      margin: const  EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: appColor.darkGrey,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                autofocus: true,
                                controller: _textController,
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                                decoration: const InputDecoration(
                                  hintText: 'Tìm kiếm bài hát, nghệ sĩ, playlist',
                                  hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 16
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            )
                          ),
                          GestureDetector(
                            onTap: () async{
                              if(_textController.text.isNotEmpty) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ResultSearchScreen(stringSearch: _textController.text),));
                                if(recentSearch.contains(_textController.text)){
                                  recentSearch.remove(_textController.text);
                                  recentSearch.insert(0, _textController.text);
                                }else{
                                  recentSearch.insert(0, _textController.text);
                                  if(recentSearch.length >= 10){
                                    recentSearch.removeLast();
                                  }
                                }
                                _prefs.setStringList(appKey.recentSearch, recentSearch);
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {});
                                });
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              child: Image.asset(appAsset.iconSeach, color: appColor.LightGray,),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      
            const SizedBox(height: 10,),
            
            Container(
              margin: const  EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Tìm Kiếm Gần đây",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: (){
      
                    }, 
                    child: GestureDetector(
                      onTap: () async {
                        if(await appDiaLog.showModalComfirm(context: context, tiltle: "Xóa lịch sử tìm kiếm", subTitle: "Bạn có chắc muốn xóa tất cả lịch sử tìm kiếm gần đây không ?", )){
                          recentSearch.clear();
                          _prefs.setStringList(appKey.recentSearch, recentSearch);
                          setState(() {
                            
                          });
                        }
                      },
                      child: const Text("Xóa Tất Cả",
                      style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                    )
                  )
                ],
              ),
            ),
           Container(
            height: recentSearch.length * 50,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: recentSearch.length > 10 ? 10 : recentSearch.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: (){
                    _textController.text = recentSearch[index];
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ResultSearchScreen(stringSearch: recentSearch[index]),));
                  },
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(appAsset.iconRecent),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(recentSearch[index],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          const Icon(Icons.navigate_next, color: Colors.white,),
                        ],
                      ),
                      const SizedBox(height: 20,)
                    ],
                  ),
                );
              },
            ),
           )
          ],
        ),
      ),
    );
  }
}