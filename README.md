🎓 Andal CBT System

Flutter, PostgreSQL, Dart, Windows, Android

Andal CBT is a comprehensive, offline-capable Computer-Based Testing ecosystem
designed for local school networks. It eliminates the need for active internet
connections during exams by utilising a local PostgreSQL server. The system
comprises three distinct Flutter applications: Admin Portal, Teacher Portal, and
Student Exam Client.

📑 Table of Contents

  - System Architecture
  - Features
      - Admin Portal
      - Teacher Portal
      - Student Client
  - Technology Stack
  - Security & Anti-Cheat
  - Installation & Setup
      - 1. Database Server Setup (Windows)
      - 2. Flutter Apps Setup
  - Screenshots

🏗 System Architecture

The system is designed to run on a Local Area Network (LAN) / Wi-Fi.

  - The Server: The Admin's Windows PC runs a local PostgreSQL Database.
  - The Clients: Teachers and Students connect to the Admin PC's local IPv4
    address via the school's Wi-Fi router.
  - Zero Internet Required: Once configured, the entire exam process (login,
    fetching questions, submitting scores) happens offline.

✨ Features

🛡 Admin Portal (Command Center)

  - Student Management: Register students and assign them to classes (JSS 1 -
    SS 3).
  - Dynamic Security Passcodes: Auto-generates a secure, 6-digit rolling
    passcode for each student that refreshes automatically to prevent credential
    sharing.
  - Teacher Management: Register teachers and assign multiple subjects to them.
  - Scoreboard Analytics: View real-time exam scores with multi-parameter
    filtering (by Subject and by Class).
  - Network Host: Acts as the central hub for the local PostgreSQL database.

👩‍🏫 Teacher Portal

  - Quiz Builder: Create exams with rich text and image attachments for both
    questions and multiple-choice options.
  - Subject Assignment: Quizzes are automatically tagged to the teacher's
    assigned subjects.
  - PDF Export: Convert exams into perfectly formatted, printable PDF documents
    using custom fonts (powered by Syncfusion/PDF).
  - CSV Export: Download student performance reports to standard .csv files for
    Excel integration.

👨‍🎓 Student Client

  - Material 3 UI: Clean, distraction-free gradient user interface.
  - Smart Navigation: Auto-scrolling horizontal question trackers and persistent
    previous/next controls.
  - Device Monitoring: Built-in hardware battery percentage indicator alongside
    the exam countdown timer.
  - Instant Feedback: View scores immediately after exam submission.

💻 Technology Stack

  - Frontend: Flutter (Dart)
  - Database: PostgreSQL (using postgres dart driver)
  - Desktop Window Management: window_manager (for Kiosk mode)
  - Hardware Integration: battery_plus (for battery monitoring)
  - Document Processing: syncfusion_flutter_pdf, pdfx (for PDF generation and
    previews)
  - File Management: file_picker, path_provider, share_plus

🔒 Security & Anti-Cheat

To ensure academic integrity, the system implements several layers of security:

1.  Aggressive Full-Screen (Kiosk Mode): On Windows, the Student App hides the
    taskbar, forces full-screen, and traps the mouse focus.
2.  Keyboard Interception: OS-level shortcuts like Alt+Tab, Alt+F4, and the
    Windows Key are intercepted, pulling the app forcefully back to the
    foreground if triggered.
3.  Rolling Passcodes: Students do not have permanent passwords. They must
    receive a temporary 6-digit code from the Admin immediately before the exam
    begins.

🚀 Installation & Setup

1. Database Server Setup (Admin PC)

1.  Install PostgreSQL on the Admin's Windows PC.
2.  Open pgAdmin 4 and create a database named cbt_admin_db.
3.  Execute the provided SQL schema to generate the students, teachers, exams,
    and scores tables.
4.  Enable Local Network Access:
      - Open C:\Program Files\PostgreSQL\<version>\data\postgresql.conf and set:
        listen_addresses = '*'
      - Open pg_hba.conf and append: host all all 0.0.0.0/0 scram-sha-256
5.  Firewall: Open TCP Port 5432 in Windows Defender Firewall to allow incoming
    connections.
6.  Open Command Prompt, type ipconfig, and note the IPv4 Address (e.g.,
    192.168.1.15).

2. Flutter Apps Setup

1.  Clone the repository:
    git clone https://github.com/yourusername/andal-cbt-system.git
2.  Navigate into any of the app directories (Admin, Teacher, or Student):
    cd andal_student_app
    flutter pub get
3.  Configure Database IP: Open the database service file in the Flutter code
    (e.g., student_db_service.dart) and update the host parameter with the Admin
    PC's IPv4 address found in Step 1.
    host: '192.168.1.15', // Update this IP
    port: 5432,
4.  Run the application:
    # For Windows
    flutter run -d windows

    # For Android Tablets
    flutter run -d android

📸 UI Previews

(Add screenshots of your applications here)

  - Admin Dashboard:    
    <img width="1366" height="768" alt="Screenshot From 2026-09-10 07-21-15" src="https://github.com/user-attachments/assets/f90612fe-7072-4f70-900b-e948325839f4" />
    <img width="1366" height="768" alt="Screenshot From 2026-09-10 07-21-46" src="https://github.com/user-attachments/assets/8c24d120-f1d4-4b0e-addc-dd6297916a0f" />
    <img width="1366" height="768" alt="Screenshot From 2026-09-10 07-21-54" src="https://github.com/user-attachments/assets/3587d8b0-600c-4303-af04-baceef145a0d" />
    <img width="1366" height="768" alt="Screenshot From 2026-09-10 07-22-02" src="https://github.com/user-attachments/assets/d407fff8-2227-46fd-b9c8-39e5bce3a498" />
    <img width="1366" height="768" alt="Screenshot From 2026-09-10 07-23-03" src="https://github.com/user-attachments/assets/bccb9317-f69e-4574-9ae1-e4239bf9d112" />
    <img width="1366" height="768" alt="Screenshot From 2026-09-10 07-23-08" src="https://github.com/user-attachments/assets/0e531261-8a01-4d6d-8495-47b21aac4879" />

  - Teacher Quiz Creator: [Insert Screenshot]
  - Student Exam Interface: [Insert Screenshot]
  - PDF Output: [Insert Screenshot]

📄 License

This project is licensed under the MIT License - see the LICENSE file for
details.

Built with ❤️ using Flutter & PostgreSQL.
