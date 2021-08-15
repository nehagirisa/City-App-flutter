import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/single_child_widget.dart';

void main() async{
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.purple,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ref = FirebaseFirestore.instance.collection("City");

  TextEditingController namecontroller =TextEditingController();
  TextEditingController desccontroller =TextEditingController();
  TextEditingController imgcontroller =TextEditingController();

  // ScrollController controller = ScrollController();
  late Map<String, dynamic> addToCity;

  addData(){
  addToCity= {
   '   name': namecontroller.text,
      'desc': desccontroller.text,
      'image': imgcontroller.text,
  };
  ref.add(addToCity).whenComplete(() => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("City Info"),
      ),
        body:SingleChildScrollView(
          child: StreamBuilder(
          stream: ref.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot>snapshot)
           {
           if(snapshot.hasData){
             return ListView.builder(
               scrollDirection: Axis.vertical,
               shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
            itemBuilder: (context,index){
              return
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Column(
                        children: [
        
                          Image.network(snapshot.data!.docs[index]['image']),
                          Text(snapshot.data!.docs[index]['name'],style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                          SizedBox(height: 20,),
                          Text(snapshot.data!.docs[index]['desc']),
                          Row(
                            children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: (){
                              showDialog(context: context, builder: (context) => Dialog(
                               child: SingleChildScrollView(
                                  
                                  child: Container(
                                    height: 300,
                                    width: 400,
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        TextFormField(controller: namecontroller,
                                        decoration: InputDecoration(
                                          labelText: 'Name',
                                          hintText: 'Enter Name',
                                        ),
                                        style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                        ),
                                        TextFormField(
                                          controller: desccontroller,
                                          decoration: InputDecoration(
                                              labelText: 'Description',
                                              hintText: 'Enter Description'),
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextFormField(
                                          controller: imgcontroller,
                                          decoration: InputDecoration(
                                              labelText: 'Image',
                                              hintText: 'Insert Image'),
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Container(
                                          height: 40,
                                          width: 100,
                                          color: Colors.red,
                                          child: TextButton(
                                            onPressed: (){
                                             snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .reference
                                                                  .update({
                                                                'name':
                                                                    namecontroller
                                                                        .text,
                                                                'image':
                                                                    imgcontroller
                                                                        .text,
                                                                'desc':
                                                                    desccontroller
                                                                        .text,
                                                              });
                                            },
                                            child: Text('Update',
                                            style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black,
                                            ),),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                    
                                  
                                ),
                              ));
                            },),
                            InkWell(
                              onTap: (){
                                snapshot.data!.docs[index].reference.delete();
                              },
                              child: Icon(Icons.delete),
                            )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  );
            },
            
           
             );
            
           
             
           }    
             
            else{
              return CircularProgressIndicator();
            }
          }),
        ));
  
  
  }
}
            
              
              
              


