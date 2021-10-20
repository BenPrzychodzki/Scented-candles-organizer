import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:wax_picker/models/waxModel.dart';

//Tworzymy klase ktora zapewni nam wszystkie potrzebne funkcjonalnosci bazy danych bez
//konieczności tworzenia jej od nowa w każdym kolejnym programie

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    //jesli plik z bazą danych istnieje,
    //zostanie wezwany za pomoca tej funkcji. Jesli nie istnieje, wezwana zostanie
    // funkcja initDB ktora go stworzy.

    if(_database != null)
      return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(
        join(await getDatabasesPath(), 'smells_v2.db'),
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE waxes (
              id INTEGER, propType TEXT, name TEXT, brand TEXT, description TEXT, power INTEGER, rating INTEGER, amount INTEGER
            )
          '''); //kod zapisany w SQlite który utworzył tabelę na dane.
        },
        version: 1
    );
  }

  newWax(WaxModel newWax) async {
    final db = await database;

    var res = await db.rawInsert('''
      INSERT INTO waxes (
        id, propType, name, brand, description, power, rating, amount
       ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ''', [newWax.id, newWax.propType, newWax.name, newWax.brand,
      newWax.description, newWax.power, newWax.rating, newWax.amount]); //wartosci z klasy username zostana wpisane w poszczegolne miejsca w tabeli

    return res;
  }

  Future<List<WaxModel>> getWaxes() async {
    final db = await database;
    var res = await db.query("waxes");
    List<WaxModel> list =
      res.isNotEmpty ? res.map((c) => WaxModel.fromJson(c)).toList() : [];
    //print(list);
    return list;
    }

  Future<int> countID() async {
    final db = await database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM waxes'));
  }

  deleteWax(String name, String propType) async {
    final db = await database;
    db.delete("waxes", where: "name = ? and propType = ?", whereArgs: [name, propType]);
  }

  deleteWaxes() async {
    final db = await database;
    db.rawDelete("Delete * from waxes");
  }

  updateWax(WaxModel newWax) async {
    final db = await database;
    var res = await db.update("waxes", newWax.toJson(),
        where: "name = ? and propType = ?", whereArgs: [newWax.name, newWax.propType]);
    return res;
  }
}
