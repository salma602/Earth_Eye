# 🌍 Earth Eye

**Earth Eye** is a cross-platform mobile app built using **Flutter** that allows users to explore detailed information about countries around the world. It integrates with the **REST Countries API** to fetch real-time data and presents it in a clean, user-friendly interface.

---

## 🚀 Features

- 🌐 **Country Explorer** – Browse through countries with their:
  - Name
  - Capital city
  - Official languages
  - Area
  - Population
  - National flag
- 🗺 **Map Integration** – View selected country's location on Google Maps
- 📱 **Responsive UI** – Works on both Android and iOS
- 🔎 **Search Functionality** – Quickly find a country by name
- ⚡ **API Integration** – Data pulled in real-time using [REST Countries API](https://restcountries.com)
-

## 🛠 Tech Stack

- **Flutter** – Cross-platform UI toolkit
- **Dart** – Programming language
- **REST API** – Data fetched using `http` package
- **Geolocator & URL Launcher** – Open Google Maps with coordinates

---

## 📦 Installation

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Android Studio / VS Code / Any Flutter-supported IDE
- Git

### Steps

```bash
git clone https://github.com/salma602/Earth_Eye.git
cd Earth_Eye
flutter pub get
flutter run
