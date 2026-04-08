<div align="center">

# WaitWise

**Turn idle moments into meaningful micro-sessions.**

*A Flutter bootcamp final project — The Boredom Economy*

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase&logoColor=white)](https://supabase.com)
[![n8n](https://img.shields.io/badge/n8n-Automation-EA4B71?logo=n8n&logoColor=white)](https://n8n.io)
[![Riverpod](https://img.shields.io/badge/Riverpod-State_Management-0175C2)](https://riverpod.dev)

</div>

---

## The Idea

Every day, people experience small pockets of dead time — waiting rooms, transit rides, coffee queues, early arrivals. These moments are too short to start something meaningful, yet long enough to feel wasted.

**WaitWise** transforms those idle minutes into something personal and purposeful. The user sets their context and available time. An AI agent reads their interests and backlog, decides the best type of micro-session for that moment, and delivers it instantly — a reflection prompt, a focused task sprint, or a knowledge quiz. No setup. No friction. Just open the app and go.

The goal is not to maximize productivity. It is to give people agency over how they spend the small fragments of time that usually just disappear.

---

## Features

- **AI-generated sessions** — every session is personalized based on the user's interests, mood, context, and personal backlog
- **Three session types** — Reflection (thought-provoking prompts), Task (step-by-step micro-checklists), Quiz (knowledge challenges)
- **Personal backlog** — a lightweight running list of things on the user's mind, which the AI reads and acts on
- **Offline mode** — sessions are pre-generated and cached locally so the app works without internet
- **Session history & dashboard** — full history with filters by type, streaks, total time reclaimed, and weekly growth
- **Automation workflow** — n8n orchestrates user data fetching, AI generation, and Supabase writes in a single webhook call
- **Progressive loading** — animated loading screens with contextual messages during AI generation
  
<img width="1766" height="712" alt="image" src="https://github.com/user-attachments/assets/e8f7967a-e070-472a-a73f-34b2d4b71478" />

---

## Tech Stack

| Layer | Technology |
|---|---|
| Mobile framework | Flutter (Dart) |
| State management | Riverpod (`StateNotifier`) |
| Backend & database | Supabase (PostgreSQL + REST API) |
| Automation workflow | n8n (self-hosted) |
| AI generation | OpenRouter API (LLM via HTTP) |
| Local storage | SharedPreferences |
| Navigation | GoRouter |
| HTTP | `http` package |

---

## Architecture

<img width="719" height="409" alt="architecture_diagram1" src="https://github.com/user-attachments/assets/85ab5e30-5931-4e28-8be9-d40c01405d63" />

### n8n Workflow

When the user taps "Start my session", the app POSTs to an n8n webhook. The workflow:

1. **Webhook** — receives `user_id`, `context`, `mood`, `duration`
2. **Supabase Get Row** — fetches user profile (name, interests)
3. **Supabase Get Many** — fetches recent backlog entries
4. **Code node** — formats backlog into readable text for the prompt
5. **AI Agent** — sends the full context to the LLM, receives a typed session JSON
6. **Code node** — parses and validates the AI output
7. **Supabase Insert** — saves the session to the `sessions` table
8. **Supabase Update** — increments user stats
9. **Respond to Webhook** — returns the complete session JSON to Flutter

<img width="1766" height="712" alt="image" src="https://github.com/user-attachments/assets/e3c32055-b722-4263-b2c6-76845416c188" />

---
## Sequence diagram
<img width="505" height="336" alt="sequence_diagram_waitwise" src="https://github.com/user-attachments/assets/b9b05321-0bb8-405a-8b54-48f37aee303e" />

## Database Schema

```sql
-- Users
create table users (
  id                  uuid primary key default gen_random_uuid(),
  name                text not null,
  interests           text[] default '{}',
  created_at          timestamptz default now(),
  sessions_completed  int4 default 0,
  current_streak      int4 default 0,
  best_streak         int4 default 0,
  times_reclaimed     int4 default 0
);

-- User backlogs (one row per item)
create table user_backlogs (
  id       uuid primary key default gen_random_uuid(),
  user_id  uuid references users(id) on delete cascade,
  content  text not null,
  date     timestamptz default now()
);

-- Sessions
create table sessions (
  id               uuid primary key default gen_random_uuid(),
  user_id          uuid references users(id) on delete cascade,
  title            text,
  context          text,
  duration_minutes int4 not null,
  user_mood        text,
  session_type     text not null check (session_type in ('reflection', 'task', 'quiz')),
  ai_content       jsonb not null,
  user_response    jsonb,
  completed        boolean default false,
  created_at       timestamptz default now()
);
```

<img width="792" height="361" alt="ER_diagram" src="https://github.com/user-attachments/assets/abbe89f4-4d1d-4e10-859d-76f40c8bb470" />


### Session JSON shapes

**Reflection**
```json
{
  "type": "reflection",
  "prompt": "What is one thing that went unexpectedly well this week?"
}
```

**Task**
```json
{
  "type": "task",
  "prompt": "Clear your most urgent pending actions.",
  "steps": [
    { "id": 1, "text": "Reply to the 3 oldest unread emails", "is_complete": false },
    { "id": 2, "text": "Archive anything older than 7 days", "is_complete": false }
  ]
}
```

**Quiz**
```json
{
  "type": "quiz",
  "questions": [
    {
      "question": "What does APY stand for?",
      "options": ["Annual Percent Yield", "Asset Price Yield", "Annual Percentage Yield", "Adjusted Payment Yield"],
      "correct_index": 2,
      "explanation": "APY stands for Annual Percentage Yield."
    }
  ]
}
```

---

## Project Structure

```
lib/
├── core/
│   ├── constants/         # Colors, text styles, strings
│   ├── router/            # GoRouter configuration
│   ├── theme/             # App theme
│   ├── utils/             # Shared helpers (current_user, offline store, prefetch)
│   └── widgets/           # Shared widgets (AppBar, BottomNav, Button, LoadingScreens)
│
├── data/
│   ├── datasources/       # Supabase service functions
│   └── models/            # session_model.dart, user_model.dart
│
└── features/
    ├── onboarding/        # First launch flow
    ├── context_picker/    # Home screen (context + mood + duration)
    ├── active_session/    # Session screen (reflection / task / quiz)
    ├── dashboard/         # Stats overview
    ├── all_sessions/      # Full history with filters + search
    └── backlog/           # Backlog management (CRUD)
```

---

## Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- A [Supabase](https://supabase.com) project
- A self-hosted or cloud [n8n](https://n8n.io) instance
- An [OpenRouter](https://openrouter.ai) API key

### 1. Clone the repository

```bash
git clone https://github.com/your-username/waitwise.git
cd waitwise
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Set up environment variables

Create a `.env` file at the project root:

```env
SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_ANON_KEY=your_supabase_anon_key
WEBHOOK_URL=https://your-n8n-instance.com/webhook/waitwise-session
PREFETCH_WEBHOOK_URL=https://your-n8n-instance.com/webhook/waitwise-prefetch
```

> ⚠️ Never commit your `.env` file. It is already in `.gitignore`.

### 4. Set up the Supabase database

Run the SQL from the [Database Schema](#database-schema) section above in your Supabase SQL Editor. Then add RLS policies:

```sql
-- Allow all operations for development (tighten for production)
create policy "Allow all" on users       for all using (true) with check (true);
create policy "Allow all" on user_backlogs for all using (true) with check (true);
create policy "Allow all" on sessions    for all using (true) with check (true);
```

### 5. Set up the n8n workflow

Import or manually recreate the workflow with this node order:

```
Webhook → Supabase (get user) → Supabase (get backlogs) →
Code (format prompt) → AI Agent (OpenRouter) →
Code (parse output) → Supabase (insert session) →
Supabase (update stats) → Respond to Webhook
```

Set the **Webhook** node to **"Respond to Webhook"** mode so the Flutter app waits for the full response.

### 6. Run the app

```bash
flutter run
```

---

## Key Technical Decisions

**Why n8n for automation?**
n8n acts as the orchestration layer between Flutter, Supabase, and the AI. This keeps all backend logic outside the app — the workflow can be updated without a new app release, and it satisfies the bootcamp's automation workflow requirement explicitly.

**Why Riverpod `StateNotifier`?**
Each feature has its own isolated notifier with typed state. Loading, error, and data states are all explicit — no `bool isLoading` scattered across widgets. The provider auto-triggers data fetching on first access.

**Why `jsonb` for `ai_content` and `user_response`?**
Each session type has a fundamentally different data shape. Using `jsonb` avoids three separate tables while keeping the data fully queryable. The Flutter models parse each shape into a typed subclass (`ReflectionSession`, `TaskSession`, `QuizSession`) via a factory constructor.

**Why offline prefetch?**
The AI generation via n8n takes 5–15 seconds. Showing a spinner every time the user wants a session is a poor experience. Pre-generating a pool of 5 sessions on first launch and after each backlog addition means the session screen loads instantly in the common case.

**Why a parent/child model hierarchy?**
`SessionModel` is abstract. Each subclass owns its strongly-typed `aiContent` and `userResponse`. This eliminates `Map<String, dynamic>` casts throughout the UI code and makes the switch-based screen routing (`switch (_session!) { ReflectionSession s => ... }`) safe at compile time.

---

## Bootcamp Concepts Integration

| Requirement | Implementation |
|---|---|
| Flutter framework | Entire app |
| State management | Riverpod `StateNotifier` across all features |
| Generative AI | OpenRouter LLM via n8n AI Agent node |
| Database integration | Supabase PostgreSQL — full CRUD on users, sessions, backlogs |
| Automation workflows | n8n webhook workflow orchestrating the full session generation pipeline |

---

## Evaluation Criteria Coverage

**Technical (60%)**
- End-to-end functional user flow: onboarding → context picker → AI session → completion → dashboard
- Full theme alignment with The Boredom Economy concept
- Clean architecture: feature-first folder structure, typed models, service layer separated from UI
- All four bootcamp concepts integrated and working together
- Offline fallback pool, progressive loading UX, error recovery

**Presentation (30%)**
- Live demo path: open app → pick context → watch AI generate → complete session → see it in dashboard
- Clear value proposition: transforms dead time into personal, useful micro-sessions

**Documentation (10%)**
- This README
- Typed models with inline documentation
- Commented service functions
- Clear separation of concerns throughout codebase

---
## DEMO Link 

https://drive.google.com/drive/folders/1Hv3P0fHDMIKhR1gkP4z2SXeSZc9Mu8w5

## Presentation link

https://www.canva.com/design/DAHGM2asSc0/mCO67NgnMi_oeqWa02Kgrg/edit
## License


MIT

---

<div align="center">
  Built with focus during the Flutter Bootcamp — April 2026
</div>
