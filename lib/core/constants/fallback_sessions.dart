import 'package:waitwise/data/models/session_model.dart';

List<SessionModel> loadFallbackSessions(
  String userId,
  String userContext,
  String mood,
  int duration,
  DateTime now,
) {
  return [
    // ── Reflections ──────────────────────────────────────
    ReflectionSession(
      userId: userId,
      title: 'Mindful Moment',
      context: userContext,
      durationMinutes: duration,
      userMood: mood,
      createdAt: now,
      aiContent: ReflectionContent(
        prompt:
            'What is one thing that went unexpectedly well for you this week, and what made it possible?',
      ),
    ),
    ReflectionSession(
      userId: userId,
      title: 'Career Check-in',
      context: userContext,
      durationMinutes: duration,
      userMood: mood,
      createdAt: now,
      aiContent: ReflectionContent(
        prompt:
            'If your current job disappeared tomorrow, what would you do first — and what does that tell you?',
      ),
    ),
    ReflectionSession(
      userId: userId,
      title: 'Energy Audit',
      context: userContext,
      durationMinutes: duration,
      userMood: mood,
      createdAt: now,
      aiContent: ReflectionContent(
        prompt:
            'What drained your energy most this week, and what gave it back? What pattern do you notice?',
      ),
    ),
    ReflectionSession(
      userId: userId,
      title: 'Unfinished Business',
      context: userContext,
      durationMinutes: duration,
      userMood: mood,
      createdAt: now,
      aiContent: ReflectionContent(
        prompt:
            'What is one conversation you have been putting off — and what are you actually afraid will happen if you have it?',
      ),
    ),
    ReflectionSession(
      userId: userId,
      title: 'The Highlight Reel',
      context: userContext,
      durationMinutes: duration,
      userMood: mood,
      createdAt: now,
      aiContent: ReflectionContent(
        prompt:
            'If someone who believed in you watched your last 7 days, what would they point to as a sign you are growing?',
      ),
    ),

    // ── Tasks ─────────────────────────────────────────────
    TaskSession(
      userId: userId,
      title: 'Quick Brain Dump',
      context: userContext,
      durationMinutes: duration,
      userMood: mood,
      createdAt: now,
      aiContent: TaskContent(
        prompt: 'Get everything out of your head and onto paper.',
        steps: [
          TaskStep(id: 1, text: 'Write every open task you can think of'),
          TaskStep(id: 2, text: 'Circle the one that matters most today'),
          TaskStep(id: 3, text: 'Schedule 15 min for it in your calendar'),
        ],
      ),
    ),
    TaskSession(
      userId: userId,
      title: 'Digital Cleanup',
      context: userContext,
      durationMinutes: duration,
      userMood: mood,
      createdAt: now,
      aiContent: TaskContent(
        prompt: 'Tidy up your digital workspace in small steps.',
        steps: [
          TaskStep(id: 1, text: 'Close all unused browser tabs'),
          TaskStep(id: 2, text: 'Clear your desktop of loose files'),
          TaskStep(id: 3, text: 'Delete 5 apps you haven\'t used this month'),
        ],
      ),
    ),
    TaskSession(
      userId: userId,
      title: 'Tomorrow Prep',
      context: userContext,
      durationMinutes: duration,
      userMood: mood,
      createdAt: now,
      aiContent: TaskContent(
        prompt: 'Set yourself up so tomorrow starts with zero friction.',
        steps: [
          TaskStep(id: 1, text: 'Write your 3 priorities for tomorrow'),
          TaskStep(id: 2, text: 'Block time for the most important one'),
          TaskStep(id: 3, text: 'Lay out anything physical you will need'),
        ],
      ),
    ),
    TaskSession(
      userId: userId,
      title: 'Focus Reset',
      context: userContext,
      durationMinutes: duration,
      userMood: mood,
      createdAt: now,
      aiContent: TaskContent(
        prompt: 'Cut the noise and reclaim your attention.',
        steps: [
          TaskStep(
            id: 1,
            text: 'Turn off all non-essential notifications for 2h',
          ),
          TaskStep(
            id: 2,
            text: 'Put your one current task in a visible sticky note',
          ),
          TaskStep(
            id: 3,
            text: 'Set a timer and work on nothing else until it rings',
          ),
        ],
      ),
    ),
    TaskSession(
      userId: userId,
      title: 'Micro Goal Sprint',
      context: userContext,
      durationMinutes: duration,
      userMood: mood,
      createdAt: now,
      aiContent: TaskContent(
        prompt: 'Break a stuck goal into the smallest possible next move.',
        steps: [
          TaskStep(id: 1, text: 'Name one goal you have not touched this week'),
          TaskStep(
            id: 2,
            text: 'Write the single smallest action that moves it forward',
          ),
          TaskStep(
            id: 3,
            text: 'Do that action right now — it should take under 5 minutes',
          ),
        ],
      ),
    ),

    // ── Quizzes ───────────────────────────────────────────
    QuizSession(
      userId: userId,
      title: 'Sports Legends',
      context: userContext,
      durationMinutes: duration,
      userMood: mood,
      createdAt: now,
      aiContent: QuizContent(
        questions: [
          QuizQuestion(
            question:
                'How many Grand Slam singles titles did Roger Federer win in his career?',
            options: ['18', '19', '20', '21'],
            correctIndex: 2,
            explanation:
                'Roger Federer won 20 Grand Slam singles titles before retiring in 2022, a record at the time he held it.',
          ),
          QuizQuestion(
            question:
                'Which country won the first ever FIFA World Cup in 1930?',
            options: ['Brazil', 'Argentina', 'Uruguay', 'Italy'],
            correctIndex: 2,
            explanation:
                'Uruguay won the inaugural FIFA World Cup held on home soil in 1930, defeating Argentina 4–2 in the final.',
          ),
          QuizQuestion(
            question:
                'In boxing, how many rounds is a standard world championship fight?',
            options: ['10', '12', '15', '8'],
            correctIndex: 1,
            explanation:
                'World championship bouts were reduced from 15 to 12 rounds in 1982 following safety concerns after the Ray Mancini vs Duk Koo Kim fight.',
          ),
          QuizQuestion(
            question:
                'Which tennis player has won the most French Open titles among men?',
            options: [
              'Björn Borg',
              'Rafael Nadal',
              'Novak Djokovic',
              'Roger Federer',
            ],
            correctIndex: 1,
            explanation:
                'Rafael Nadal won the French Open 14 times, earning him the nickname "The King of Clay."',
          ),
        ],
      ),
    ),
    QuizSession(
      userId: userId,
      title: 'Football IQ Test',
      context: userContext,
      durationMinutes: duration,
      userMood: mood,
      createdAt: now,
      aiContent: QuizContent(
        questions: [
          QuizQuestion(
            question: 'Which player has won the most Ballon d\'Or awards?',
            options: [
              'Cristiano Ronaldo',
              'Zinedine Zidane',
              'Lionel Messi',
              'Ronaldo Nazário',
            ],
            correctIndex: 2,
            explanation:
                'Lionel Messi has won the Ballon d\'Or 8 times as of 2023, more than any other player in history.',
          ),
          QuizQuestion(
            question:
                'What is the maximum number of substitutions allowed in a standard FIFA match?',
            options: ['3', '4', '5', '6'],
            correctIndex: 2,
            explanation:
                'FIFA increased the substitution limit from 3 to 5 during the COVID-19 pandemic and it became permanent in 2022.',
          ),
          QuizQuestion(
            question:
                'Which club has won the most UEFA Champions League titles?',
            options: ['Barcelona', 'Bayern Munich', 'AC Milan', 'Real Madrid'],
            correctIndex: 3,
            explanation:
                'Real Madrid has won the UEFA Champions League / European Cup 15 times, more than any other club.',
          ),
          QuizQuestion(
            question: 'In football, what does VAR stand for?',
            options: [
              'Video Assisted Referee',
              'Virtual Assessment Review',
              'Video Analysis Review',
              'Visual Assistance Ruling',
            ],
            correctIndex: 0,
            explanation:
                'VAR stands for Video Assistant Referee — a system introduced to help on-field referees review key decisions.',
          ),
        ],
      ),
    ),
    QuizSession(
      userId: userId,
      title: 'Combat Sports',
      context: userContext,
      durationMinutes: duration,
      userMood: mood,
      createdAt: now,
      aiContent: QuizContent(
        questions: [
          QuizQuestion(
            question:
                'Muhammad Ali\'s birth name before he converted to Islam was:',
            options: [
              'Cassius Clay',
              'Malcolm Little',
              'Elijah Poole',
              'Louis Wright',
            ],
            correctIndex: 0,
            explanation:
                'Muhammad Ali was born Cassius Marcellus Clay Jr. in 1942. He changed his name after joining the Nation of Islam in 1964.',
          ),
          QuizQuestion(
            question:
                'How many weight classes exist in professional boxing as recognised by the major sanctioning bodies?',
            options: ['12', '14', '17', '8'],
            correctIndex: 2,
            explanation:
                'Professional boxing recognises 17 weight classes, from minimumweight (105 lbs) to heavyweight (200+ lbs).',
          ),
          QuizQuestion(
            question:
                'In MMA, which submission involves controlling the opponent\'s arm and hyperextending the elbow?',
            options: [
              'Rear naked choke',
              'Triangle choke',
              'Armbar',
              'Guillotine',
            ],
            correctIndex: 2,
            explanation:
                'The armbar (or juji-gatame) hyperextends the elbow joint and is one of the most common submission finishes in MMA and BJJ.',
          ),
          QuizQuestion(
            question:
                'Conor McGregor became the first UFC fighter to simultaneously hold titles in how many weight classes?',
            options: ['1', '2', '3', '4'],
            correctIndex: 1,
            explanation:
                'Conor McGregor made history in 2016 by holding UFC titles in both featherweight and lightweight simultaneously.',
          ),
        ],
      ),
    ),
    QuizSession(
      userId: userId,
      title: 'Cinema Classics',
      context: userContext,
      durationMinutes: duration,
      userMood: mood,
      createdAt: now,
      aiContent: QuizContent(
        questions: [
          QuizQuestion(
            question:
                'Which film holds the record for the most Academy Award wins, tied at 11 Oscars?',
            options: [
              'Schindler\'s List',
              'Titanic',
              'The Lord of the Rings: The Return of the King',
              'Both B and C',
            ],
            correctIndex: 3,
            explanation:
                'Both Titanic (1997) and The Lord of the Rings: The Return of the King (2003) each won 11 Academy Awards, tying Ben-Hur (1959).',
          ),
          QuizQuestion(
            question: 'Who directed the 1994 film Pulp Fiction?',
            options: [
              'Martin Scorsese',
              'Quentin Tarantino',
              'David Fincher',
              'Spike Lee',
            ],
            correctIndex: 1,
            explanation:
                'Pulp Fiction was written and directed by Quentin Tarantino. It won the Palme d\'Or at Cannes and was nominated for 7 Oscars.',
          ),
          QuizQuestion(
            question:
                'In The Godfather (1972), what animal\'s head is placed in a character\'s bed?',
            options: ['Bull', 'Dog', 'Horse', 'Pig'],
            correctIndex: 2,
            explanation:
                'A severed horse head is placed in the bed of film producer Jack Woltz as a warning from the Corleone family.',
          ),
          QuizQuestion(
            question:
                'Which actor played the Joker in The Dark Knight (2008) and won a posthumous Oscar for the role?',
            options: [
              'Jared Leto',
              'Jack Nicholson',
              'Joaquin Phoenix',
              'Heath Ledger',
            ],
            correctIndex: 3,
            explanation:
                'Heath Ledger won the Academy Award for Best Supporting Actor posthumously for his portrayal of the Joker. He passed away in January 2008 before the film\'s release.',
          ),
        ],
      ),
    ),
    QuizSession(
      userId: userId,
      title: 'Computer Science 101',
      context: userContext,
      durationMinutes: duration,
      userMood: mood,
      createdAt: now,
      aiContent: QuizContent(
        questions: [
          QuizQuestion(
            question: 'What does CPU stand for?',
            options: [
              'Central Processing Unit',
              'Core Parallel Unit',
              'Computed Processing Utility',
              'Central Program Unit',
            ],
            correctIndex: 0,
            explanation:
                'CPU stands for Central Processing Unit — the primary component of a computer that executes instructions.',
          ),
          QuizQuestion(
            question:
                'In Big O notation, what is the time complexity of binary search?',
            options: ['O(n)', 'O(n²)', 'O(log n)', 'O(1)'],
            correctIndex: 2,
            explanation:
                'Binary search has O(log n) time complexity because it halves the search space with each comparison.',
          ),
          QuizQuestion(
            question:
                'Which data structure operates on a Last-In-First-Out (LIFO) principle?',
            options: ['Queue', 'Stack', 'Linked List', 'Tree'],
            correctIndex: 1,
            explanation:
                'A stack uses LIFO — the last element pushed is the first to be popped. Common uses include function call management and undo operations.',
          ),
          QuizQuestion(
            question: 'What does SQL stand for?',
            options: [
              'Structured Query Language',
              'Sequential Queue Logic',
              'System Query Lookup',
              'Structured Queue List',
            ],
            correctIndex: 0,
            explanation:
                'SQL stands for Structured Query Language — the standard language for managing and querying relational databases.',
          ),
          QuizQuestion(
            question:
                'Which sorting algorithm has an average time complexity of O(n log n)?',
            options: [
              'Bubble Sort',
              'Insertion Sort',
              'Merge Sort',
              'Selection Sort',
            ],
            correctIndex: 2,
            explanation:
                'Merge Sort consistently achieves O(n log n) by recursively dividing the array and merging sorted halves.',
          ),
        ],
      ),
    ),
  ];
}
