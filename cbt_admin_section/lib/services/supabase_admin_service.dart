import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAdminService {
  // Use your Project URL and SERVICE_ROLE KEY here (NOT the anon key)
  final String _supabaseUrl = 'https://ggglwxifkkvoqmtddbxh.supabase.co';
  final String _serviceRoleKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdnZ2x3eGlma2t2b3FtdGRkYnhoIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MzQ1NDg5NCwiZXhwIjoyMDg5MDMwODk0fQ.RsTCZ5WZE22ieu7MaeVkekaZUWJd68TWRB-q5qePntE';

  late final SupabaseClient _adminClient;

  SupabaseAdminService() {
    // Initialize a separate client just for Admin operations
    _adminClient = SupabaseClient(_supabaseUrl, _serviceRoleKey);
  }

  Future<void> createTeacherAccount({
    required String name,
    required String email,
    required String password,
    required List<String> subjects,
  }) async {
    try {
      // 1. Create the user in Supabase Authentication
      final userResponse = await _adminClient.auth.admin.createUser(
        AdminUserAttributes(
          email: email,
          password: password,
          emailConfirm:
              true, // Auto-verify the email so they can log in immediately
        ),
      );

      final userId = userResponse.user!.id;

      // 2. Convert subjects list to a comma-separated string
      final subjectString = subjects.join(', ');

      // 3. Save the teacher's details into the 'teachers' database table
      await _adminClient.from('teachers').insert({
        'id': userId,
        'full_name': name,
        'email': email,
        'subject_assigned': subjectString,
      });

      print("Teacher created successfully in Auth and DB!");
    } catch (e) {
      throw Exception("Failed to create teacher: $e");
    }
  }
}
