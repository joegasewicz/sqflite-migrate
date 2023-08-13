import 'package:logging/logging.dart';
import 'package:sqflite/sqflite.dart';

final log = Logger('Migrate');

abstract class Version {

  int version();

  List<String> upgrade();

  List<String> downgrade();

}

class Migrate {

  final Database db;
  final int version;
  final List<Version> versions;

  Migrate({required this.versions, required this.db, required this.version});

  void upgrade(int upgradeVersion) async {
    for (final v in versions) {
      if (v.version() == upgradeVersion) {
        for (final query in v.upgrade()) {
          try {
            await db.execute(query);
            logQuerySuccess(query);
          } on DatabaseException catch (e) {
            print(e.result);
          }
        }
      }
    }
  }

  Future<void> create() async {
    for (final query in versions[0].upgrade()) {
      try {
        await db.execute(query);
        logQuerySuccess(query);
      } on DatabaseException catch (e) {
        log.shout(e.result);
      }
    }
    log.info('database upgraded to version ${versions[0].version()}');
  }

  void logQuerySuccess(String query) {
    print('Migration successful for : \n\t$query');
  }
}