
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mussic_app/component/appState.dart';
import 'package:mussic_app/model/artist.dart';
import 'package:mussic_app/model/mv.dart';
import 'package:mussic_app/model/playlist.dart';
import 'package:mussic_app/model/song.dart';
import 'package:mussic_app/model/userProfile.dart';

class FirebaseRepo{

  
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static const String collectionUser = "user_profile";
  
  static Future<void> createUser({required String numberPhone, required String name, required String avatar, required String token, required String userID})async {
    
    UserProfile user = UserProfile(
      userID: userID,
      name: name,
      numberPhone: numberPhone,
      avatar: avatar,
      token: token,
      followArtists: [],
      likePlaylists: [],
      likeSongs: [],
      likeVideo: [],
      recentPlaylists: [],
      recentVideo: [],
      resendSongs: []
    );
    
    try {
      await firestore.collection(collectionUser).doc(numberPhone).set(user.toJson());
    } catch (e) {
      
    }
  }

  static Future<void> getCurrentUserProfile() async {
    try {
      final data = await firestore.collection(collectionUser).doc(appState.user!.phoneNumber).get();
      if(data.exists){
        appState.userProfile = UserProfile.formJson(data.data()!);
      }
    } catch (e) {
    }
  }

  static Future<String> putFileAvatar({required File file}) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child('user_avatar/${appState.user!.phoneNumber}.$ext');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  static Future<void> upDateUserProfile({String? name, String? avatar})async {
    if(name != null){
      appState.userProfile!.name = name;
      await firestore.collection(collectionUser).doc(appState.user!.phoneNumber).update({'name': name});
    }
    if(avatar != null){
      appState.userProfile!.avatar = avatar;
      await firestore.collection(collectionUser).doc(appState.user!.phoneNumber).update({'avatar': avatar});
    }
  }

  // Like song..........................................................................................  
  static Future<bool> isLikeSong({required String encodeId}) async {
    return (await firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("likeSongs").doc(encodeId).get()).exists;
  }

  static Future<void> likeSongs({required Song song}) async {
    await firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("likeSongs").doc(song.encodeId!).set(song.toJson());
  }

  static Future<void> deleteLikeSongs({required Song song}) async {
    await firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("likeSongs").doc(song.encodeId!).delete();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllLikeSong(){
    return firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("likeSongs").orderBy("timestamp", descending: true).snapshots();
  }

  // Like PlayList..........................................................................................
  static Future<bool> isLikePlayList({required String encodeId}) async {
    return (await firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("likePlaylists").doc(encodeId).get()).exists;
  }

  static Future<void> deleteLikePlayList({required PlayList playList}) async {
    await firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("likePlaylists").doc(playList.encodeId!).delete();
  }

  static Future<void> likePlayList({required PlayList playList}) async {
    await firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("likePlaylists").doc(playList.encodeId!).set(playList.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllLikePlayList(){
    return firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("likePlaylists").orderBy("timestamp", descending: true).snapshots();
  }

  // like video ............................................................................................

  static Future<bool> isLikeVideo({required String encodeId}) async {
    return (await firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("likeVideo").doc(encodeId).get()).exists;
  }

  static Future<void> deleteLikeVideo({required String  encodeId}) async {
    await firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("likeVideo").doc(encodeId).delete();
  }

  static Future<void> likeVideo({required MV mv}) async {
    await firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("likeVideo").doc(mv.encodeId!).set(mv.toJsonFirebase());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllLikeVideo(){
    return firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("likeVideo").orderBy("timestamp", descending: true).snapshots();
  }

  // follow artist ..........................................................................................

  static Future<bool> isFollowArtist({required String encodeId}) async {
    return (await firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("followArtists").doc(encodeId).get()).exists;
  }

  static Future<void> deleteFollowArtist({required Artist artist}) async {
    await firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("followArtists").doc(artist.id!).delete();
  }

  static Future<void> FollowArtist({required Artist artist}) async {
    await firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("followArtists").doc(artist.id!).set(artist.toJsonFirebase());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllFollowArtist(){
    return firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("followArtists").orderBy("timestamp", descending: true).snapshots();
  }

  // recent .....................................................................................................

  static Future<bool> isRecentSong({required Song song}) async {
    return (await firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("resendSongs").doc(song.encodeId).get()).exists;
  }

  static Future<void> addRecentSong({required Song song}) async {
    await firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("resendSongs").doc(song.encodeId).set(song.toJson());
  }

  static Future<void> deleteRecentSong({required String encodeId}) async {
    await firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("resendSongs").doc(encodeId).delete();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllRecentSong(){
    return firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("resendSongs").orderBy("timestamp", descending: true).snapshots();
  }

  //recent playlist.......................................................................................................
  static Future<bool> isRecentPlayList({required PlayList playList}) async {
    return (await firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("recentPlaylists").doc(playList.encodeId).get()).exists;
  }

  static Future<void> addRecentPlayList({required PlayList playList}) async {
    await firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("recentPlaylists").doc(playList.encodeId).set(playList.toJson());
  }

  static Future<void> deleteRecentPlayList({required String encodeId}) async {
    await firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("recentPlaylists").doc(encodeId).delete();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllPlayListRecent(){
    return firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("recentPlaylists").orderBy("timestamp", descending: true).snapshots();
  }

  //recent artist.......................................................................................................  

  static Future<bool> isRecentArtist({required Artist artist}) async {
    return (await firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("recentArtists").doc(artist.id).get()).exists;
  }

  static Future<void> addRecentArtist({required Artist artist}) async {
    await firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("recentArtists").doc(artist.id).set(artist.toJsonFirebase());
  }

  static Future<void> deleteRecentArtist({required String id}) async {
    await firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("recentArtists").doc(id).delete();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllArtistRecent(){
    return firestore.collection(collectionUser).doc(appState.user!.phoneNumber).collection("recentArtists").orderBy("timestamp", descending: true).snapshots();
  }
}