import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

/// Browsers use SQLite compiled to WebAssembly, stored in IndexedDB.
void initDatabaseFactory() {
  databaseFactory = databaseFactoryFfiWebNoWebWorker;
}
