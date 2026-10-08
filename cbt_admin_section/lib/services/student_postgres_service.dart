import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:cbt_admin_section/screens/student_mgt.dart';

class PostgresService {
  // Singleton pattern
  static final PostgresService _instance = PostgresService._internal();
  factory PostgresService() => _instance;
  PostgresService._internal();

  Connection? _connection;

  // 1. INITIALIZE CONNECTION
  Future<Connection> get connection async {
    if (_connection != null && _connection!.isOpen) {
      return _connection!;
    }

    _connection = await Connection.open(
      Endpoint(
        host:
            'localhost', // Use 'localhost' if DB is on Admin PC, or an IP address (e.g., '192.168.1.5')
        port: 5432,
        database: 'cbt_admin_db',
        username: 'postgres', // Your Postgres username
        password: 'admin', // Your Postgres password
      ),
      settings: const ConnectionSettings(
        sslMode: SslMode.disable, // Disable SSL for local networks
      ),
    );
    return _connection!;
  }

  // --- CREATE DATABASE ---
  /*Future<void> createDatabase() async {
    final conn = await connection;
    await conn.execute(
      Sql.named('''
        CREATE TABLE students (
          id VARCHAR(255) PRIMARY KEY,
          full_name VARCHAR(255) NOT NULL,
          reg_number VARCHAR(100) UNIQUE NOT NULL,
          class_name VARCHAR(50),
          current_passcode VARCHAR(10),
          is_active BOOLEAN DEFAULT TRUE
        );
    '''),
    );
  }*/
  Future<void> createDatabaseAndTables(BuildContext context) async {
    // Replace these with your actual server IP and postgres password
    const String dbHost = 'localhost'; // or '192.168.1.15'
    const String dbUser = 'postgres';
    const String dbPassword = 'admin';
    const String dbName = 'cbt_admin_db';

    try {
      // ---------------------------------------------------------
      // 1. CONNECT TO DEFAULT 'postgres' DATABASE
      // ---------------------------------------------------------
      final defaultConn = await Connection.open(
        Endpoint(
          host: dbHost,
          port: 5432,
          database: 'postgres',
          username: dbUser,
          password: dbPassword,
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );

      // 2. CHECK IF CBT DATABASE EXISTS
      final checkResult = await defaultConn.execute(
        "SELECT 1 FROM pg_database WHERE datname = '$dbName'",
      );

      // 3. CREATE DATABASE IF IT DOESN'T EXIST
      if (checkResult.isEmpty) {
        await defaultConn.execute("CREATE DATABASE $dbName;");
        print("Database '$dbName' created successfully.");
      } else {
        print("Database '$dbName' already exists.");
      }

      // Close the default connection
      await defaultConn.close();

      // ---------------------------------------------------------
      // 4. CONNECT TO THE NEW 'cbt_admin_db'
      // ---------------------------------------------------------
      final cbtConn = await Connection.open(
        Endpoint(
          host: dbHost,
          port: 5432,
          database: dbName, // Connect to the new DB
          username: dbUser,
          password: dbPassword,
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );

      // 5. CREATE TABLES (Using IF NOT EXISTS so it doesn't crash if run twice)
      await cbtConn.execute('''
        CREATE TABLE IF NOT EXISTS students (
            id VARCHAR(255) PRIMARY KEY,
            full_name VARCHAR(255) NOT NULL,
            reg_number VARCHAR(100) UNIQUE NOT NULL,
            class_name VARCHAR(50),
            current_passcode VARCHAR(10),
            is_active BOOLEAN DEFAULT TRUE
        );
      ''');

      await cbtConn.execute('''
        CREATE TABLE IF NOT EXISTS scores (
            id VARCHAR(255) PRIMARY KEY,
            student_reg_number VARCHAR(100) REFERENCES students(reg_number),
            subject VARCHAR(100),
            score INTEGER,
            total INTEGER,
            date_taken TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      ''');

      await cbtConn.close();

      // Optional: Show Success UI
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Database and Tables successfully created!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Close the dialog
      }
    } catch (e) {
      // Handle Errors (e.g. wrong password, server off)
      print("Database Setup Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Setup Failed: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // --- CRUD OPERATIONS FOR STUDENTS ---

  // 1. CREATE STUDENT
  Future<void> insertStudent(Student student) async {
    final conn = await connection;
    await conn.execute(
      Sql.named('''
        INSERT INTO students (id, full_name, reg_number, class_name, current_passcode, is_active)
        VALUES (@id, @fullName, @regNumber, @className, @currentPasscode, @isActive)
        ON CONFLICT (id) DO UPDATE 
        SET full_name = @fullName, reg_number = @regNumber, class_name = @className, 
            current_passcode = @currentPasscode, is_active = @isActive
      '''),
      parameters: {
        'id': student.id,
        'fullName': student.fullName,
        'regNumber': student.regNumber,
        'className': student.stdClass,
        'currentPasscode': student.currentPasscode,
        'isActive': student.isActive,
      },
    );
  }

  // 2. READ ALL STUDENTS
  Future<List<Student>> getStudents() async {
    final conn = await connection;
    final result = await conn.execute(
      'SELECT * FROM students ORDER BY full_name ASC',
    );

    List<Student> students = [];
    for (final row in result) {
      students.add(
        Student(
          row[0] as String, // id
          row[1] as String, // full_name
          row[2] as String, // reg_number
          row[3] as String, // class_name
          row[4] as String, // current_passcode
          row[5] as bool, // is_active
        ),
      );
    }
    return students;
  }

  // 3. DELETE STUDENT
  Future<void> deleteStudent(String id) async {
    final conn = await connection;
    await conn.execute(
      Sql.named('DELETE FROM students WHERE id = @id'),
      parameters: {'id': id},
    );
  }

  // 4. UPDATE STUDENT PASSCODE
  Future<void> updateStudentPasscode(
    String regNumber,
    String newPasscode,
  ) async {
    final conn = await connection;
    await conn.execute(
      Sql.named('''
        UPDATE students 
        SET current_passcode = @passcode
        WHERE reg_number = @regNumber
      '''),
      parameters: {'passcode': newPasscode, 'regNumber': regNumber},
    );
  }
}
