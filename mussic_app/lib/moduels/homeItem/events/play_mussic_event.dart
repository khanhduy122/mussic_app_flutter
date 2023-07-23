
abstract class playMussicEvent {}

class getInfoSong extends playMussicEvent {
  final String encodeId;
  getInfoSong({required this.encodeId});
}

class getInfoPlayListEvent extends playMussicEvent {
  final String encodeId;

  getInfoPlayListEvent({required this.encodeId});
}

class getInfoVideoEvent extends playMussicEvent{
  String encodeId;

  getInfoVideoEvent({required this.encodeId});
}

class getInfoArtistEvent extends playMussicEvent{
  String name;

  getInfoArtistEvent({required this.name});
}