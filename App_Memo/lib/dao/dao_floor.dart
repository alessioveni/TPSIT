import 'package:app_memo/entità/memo.dart';
import 'package:floor/floor.dart';

@dao
abstract class MemoDAO {  //definisce tutti i metodi applicabili all'entità memo (importante)
  @Query('SELECT * from Memo')
  Stream<List<Memo>> getAllMemo();

  @Query('SELECT * from Memo WHERE id=:id')
  Stream<Memo> getMemoById(int id);

  @Query('DELETE FROM Memo')
  Future<void> deleteAllMemo();

  @insert
  Future<void> newMemo(Memo memo);

  @update
  Future<void> updateMemo(Memo memo);

  @delete
  Future<void> deleteMemo(Memo memo);
}
