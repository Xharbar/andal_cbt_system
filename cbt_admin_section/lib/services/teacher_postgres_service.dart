import 'package:postgres/postgres.dart';
import 'package:flutter/material.dart';
import 'package:cbt_admin_section/screens/teacher_mgt.dart';

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

  // --- CRUD OPERATIONS FOR STUDENTS ---

  // 1. CREATE TEACHER
  Future<void> insertTeacher(BuildContext context, Teacher teacher) async {
    final conn = await connection;
    try {
      await conn.execute(
        Sql.named('''
        INSERT INTO teachers (id, full_name, email, subject_assigned, password)
        VALUES (@id, @fullName, @email, @subjectAssigned, @password)
        ON CONFLICT (id) DO UPDATE 
        SET full_name = @fullName, email = @email, subject_assigned = @subjectAssigned, password = @password
      '''),
        parameters: {
          'id': teacher.id,
          'fullName': teacher.fullName,
          'email': teacher.email,
          'subjectAssigned': teacher.subjectAssigned,
          'password': teacher.password,
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          constraints: BoxConstraints(maxHeight: 600, maxWidth: 350),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'lib/assets/images/error_2.png',
                // width: 100,
                // height: 100,
              ),
              Text(
                'An error occurred',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('Error details: $e', textAlign: TextAlign.center),
              SizedBox(height: 20.0),
              SizedBox(
                height: 50.0,
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  // 2. READ ALL TEACHERS
  Future<List<Teacher>> getTeachers() async {
    final conn = await connection;
    final result = await conn.execute(
      'SELECT * FROM teachers ORDER BY full_name ASC',
    );

    List<Teacher> teachers = [];
    for (final row in result) {
      teachers.add(
        Teacher(
          row[0] as String, // id
          row[1] as String, // full_name
          row[2] as String, // email
          row[3] as String, // subject assigned
          row[4] as String, // password
        ),
      );
    }
    return teachers;
  }

  // 3. DELETE TEACHER
  Future<void> deleteTeacher(String email) async {
    final conn = await connection;
    await conn.execute(
      Sql.named('DELETE FROM teachers WHERE email = @email'),
      parameters: {'email': email},
    );
  }

  // 4. UPDATE TEACHER PASSCODE
  Future<void> updateTeacherPasscode(String email, String newPassword) async {
    final conn = await connection;
    await conn.execute(
      Sql.named('''
        UPDATE teachers 
        SET password = @newPassword
        WHERE email = @email
      '''),
      parameters: {'password': newPassword, 'email': email},
    );
  }
}
