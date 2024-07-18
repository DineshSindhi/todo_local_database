import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/model.dart';

import 'db2.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  var titController=TextEditingController();
  var decController=TextEditingController();
  var dtFor=DateFormat.Hm();
  List<TodoModel> mData=[];
  DataPage? db2;
  @override
  void initState() {
    super.initState();
    db2=DataPage.db1;
    getNotes();
  }

  void getNotes()async{
    mData= await db2!.fecTodo();
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DataBase Project'),
        backgroundColor: Colors.blue,
      ),
      body: mData.isNotEmpty?ListView.builder(
        itemCount: mData.length,
        itemBuilder: (context, index) =>
            ListTile(
              onTap: (){
                titController.text=mData[index].title;
                decController.text=mData[index].desc;
                showModalBottomSheet(context: context, builder:  (context) => mySheet(isUpdate: true,upIndex: mData[index].id,createAtu: mData[index].crateAt));
              },
              /*leading: Text(mData[index].id.toString()),*/
              leading: Checkbox(
                value: mData[index].isComp,
                onChanged: (value){
                  mData[index].isComp=value!;
                  setState(() {

                  });
                },
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(mData[index].title,style: TextStyle(fontSize: 20),),
                  Text(dtFor.format(DateTime.fromMillisecondsSinceEpoch(int.parse(mData[index].crateAt))))
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(mData[index].desc,style: TextStyle(fontSize: 20)),
                  InkWell(
                    onTap: (){
                      db2!.deleteTodo(mData[index].id);
                      getNotes();
                    },
                      child: Icon(Icons.delete)),
                ],
              ),


            ),):
      Container(child: Center(
        child: Text('No Notes Yet...'),
      ),),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          titController.clear();
          decController.clear();
          showModalBottomSheet(context: context, builder: (context) => mySheet(),);

        },child: Icon(Icons.add),
      ),
    );
  }

  Widget mySheet({
    bool isUpdate = false,
    int upIndex=-1,
    createAtu=''
  }){
    return Container(
        height: 700,
        decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
        ),
        child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(children: [
              Text(isUpdate? 'Update Note' :'Note',style: TextStyle(fontSize: 30),),
              TextField(controller: titController,
                decoration: InputDecoration(
                    label: Text('Enter Title'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                ),),
              SizedBox(height: 10,),
              TextField(controller: decController,
                decoration: InputDecoration(
                    label: Text('Enter Subtitle'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )
                ),),
              SizedBox(height: 10,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: (){
                    if(isUpdate){
                      db2!.updateTodo(TodoModel(title: titController.text, desc: decController.text,id: upIndex
                      ,crateAt:createAtu ))  ;
                      getNotes();
                    }else {
                      db2!.addTodo(newTodo: TodoModel(title: titController.text,
                          desc: decController.text,crateAt: DateTime.now().millisecondsSinceEpoch.toString()
                      ));
                      getNotes();
                    }
                    Navigator.pop(context);
                  }, child: Text(isUpdate? 'Update Note':'Add Note',style: TextStyle(fontSize: 25),)),
                  ElevatedButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Text('Cancel',style: TextStyle(fontSize: 25),)),
                ],
              ),
            ])));

  }
}