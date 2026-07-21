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
