// ==========================================
// 2. Data Models & Mock Data
// ==========================================

class Question {
  final int id;
  final String text;
  final String? imageUrl;
  final List<String> options;
  final int correctIndex;

  Question({
    required this.id,
    required this.text,
    this.imageUrl,
    required this.options,
    required this.correctIndex,
  });
}

// Mock Questions
final List<Question> mockQuestions = [
  // --- Topic 1: Classification of Computers ---
  Question(
    id: 1,
    text:
        "Which type of computer processes data using continuous physical magnitudes like voltage or pressure?",
    options: [
      "Digital Computer",
      "Analog Computer",
      "Hybrid Computer",
      "Mainframe Computer",
    ],
    correctIndex: 1,
    imageUrl: 'lib/assets/login_bg.png',
  ),
  Question(
    id: 2,
    text:
        "Which classification of computer is the most powerful and used for weather forecasting and nuclear simulations?",
    options: ["Supercomputer", "Minicomputer", "Microcomputer", "Workstation"],
    correctIndex: 0,
  ),
  Question(
    id: 3,
    text:
        "A desktop PC, laptop, and smartphone are all examples of which type of computer?",
    options: ["Mainframe", "Supercomputer", "Microcomputer", "Minicomputer"],
    correctIndex: 2,
  ),
  Question(
    id: 4,
    text:
        "Which type of computer combines features of both analog and digital computers?",
    options: ["Supercomputer", "Hybrid Computer", "Server", "Embedded System"],
    correctIndex: 1,
  ),
  Question(
    id: 5,
    text:
        "Which computers were traditionally used by large organizations for bulk data processing and critical applications?",
    options: ["Microcomputers", "Mainframes", "Tablets", "Wearables"],
    correctIndex: 1,
  ),
  Question(
    id: 6,
    text:
        "In terms of size and power, which computer lies between a mainframe and a microcomputer?",
    options: [
      "Minicomputer",
      "Supercomputer",
      "Nano computer",
      "Quantum computer",
    ],
    correctIndex: 0,
  ),
  Question(
    id: 7,
    text:
        "First-generation computers were characterized by the use of which technology?",
    options: [
      "Transistors",
      "Vacuum Tubes",
      "Integrated Circuits",
      "Microprocessors",
    ],
    correctIndex: 1,
  ),

  // --- Topic 2: Computer System ---
  Question(
    id: 8,
    text: "What is considered the 'brain' of the computer system?",
    options: ["Hard Drive", "RAM", "CPU", "Power Supply"],
    correctIndex: 2,
  ),
  Question(
    id: 9,
    text:
        "Which component of the CPU performs arithmetic and logical operations?",
    options: [
      "Control Unit (CU)",
      "Arithmetic Logic Unit (ALU)",
      "Registers",
      "Cache",
    ],
    correctIndex: 1,
  ),
  Question(
    id: 10,
    text: "Which of the following is an Output device?",
    options: ["Keyboard", "Mouse", "Scanner", "Monitor"],
    correctIndex: 3,
  ),
  Question(
    id: 11,
    text:
        "What is the main printed circuit board in a computer that connects all components called?",
    options: ["Motherboard", "Daughterboard", "Switchboard", "Breadboard"],
    correctIndex: 0,
  ),
  Question(
    id: 12,
    text: "Which cycle describes the basic operation of a computer CPU?",
    options: [
      "Read-Write-Execute",
      "Fetch-Decode-Execute",
      "Input-Process-Output",
      "Load-Save-Delete",
    ],
    correctIndex: 1,
  ),
  Question(
    id: 13,
    text: "Which part of the CPU directs the operation of the processor?",
    options: ["ALU", "Control Unit", "Bus", "Heat Sink"],
    correctIndex: 1,
  ),

  // --- Topic 3: Computer Software ---
  Question(
    id: 14,
    text:
        "Microsoft Word and Google Chrome are examples of which type of software?",
    options: [
      "System Software",
      "Utility Software",
      "Application Software",
      "Firmware",
    ],
    correctIndex: 2,
  ),
  Question(
    id: 15,
    text:
        "Which type of software is designed to operate and control the computer hardware directly?",
    options: [
      "Application Software",
      "System Software",
      "Malware",
      "Shareware",
    ],
    correctIndex: 1,
  ),
  Question(
    id: 16,
    text:
        "Which utility software is used to protect a computer from malicious attacks?",
    options: ["Spreadsheet", "Antivirus", "Compiler", "Database"],
    correctIndex: 1,
  ),
  Question(
    id: 17,
    text: "Software that is free to use, modify, and distribute is called:",
    options: [
      "Proprietary Software",
      "Open Source Software",
      "Commercial Software",
      "Licensed Software",
    ],
    correctIndex: 1,
  ),
  Question(
    id: 18,
    text:
        "What is the specific software that translates high-level code into machine code all at once?",
    options: ["Interpreter", "Assembler", "Compiler", "Debugger"],
    correctIndex: 2,
  ),
  Question(
    id: 19,
    text: "Which of the following is an example of Spreadsheet software?",
    options: ["Adobe Photoshop", "MS Excel", "MS PowerPoint", "VLC Player"],
    correctIndex: 1,
  ),
  Question(
    id: 20,
    text:
        "Software permanently programmed into a read-only memory is known as:",
    options: ["Hardware", "Firmware", "Vaporware", "Middleware"],
    correctIndex: 1,
  ),

  // --- Topic 4: Computer Professionals ---
  Question(
    id: 21,
    text:
        "Who is responsible for analyzing a system's requirements and designing an IT solution?",
    options: [
      "Computer Operator",
      "System Analyst",
      "Graphic Designer",
      "Data Entry Clerk",
    ],
    correctIndex: 1,
  ),
  Question(
    id: 22,
    text: "Which professional writes, tests, and maintains computer code?",
    options: [
      "Programmer",
      "System Administrator",
      "End User",
      "Hardware Engineer",
    ],
    correctIndex: 0,
  ),
  Question(
    id: 23,
    text:
        "Who is responsible for the design, implementation, and maintenance of a database?",
    options: [
      "Web Developer",
      "Database Administrator (DBA)",
      "Network Engineer",
      "Content Manager",
    ],
    correctIndex: 1,
  ),
  Question(
    id: 24,
    text:
        "Which professional focuses on the physical components of the computer system?",
    options: [
      "Software Engineer",
      "Computer Hardware Engineer",
      "Web Designer",
      "Data Scientist",
    ],
    correctIndex: 1,
  ),
  Question(
    id: 25,
    text: "Who manages an organization's network infrastructure (LAN/WAN)?",
    options: [
      "SEO Specialist",
      "Network Administrator",
      "UI/UX Designer",
      "Beta Tester",
    ],
    correctIndex: 1,
  ),
  Question(
    id: 26,
    text:
        "What do we call the person who actually uses the computer software or hardware?",
    options: ["Developer", "End User", "Analyst", "Technician"],
    correctIndex: 1,
  ),

  // --- Topic 5: Operating System ---
  Question(
    id: 27,
    text:
        "What is the primary interface between the user and the computer hardware?",
    options: [
      "The Monitor",
      "The Operating System",
      "The Hard Drive",
      "The Application",
    ],
    correctIndex: 1,
  ),
  Question(
    id: 28,
    text: "Which of the following is NOT an Operating System?",
    options: ["Windows", "Linux", "Oracle", "macOS"],
    correctIndex: 2,
  ),
  Question(
    id: 29,
    text: "GUI stands for:",
    options: [
      "General User Input",
      "Graphical User Interface",
      "Global Unit Interface",
      "Graphical Unit Input",
    ],
    correctIndex: 1,
  ),
  Question(
    id: 30,
    text:
        "Which OS interface requires the user to type commands using a keyboard?",
    options: [
      "GUI",
      "Touchscreen",
      "CLI (Command Line Interface)",
      "Voice Control",
    ],
    correctIndex: 2,
  ),
  Question(
    id: 31,
    text: "The process of starting up a computer and loading the OS is called:",
    options: ["Compiling", "Loading", "Booting", "Tagging"],
    correctIndex: 2,
  ),
  Question(
    id: 32,
    text:
        "What is the core component of an Operating System that manages system resources?",
    options: ["Shell", "Kernel", "Bootloader", "Registry"],
    correctIndex: 1,
  ),
  Question(
    id: 33,
    text:
        "Which function of the OS allows multiple programs to run at the same time?",
    options: [
      "Multitasking",
      "Multiprocessing",
      "Bootstrapping",
      "Defragmenting",
    ],
    correctIndex: 0,
  ),

  // --- Topic 6: Storage Devices ---
  Question(
    id: 34,
    text: "Which memory is volatile (loses data when power is off)?",
    options: ["ROM", "Hard Disk", "RAM", "Flash Drive"],
    correctIndex: 2,
  ),
  Question(
    id: 35,
    text: "What does ROM stand for?",
    options: [
      "Random Only Memory",
      "Read Only Memory",
      "Rapid Operational Memory",
      "Real Output Memory",
    ],
    correctIndex: 1,
  ),
  Question(
    id: 36,
    text: "Which storage device uses magnetic platters to store data?",
    options: ["SSD", "HDD (Hard Disk Drive)", "USB Drive", "SD Card"],
    correctIndex: 1,
  ),
  Question(
    id: 37,
    text: "Which is faster and more durable: an SSD or an HDD?",
    options: ["HDD", "SSD", "They are the same", "Floppy Disk"],
    correctIndex: 1,
  ),
  Question(
    id: 38,
    text: "What is the smallest unit of digital data storage?",
    options: ["Byte", "Bit", "Kilobyte", "Nibble"],
    correctIndex: 1,
  ),
  Question(
    id: 39,
    text: "How many bits make up one Byte?",
    options: ["4", "8", "16", "32"],
    correctIndex: 1,
  ),
  Question(
    id: 40,
    text: "Which of these is an example of Optical Storage?",
    options: ["Hard Drive", "Cloud Storage", "CD/DVD", "Flash Drive"],
    correctIndex: 2,
  ),
];
