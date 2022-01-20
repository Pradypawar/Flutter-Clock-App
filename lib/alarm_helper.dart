import 'package:clockapp/models/alarm_info.dart';
import 'package:sqflite/sqflite.dart';

final String tableAlarm = 'alarm';
final String columnId = 'id';
final String columnTitle = 'title';
final String columnDateTime = 'alarmDateTime';
final String columnPending = 'isPending';
final String columnColorIndex = 'gradientColorIndex';

class AlarmHelper {
  static Database? _database;
  static AlarmHelper? _alarmHelper;

  AlarmHelper._createInstance();
  // ignore: empty_constructor_bodies
  factory AlarmHelper() => _alarmHelper ??= AlarmHelper._createInstance();

  Future<Database> get database async =>
      _database ??= await intializeDatabase();

  Future<Database> intializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + "alarm.db";
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        
        create table $tableAlarm(
          $columnId integer primary key autoincrement,
          $columnTitle text not null,
          $columnDateTime text not null,
          $columnPending text,
          $columnColorIndex integer
        )
        
        
        ''');
      },
    );
    return database;
  }

  Future<List<AlarmInfo>> getAlarms() async {
    List<AlarmInfo> _alarms = [];
    var db = await database;
    var result = await db.query(tableAlarm);
    for (var element in result) {
      var alarmInfo = AlarmInfo.fromJson(element);
      _alarms.add(alarmInfo);
    }
    return _alarms;
  }

  void insertAlarm(AlarmInfo alarmInfo) async {
    var db = await database;
    await db.insert(tableAlarm, alarmInfo.toJson());
  }

  Future<int> delete(int id) async {
    var db = await database;
    return await db.delete(tableAlarm, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateAlarm(int id,AlarmInfo alarmInfo) async {
    var db = await database;
    
    return await db.update(tableAlarm, alarmInfo.toJson(),
        where: '$columnId = ?', whereArgs: [id]);
  }
}
