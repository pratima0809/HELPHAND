# HelpHand – Volunteer Opportunity Finder & Sign-up App

## Problem Statement
"HelpHand wants an app where a logged-in user browses volunteering opportunities posted by organizations, filters them by cause, and signs up through a validated form that records their commitment centrally."

## Objectives
- UI / Widgets: Opportunity List, Opportunity Detail, My Sign-ups, Sign-up Form using ListView, Card, Form widgets.
- Styling / Theming: Warm, community-focused Material 3 theme, cause-category chips.
- Dart Logic: Conditional filtering logic based on cause category.
- Opportunity Card: Displays Organization name, Cause category, Date, and Volunteer slots remaining.

## Features
- **Firebase Authentication**: Login functionality to secure sign-ups.
- **Browse Opportunities**: View a list of dummy volunteering opportunities.
- **Category Filtering**: Filter opportunities by cause (e.g., Environment, Education).
- **Opportunity Details**: Detailed view of each opportunity.
- **Sign-up Form**: Validated form capturing user details and availability.
- **Slot Management**: Centralized tracking and decrementing of volunteer slots in Firestore.
- **Duplicate Prevention**: Prevents signing up multiple times for the same opportunity.
- **My Sign-ups**: Personalized dashboard displaying user commitments.

## Technologies
- **Framework**: Flutter
- **Language**: Dart
- **Backend / BaaS**: Firebase Authentication, Cloud Firestore
- **Design System**: Material 3

## Installation
1. Clone the repository.
2. Ensure you have Flutter installed.
3. Run `flutter pub get` to install dependencies.
4. Run the app using `flutter run` or start debugging in your IDE.

## Firebase Setup
To connect this app to your own Firebase project:
1. Create a project in the Firebase Console.
2. Enable Email/Password authentication in Firebase Authentication.
3. Enable Cloud Firestore and create a database.
4. Add an Android/iOS/Web app in Firebase and download the corresponding config files (`google-services.json` for Android, `GoogleService-Info.plist` for iOS).
5. Add the config files to the appropriate directories in the Flutter project (`android/app/` and `ios/Runner/`).
6. Alternatively, use the FlutterFire CLI: `flutterfire configure`.

## Firestore Structure
Collections:
- `opportunities`
  - Fields: `title`, `organizationName`, `category`, `date`, `time`, `location`, `totalSlots`, `remainingSlots`, `description`, `responsibilities`, `requirements`
- `signups`
  - Fields: `userId`, `opportunityId`, `opportunityTitle`, `organizationName`, `category`, `date`, `location`, `volunteerName`, `email`, `phone`, `availability`, `skills`, `reason`, `status`, `createdAt`
- `users` (Managed implicitly by Firebase Auth for this simple project structure)

## Firestore Security Rules
Basic rules for academic project:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /opportunities/{opportunity} {
      allow read: if request.auth != null;
      // In a real app, only admins could write here, but for testing we can allow write
      allow write: if request.auth != null; 
    }
    match /signups/{signup} {
      // Users can only read and write their own signups
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow read: if request.auth != null && resource.data.userId == request.auth.uid;
    }
  }
}
```

## Application Flow
1. **Login Screen**: User authenticates.
2. **Opportunity List**: Displays all opportunities, filtered by the selected category chip.
3. **Opportunity Detail**: Shows complete information and remaining slots.
4. **Sign-up Form**: User enters details; validated locally.
5. **Confirmation Screen**: Displays success message.
6. **My Sign-ups Screen**: Lists only the current user's sign-ups.

## Cause Filtering Logic
Filtering is implemented using Dart's `where` method on the list of opportunities based on the `selectedCategory` state variable.

## Sign-up Validation
Uses standard Flutter `Form` and `TextFormField` validation logic for required fields, email format, phone format, and consent checkbox.

## Slot Decrement Logic
When a signup is submitted, the application uses a Firestore batch operation to write the signup document and update the `remainingSlots` of the corresponding opportunity concurrently.

## My Sign-ups Logic
A Firestore query filters the `signups` collection where `userId` equals the currently logged-in user's UID.

## Figma Screen List
1. Login Screen
2. Opportunity List (with cause filtering)
3. Opportunity Detail
4. Sign-up Form
5. Confirmation Screen
6. My Sign-ups Screen

## How the project satisfies the assignment
- It adheres exactly to the 6 prescribed screens.
- Avoids unnecessary features (no complex state management, no extraneous UI).
- Implements the required Firebase backend integration.
- Demonstrates clear conditional UI updates and standard Flutter widget usage.

## Known Limitations
- The project currently relies on dummy data that initializes on first run if the database is empty.
- Slot decrements are handled via client-side logic in a batch; a production app would use Firestore Transactions or Cloud Functions to handle concurrent signups perfectly.
