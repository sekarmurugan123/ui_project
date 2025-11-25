
import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel{
  final String id;
  final String title;
  final String content;
  final Timestamp lastModifiedAt;
  final Timestamp createdAt;
  final bool isPinned;
  final String? userId;
  NoteModel({required this.id,
    required this.title,
    required this.content,
    required this.lastModifiedAt,
    required this.createdAt,
    required this.isPinned,
     this.userId=""});
  Map<String,dynamic> toMap(){
   return {
     'id':id,
     'title':title,
     'content':content,
     'lastModifiedAt':lastModifiedAt,
     'createdAt':createdAt,
     'isPinned':isPinned,
     'userId':userId
   };
  }
static NoteModel fromMap(Map<String,dynamic> map,{ String? id}){
    return NoteModel(id: map['id'],
        title: map['title'],
        content: map['content'],
        lastModifiedAt: (map['lastModifiedAt'] ),
        createdAt: (map['createdAt'] ),
        isPinned:map['isPinned'],
        userId:map['userId']);
}
 NoteModel copywith({
   String? id,
   String? title,
   String? content,
   Timestamp? createdAt,
   Timestamp? lastModifiedAt,
   bool? isPinned,
   String? userId
}){
    return NoteModel(id: id??this.id,
        title: title??this.title,
        content: content??this.content,
        lastModifiedAt: lastModifiedAt??this.lastModifiedAt,
        createdAt: createdAt??this.createdAt,
        isPinned: isPinned??this.isPinned,
      userId: userId??this.userId
    );
 }


@override
 String toString(){
    return "NoteModel id: $id, title: $title, content: $content, lastModifiedAt: $lastModifiedAt, createdAt: $createdAt, isPinned: $isPinned, userId: $userId";
}

}