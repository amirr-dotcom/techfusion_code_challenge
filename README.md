# TechFusion Flutter Code Challenge - User Directory

Hey there! This is my submission for the User Directory App challenge. I've built this using **Clean Architecture** and **BLoC** to ensure the code is maintainable, scalable, and easy to test.

## 🛠️ Architecture Decisions

I chose **Clean Architecture** because it provides a clear separation of concerns.
- **Domain Layer**: The heart of the app. It contains the business logic (Entities and Use Cases) and is completely independent of any external libraries or UI.
- **Data Layer**: Handles data retrieval from the DummyJSON API. It implements the repository interfaces defined in the Domain layer.
- **Presentation Layer**: Built with **BLoC (Business Logic Component)**. It manages the UI state and reacts to user events like scrolling for pagination, searching, and filtering.

**State Management**: I went with **BLoC** because it's predictable and works exceptionally well with streams, which is perfect for features like infinite scrolling and real-time search filtering.

**Dependency Injection**: Used **Injectable** with **GetIt**. It's the industry standard for Flutter to keep the code decoupled and clean by automating the injection process.

## ✨ Features Implemented

- [x] **Infinite Scrolling**: Automatically loads the next 10 users when you reach the bottom.
- [x] **API Filtering**: Gender filter (Male/Female) is handled directly via API parameters as requested.
- [x] **Local Search & Sort**: Super snappy search and A-Z/Z-A sorting performed on the client-side for the best UX.
- [x] **Theming**: Full Support for Light and Dark modes using Material 3.
- [x] **Localization**: Integrated `easy_localization`. Currently supports English, but ready for more.
- [x] **Responsive Layout**: Designed to look great on both phones and tablets.
- [x] **Detail Screen**: Hero animations and a polished UI for viewing full user profiles.

## 🚀 Getting Started

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Generate DI Code**:
   Since I'm using `injectable`, you'll need to run build_runner:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Run the App**:
   ```bash
   flutter run
   ```

## 📦 Key Packages Used
- `flutter_bloc`: State management
- `dio`: Networking
- `get_it` & `injectable`: Dependency Injection
- `cached_network_image`: Image performance
- `easy_localization`: Multi-language support
- `google_fonts`: Typography

## 🔮 What I'd Improve with More Time
- **Unit Tests**: I'd add comprehensive tests for the BLoC logic and Repository implementations.
- **Offline Mode**: Use Hive or SharedPreferences to cache the user list for offline viewing.
- **Skeleton Loaders**: Replace the basic CircularProgressIndicator with shimmer effects for a more premium feel.

---
Hope you like the implementation! Looking forward to your feedback.
