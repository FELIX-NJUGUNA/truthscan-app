# TruthScan AI

**TruthScan AI** is a cross-platform Flutter application designed to analyze and distinguish between human-written and AI-generated content. It provides a simple, intuitive interface to upload text or PDF documents for analysis. The app connects to a backend AI model via an API to deliver accurate and reliable content classification.

## Features

- 🔍 Detect whether content is AI-generated or human-written
- 📄 Analyze plain text or PDF documents
- 📱 Mobile-first UI with bottom navigation
- 🖥️ Adaptive web support with sidebar navigation
- 🧠 Backend-powered by machine learning model
- 💾 View analysis history
- 👤 User authentication (login/register)
- 🔐 Secure persistent login
- 🎯 Onboarding experience for new users

## Screenshots

> Will add a screenshot

## Tech Stack

### Frontend (Flutter)
- Dart
- MVVM Architecture
- Responsive Design
- PDF Viewer & Text Extraction
- State Management (e.g., Provider, Riverpod, etc.)

### Backend
- Flask API
- AI Content Detection Model
- `/predict/` endpoint for text/PDF classification


## Getting Started

### Prerequisites

- Flutter SDK (3.x)
- Dart SDK
- Android Studio or VS Code
- Backend API running locally or deployed

### Installation

```bash
git clone https://github.com/FELIX-NJUGUNA/truthscan_ai.git
cd truthscan_ai
flutter pub get
flutter run


