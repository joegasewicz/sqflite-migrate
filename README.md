# SQFLITE Migrate

### Quick Start
Create a Migration by implementing `Version`
```dart
# version_1.dart
class Version1 extends Version {

  @override
  int version() {
    return 1;
  }

  @override
  List<String> upgrade() {
    return ["""
      CREATE TABLE days(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          created_at default current_timestamp
      );
      """];
  }

  @override
  List<String> downgrade(){
    return ['DROP TABLE days;'];
  }

}
```
### Create & Upgrade Migrations
On create
```dart
final migrate = Migrate(versions: versions, db: db, version: version);
migrate.create();
```

On upgrade

```dart
final migrate = Migrate(versions: versions, db: db, version: newVersion);
migrate.upgrade(newVersion);
```