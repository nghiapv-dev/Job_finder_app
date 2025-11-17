# Features Folder Structure

## 📁 Organization

```
features/
├── job_seeker/          # Job-seeker side (J)
│   ├── bloc/            # State management for job-seeker
│   │   └── (To be implemented: job_bloc, saved_job_bloc, etc.)
│   └── screens/
│       └── home_screen.dart (J01 - Home)
│
├── recruiter/           # Recruiter side (R)
│   ├── bloc/            # State management for recruiter
│   │   └── (To be implemented: job_post_bloc, applicant_bloc, etc.)
│   └── screens/
│       └── (To be implemented)
│
├── shared/              # Shared between both sides (G)
│   └── screens/
│       ├── welcome_screen.dart (Initial splash)
│       └── welcome_home_screen.dart (Role selection)
│
└── auth/                # Authentication
    ├── bloc/
    │   ├── auth_bloc.dart
    │   ├── auth_event.dart
    │   └── auth_state.dart
    └── screens/
        ├── login_screen.dart
        ├── register_screen.dart
        ├── reset_password_screen.dart
        ├── job_preference_screen.dart
        ├── profile_setup_screen.dart
        └── profile_confirm_screen.dart
```

## 🎯 Screen Categories

### Job-seeker Screens (J)
- **J01**: Home (Tips, Job Recommendations)
- **J02**: Search (To be implemented)
- **J03**: Job Detail (To be implemented)
- **J04**: Saved Jobs (To be implemented)
- **J05**: Application Tracking (To be implemented)
- **J06**: Profile (To be implemented)

### Recruiter Screens (R)
- **R01**: Recruiter Home (To be implemented)
- **R02**: Post Job (To be implemented)
- **R03**: Applicants Management (To be implemented)

### Shared Screens (G)
- Welcome Screen
- Welcome Home (Role selection)
- Notifications (To be implemented)

### Auth Screens
- Login
- Register
- Reset Password
- Job Preference
- Profile Setup
- Profile Confirm

## 🔄 User Flow

### Job-seeker Flow
```
Welcome → Login/Register → Welcome Home → "I want a job" 
→ Job Preference → Profile Setup → Profile Confirm → Home (J01)
```

### Recruiter Flow
```
Welcome → Login/Register → Welcome Home → "I want an employee"
→ Recruiter Home (R01) → (To be implemented)
```
