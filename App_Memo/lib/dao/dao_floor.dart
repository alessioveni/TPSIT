import 'package:app_memo/entità/memo.dart';
import 'package:floor/floor.dart';

@dao
abstract class MemoDAO {

  @insert
  Future<void> newMemo(Memo memo);

  @delete
  Future<void> deleteMemo(Memo memo);
  
  @Query('SELECT * from Memo')
  Stream<List<Memo>> getAllMemo();

  @update
  Future<void> updateMemo(Memo memo);

  @Query('SELECT * from Memo WHERE id=:id')
  Stream<Memo> getMemoById(int id);

  @Query('DELETE FROM Memo')
  Future<void> deleteAllMemo();
}
