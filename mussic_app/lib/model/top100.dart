import 'package:mussic_app/model/playlist.dart';

class Top100 {
	String? sectionType;
	String? viewType;
	String? title;
	String? link;
	String? sectionId;
	List<PlayList>? playLists;

	Top100({this.sectionType, this.viewType, this.title, this.link, this.sectionId, this.playLists,});

	Top100.fromJson(Map<String, dynamic> json) {
		sectionType = json['sectionType'];
		viewType = json['viewType'];
		title = json['title'];
		link = json['link'];
		sectionId = json['sectionId'];
		if (json['items'] != null) {
			playLists = <PlayList>[];
			json['items'].forEach((v) { playLists!.add( PlayList.fromJson(v)); });
		}
	}
}