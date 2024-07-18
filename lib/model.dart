
import 'package:todo/db2.dart';

class TodoModel{

  String title;
  String desc;
  int id;
  String crateAt;
  bool isComp;

  TodoModel({required this.title,required this.desc, this.id=0 , required this.crateAt, this.isComp=false});

  factory TodoModel.fromMap (Map<String,dynamic> map){
    return TodoModel(
      id: map[DataPage.TABLE_KEY_ID],
      title: map[DataPage.TABLE_KEY_TITLE],
      desc: map[DataPage.TABLE_KEY_DESC],
      crateAt: map[DataPage.TABLE_KEY_Create],
      isComp: map[DataPage.TABLE_KEY_Comp]

    );
  }

  Map<String,dynamic> toMap(){
    return {
      DataPage.TABLE_KEY_TITLE:title,
      DataPage.TABLE_KEY_DESC:desc,
      DataPage.TABLE_KEY_Create:crateAt,
      DataPage.TABLE_KEY_Comp:isComp,

    };
  }


}
