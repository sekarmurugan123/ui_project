import 'package:ui_project/models/noteModel.dart';
import 'package:ui_project/services/notes_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoteRepo{
  final NoteService _noteService;
  NoteRepo({required NoteService noteservice }):_noteService=noteservice;
 Stream<List<NoteModel>>? getNotes(String userId){
 return _noteService.getNotes().map((snapshot)=>snapshot.docs.where((doc){
   print("userIddd:$userId");
   return doc['userId']==userId;
 }).map((doc)=>NoteModel.fromMap(doc.data() as Map<String,dynamic>,id: doc.id)).toList());
 }
 Future<void> addNote({required String title,required String content,required DateTime lastModifiedAt,required DateTime createdAt,required bool isPinned,required String userId}){
   return _noteService.addNote(
     NoteModel(id: "",
         title: title,
         content: content,
         lastModifiedAt: Timestamp.fromDate(lastModifiedAt),
         createdAt: Timestamp.fromDate(createdAt),
         isPinned: isPinned,
     userId: userId),

   );
 }
 Future<void> deleteNote(String id){
   return _noteService.deleteNote(id);
 }
 Future<void> updateNote(NoteModel notemodel,{String? title,String? content,Timestamp? createdAt,bool? isPinned}){
  return _noteService.updateNote(notemodel.copywith(
 title:title,
 content:content,
 createdAt:Timestamp.now(),
 isPinned:isPinned
  ));
 }
  // Stream<List<NoteModel>>? getnotes(){
  //  return _noteService.getNotes().map((snapshot)=>snapshot.docs.map((doc){
  //    Map<String,dynamic> data=doc.data();
  //    data["id"]=doc.id;
  //    return NoteModel.fromMap(data);
  //  }).toList());
  // }
}