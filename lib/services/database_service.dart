import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../core/constants.dart';
import '../core/exceptions.dart';
import '../models/ticket.dart';

/// Local SQLite storage for tickets and user accounts.
///
/// A unique index on (section, row, seat) guarantees that the same seat
/// can never be sold twice, even if two requests race.
class DatabaseService {
  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();

  static const String _tickets = 'tickets';
  static const String _users = 'users';

  Future<Database>? _opening;

  /// Caching the Future makes sure the database is opened only once,
  /// even if two providers ask for it at the same time.
  Future<Database> get _db => _opening ??= _open();

  Future<Database> _open() async {
    final dir = await getDatabasesPath();
    final path = p.join(dir, AppConstants.databaseName);

    return openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await _createTicketsTable(db);
        await _createUsersTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) await _createUsersTable(db);
        // Version 3: the stadium layout changed to 13,500 seats in 12 blocks,
        // so tickets saved with the old seat ids are no longer valid.
        if (oldVersion < 3) await db.delete(_tickets);
      },
    );
  }

  Future<void> _createTicketsTable(Database db) async {
    await db.execute('''
      CREATE TABLE $_tickets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT NOT NULL,
        section_id TEXT NOT NULL,
        seat_row INTEGER NOT NULL,
        seat_number INTEGER NOT NULL,
        price INTEGER NOT NULL,
        holder_name TEXT NOT NULL,
        phone TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE UNIQUE INDEX idx_ticket_seat
      ON $_tickets (section_id, seat_row, seat_number)
    ''');
  }

  Future<void> _createUsersTable(Database db) async {
    await db.execute('''
      CREATE TABLE $_users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL UNIQUE,
        password_hash TEXT NOT NULL,
        salt TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
  }

  // ---------------------------------------------------------------- tickets

  /// Returns all tickets, newest first.
  Future<List<Ticket>> getTickets() async {
    final db = await _db;
    final rows = await db.query(_tickets, orderBy: 'created_at DESC, id DESC');
    return rows.map(Ticket.fromMap).toList();
  }

  /// Keys (see `Seat.key`) of every seat that is already sold.
  Future<Set<String>> getBookedSeatKeys() async {
    final tickets = await getTickets();
    return tickets.map((ticket) => ticket.seatKey).toSet();
  }

  /// Saves all [tickets] atomically.
  ///
  /// Throws [SeatAlreadyBookedException] if any seat is already taken; in
  /// that case nothing is saved.
  Future<void> insertTickets(List<Ticket> tickets) async {
    final db = await _db;
    try {
      await db.transaction((txn) async {
        for (final ticket in tickets) {
          await txn.insert(
            _tickets,
            ticket.toMap(),
            conflictAlgorithm: ConflictAlgorithm.abort,
          );
        }
      });
    } on DatabaseException catch (error) {
      if (error.isUniqueConstraintError()) {
        throw const SeatAlreadyBookedException();
      }
      rethrow;
    }
  }

  Future<void> deleteTicket(int id) async {
    final db = await _db;
    await db.delete(_tickets, where: 'id = ?', whereArgs: [id]);
  }

  // ------------------------------------------------------------------ users

  /// Creates an account and returns its id.
  ///
  /// Throws [PhoneAlreadyRegisteredException] if the phone is taken.
  Future<int> insertUser({
    required String name,
    required String phone,
    required String passwordHash,
    required String salt,
    required DateTime createdAt,
  }) async {
    final db = await _db;
    try {
      return await db.insert(
        _users,
        {
          'name': name,
          'phone': phone,
          'password_hash': passwordHash,
          'salt': salt,
          'created_at': createdAt.millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } on DatabaseException catch (error) {
      if (error.isUniqueConstraintError()) {
        throw const PhoneAlreadyRegisteredException();
      }
      rethrow;
    }
  }

  Future<Map<String, Object?>?> findUserByPhone(String phone) async {
    final db = await _db;
    final rows = await db.query(
      _users,
      where: 'phone = ?',
      whereArgs: [phone],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first;
  }

  Future<Map<String, Object?>?> findUserById(int id) async {
    final db = await _db;
    final rows = await db.query(
      _users,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first;
  }

  Future<void> close() async {
    final opening = _opening;
    _opening = null;
    if (opening != null) await (await opening).close();
  }
}
