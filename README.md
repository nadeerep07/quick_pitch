# QuickPitch

QuickPitch is a **Flutter-based task marketplace application** that connects people who need help with small tasks (**Posters**) with skilled individuals (**Fixers**) who can complete those tasks.

The platform allows users to post tasks, submit pitches, communicate, and manage task completion efficiently.

The app is designed with a **modular architecture**, Firebase backend services, and reusable UI components.

---

# Features

### Task Marketplace

Users can post tasks that require assistance, including:

* Task title
* Description
* Budget
* Location
* Deadline

Fixers can browse tasks and submit pitches.

---

### Pitch System

Fixers can submit proposals explaining:

* Why they are suitable
* Expected completion time
* Their experience or approach

Posters can review pitches and select the best fixer.

---

### User Roles

**Poster**

* Post tasks
* Review pitches
* Accept or reject fixers

**Fixer**

* Browse available tasks
* Submit pitches
* Complete tasks

---

### Authentication

Secure login and signup using **Firebase Authentication**.

---

### Real-Time Data

The app uses **Firebase Firestore** to manage:

* Tasks
* User profiles
* Pitches
* Task status

---

### Image Upload

Task-related images are uploaded using **Cloudinary**.

---

### Location Integration

The application integrates **Geoapify API** to support location-based task information.

---

### UI & Experience

* Custom reusable widgets
* Glassmorphic bottom navigation
* Lottie animations for feedback
* Responsive UI
* Custom theme system

---

# Tech Stack

**Frontend**

* Flutter
* Dart

**Backend Services**

* Firebase Authentication
* Cloud Firestore

**External APIs**

* Cloudinary (image uploads)
* Geoapify (location services)

**UI Libraries**

* Lottie animations
* Custom reusable widgets

---

# Project Structure

```id="g72lps"
lib/
│
├── core/
│   ├── common/
│   ├── config/
│   ├── errors/
│   ├── routes/
│   └── services/
│
├── features/
│
└── main.dart
```

### Core Modules

**core/common**

Reusable UI components:

* Buttons
* Text fields
* Dialogs
* Custom app bars

**core/services**

External integrations:

* Firebase Authentication
* Firestore
* Cloudinary
* Geoapify

**core/routes**

Centralized navigation and route handling.

---

# Assets

The app includes animations and images stored in:

```id="oxp9o3"
assets/
 ├── animations/
 └── images/
```

---

# Getting Started

### Clone the repository

```id="6t6gdu"
git clone https://github.com/nadeerep07/quick_pitch.git
```

### Install dependencies

```id="czfy67"
flutter pub get
```

### Run the app

```id="ax90qf"
flutter run
```

---

# Future Improvements

Planned features include:

* In-app chat system
* Push notifications
* Task rating and review system
* Payment integration
* Admin dashboard
* AI task recommendations

---

# Author

Developed by **Nadeer EP**

Flutter Developer focused on building scalable and user-friendly mobile applications.
