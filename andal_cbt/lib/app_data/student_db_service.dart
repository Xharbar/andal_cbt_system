import 'package:postgres/postgres.dart';

class StudentDbService {
  static final StudentDbService _instance = StudentDbService._internal();
  factory StudentDbService() => _instance;
  StudentDbService._internal();

  Connection? _connection;

  // 1. CONNECT TO THE ADMIN PC
  Future<Connection> get connection async {
    if (_connection != null && _connection!.isOpen) {
      return _connection!;
    }

    _connection = await Connection.open(
      Endpoint(
        host: '192.168.250.26',
        port: 5432,
        database: 'cbt_admin_db',
        username: 'postgres', // Your Postgres username
        password: 'admin', // Your Postgres password
      ),
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );
    return _connection!;
  }

  // 2. STUDENT LOGIN METHOD
  // Checks if the Reg Number and Passcode match the database
  Future<Map<String, dynamic>?> loginStudent(
    String regNumber,
    String passcode,
  ) async {
    final conn = await connection;

    final result = await conn.execute(
      Sql.named('''
        SELECT id, full_name, class_name 
        FROM students 
        WHERE reg_number = @regNum 
        AND current_passcode = @code 
      '''),
      // AND is_active = true
      parameters: {'regNum': regNumber, 'code': passcode},
    );

    // If a row is returned, the login is successful
    if (result.isNotEmpty) {
      final row = result.first;
      return {
        'id': row[0] as String,
        'fullName': row[1] as String,
        'className': row[2] as String,
      };
    }

    // Login failed
    return null;
  }

  // 3. SUBMIT SCORE METHOD
  // Used at the end of the exam to save the student's score
  Future<void> submitScore(
    String regNumber,
    String subject,
    int score,
    int total,
  ) async {
    final conn = await connection;
    await conn.execute(
      Sql.named('''
        INSERT INTO scores (id, student_reg_number, subject, score, total)
        VALUES (@id, @regNum, @subject, @score, @total)
      '''),
      parameters: {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'regNum': regNumber,
        'subject': subject,
        'score': score,
        'total': total,
      },
    );
  }
}
