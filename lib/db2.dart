import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/model.dart';

class DataPage {

  DataPage._();

  static const String TABLE_KEY_TODO='todo';
  static const String TABLE_KEY_ID='todo_id';
  static const String TABLE_KEY_TITLE='title';
  static const String TABLE_KEY_DESC='desc';
  static const String TABLE_KEY_Create='createAt';
  static const String TABLE_KEY_Comp='isCom';

  static final DataPage db1 = DataPage._();

  Database? myDb2;

  Future<Database> getDb() async {
    if (myDb2!= null) {
      return myDb2!;
    } else {
      myDb2 = await initDb();
      return myDb2!;
    }
  }

  Future<Database> initDb() async {
    var root = await getApplicationDocumentsDirectory();
    var mainRoot = join(root.path, "todoDb.db");

    return await openDatabase(
        mainRoot, version: 1, onCreate: (db, version)  {
      db.execute(
          'create table $TABLE_KEY_TODO ( $TABLE_KEY_ID integer primary key autoincrement, $TABLE_KEY_TITLE text, $TABLE_KEY_DESC text,$TABLE_KEY_Create text,$TABLE_KEY_Comp integer)');
    });
  }

  void addTodo({required TodoModel newTodo }) async {
    var db = await getDb();
    db.insert(TABLE_KEY_TODO ,newTodo.toMap() );
  }

  Future<List<TodoModel>> fecTodo() async {
    var db = await getDb();
    var data = await db.query(TABLE_KEY_TODO);
    List<TodoModel> mData=[];
    for(Map<String,dynamic> eachData in data){
      var eachModel=TodoModel.fromMap(eachData);
      mData.add(eachModel);
    }
    return mData;
  }

   updateTodo( updateTodo)async{
    var db=await getDb();
    await db.update('$TABLE_KEY_TODO', updateTodo.toMap(),where: '$TABLE_KEY_ID = ? ',whereArgs: ['${updateTodo.id}']);

  }

    deleteTodo(int id)async{
    var db=await getDb();
    await db.delete('$TABLE_KEY_TODO',where:'$TABLE_KEY_ID = ? ',whereArgs: ['$id'] );

  }


}
