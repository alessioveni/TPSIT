import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:app_memo/entità/memo.dart';
import 'package:app_memo/dao/dao_floor.dart';
part 'database.g.dart';

@Database(version: 1, entities: [Memo]) //file dal quale si creerà il database (importanti)
abstract class AppDatabase extends FloorDatabase {
  MemoDAO get memoDAO;
}
