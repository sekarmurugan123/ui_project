import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ui_project/models/noteModel.dart';

class NoteService{
  final database=FirebaseFirestore.instance;
  CollectionReference<Map<String,dynamic>> get notes=>database.collection("notes");
  Stream<QuerySnapshot<Map<String,dynamic>>> getNotes(){
    return notes.snapshots();
}
Future<void> addNote(NoteModel note)async{
    await notes.add(note.toMap());
}
Future<void> updateNote(NoteModel note)async{
    await notes.doc(note.id).update(note.toMap());
}
Future<void> deleteNote(String id){
    return notes.doc(id).delete();
}
}