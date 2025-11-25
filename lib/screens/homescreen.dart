import 'package:flutter/material.dart';
import 'package:ui_project/models/noteModel.dart';
import 'package:ui_project/models/user_model.dart';
import 'package:ui_project/repository/auth_repo.dart';
import 'package:ui_project/repository/notes_repo.dart';
import 'package:ui_project/services/auth_service.dart';
import 'package:ui_project/services/notes_service.dart';
class Homescreen extends StatefulWidget {
  final UserModel userData;
  const Homescreen({super.key,required this.userData});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final _noteRepo=NoteRepo(noteservice: NoteService());
  final AuthRepo _authRepo=AuthRepo();
  final Set<String> idsToDelete={};
  Map<String,bool> selectedDeleteIds={};
  late UserModel userData=widget.userData;
  @override
  void initState(){
    super.initState();
    // userData=widget.userData;
  }

  void noteDialog(BuildContext context,{String type="Add",NoteModel? notemodel}){
    final titleController=TextEditingController();
    final contentController=TextEditingController();
    titleController.text=notemodel?.title??"";
    contentController.text=notemodel?.content??"";
    bool isPinned=notemodel?.isPinned??false;

    showDialog(context: context, builder: (context){
      return StatefulBuilder(builder: (context,setState){
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.yellow.shade100,
            child: Padding(padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type=="Add"? "Add Note": "Edit Note",style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold ),
                  ),
                  const SizedBox(height: 20,),
                  TextField(
                   controller: titleController,
                   decoration: InputDecoration(
                     labelText: "title",
                     filled: true,
                     fillColor: Colors.white,
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(13),
                       borderSide: BorderSide(color: Colors.yellowAccent)
                     ),
                     enabledBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(13),
                       borderSide: BorderSide(color: Colors.yellowAccent,
                       width: 2)
                     )

                   ),
                  ),
                  const SizedBox(height: 12,),
                  TextField(
                    controller: contentController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Content',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.yellow.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.yellow.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.yellow.shade600,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Pin this note',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:FontWeight.w500,
                        ),
                      ),Switch(value: isPinned,activeColor: Colors.yellow.shade200, onChanged:(value){
                        setState((){
                          isPinned=value;
                        });
                      } )
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                      }, child: const Text("Cancel",style: TextStyle(color: Colors.grey),)),
                      const SizedBox(width:10),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12) ,
                            elevation: 3
                          ),
                          onPressed:()async{
                            final title=titleController.text.trim();
                            final content=contentController.text.trim();
                            if(title.isEmpty || content.isEmpty) return;
                            if(type=="Add"){
                              await _noteRepo.addNote(
                                  title: title,
                                  content: content,
                                  lastModifiedAt: DateTime.now(),
                                  createdAt: DateTime.now(),
                                  isPinned: isPinned,
                                  userId:widget.userData.uid );
                              print("title:$title");
                            }else if(notemodel!=null){
                              await _noteRepo.updateNote(notemodel,title: title,content: content,isPinned:isPinned);
                            }
                            Navigator.pop(context);
                      },
                          child:Text(type=='Add'? 'Add':"Update",style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w600, ),)
                      ),
                    ],
                  )

                ],
              ),
            ),

        );
      });
    });
  }

  void addOrDeleteId(bool? checked, String id) {
    if (checked == true) {
      idsToDelete.add(id);
    } else {
      idsToDelete.remove(id);
    }
    setState(() => selectedDeleteIds[id] = checked ?? false);
  }
   void onDeleteId()async{
    for (var id in idsToDelete){
     await _noteRepo.deleteNote(id);
    }
    setState(() {
      idsToDelete.clear();
    });
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade100,
   appBar: AppBar(
     title: const Text("Notes",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
     actions: [
       Visibility(
           visible: idsToDelete.isNotEmpty,
           child:IconButton(onPressed:
             onDeleteId,
            icon:Icon(Icons.delete)) )
     ],
   ),
   body: StreamBuilder<List<NoteModel>>(stream: _noteRepo.getNotes(widget.userData.uid), builder:(context,snapshot){
     if(snapshot.connectionState == ConnectionState.waiting){
       return const Center(child: CircularProgressIndicator(),);
     }
     if(snapshot.hasError){
       return Center(child: Text("Error: ${snapshot.error}"),);
     }
     if(!snapshot.hasData || snapshot.data!.isEmpty){
       return const Center(
         child: Text("No notes yet",style:TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
       );
     }
     final notes=snapshot.data!;
     for(var note in notes){
       selectedDeleteIds[note.id]=selectedDeleteIds[note.id]??false;
     }
     notes.sort((a,b){
       if(!a.isPinned && b.isPinned){
         return 1;
       }
       if(a.isPinned && !b.isPinned){
         return -1;
       }
       return 0;
     });
     return ListView.builder(itemCount:notes.length,
         itemBuilder: (context,index){
          final note=notes[index];
          return Card(
            key: ValueKey(note.id),
            margin: const EdgeInsets.symmetric(vertical: 10),
            elevation: 4,
            shadowColor: Colors.yellowAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
            ),
            child: ListTile(
              onLongPress: ()=>noteDialog(context,type: "Edit",notemodel: note),
              title: Text(note.title,style: const TextStyle(fontWeight:FontWeight.w600 ,fontSize: 16),),
              subtitle: Text(note.content,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey),),
               leading: Checkbox(value: selectedDeleteIds[note.id], onChanged: (checked){
                addOrDeleteId(checked, note.id);
               }),
              trailing: note.isPinned
                ? Icon(Icons.push_pin,color: Colors.yellow.shade200)
                :null
            ),
          );
         });
   }),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.yellow.shade700,
          elevation: 6,
          child: const Icon(Icons.add,color: Colors.white,),
          onPressed: (){
        noteDialog(context);
      }),
    );
  }
}
