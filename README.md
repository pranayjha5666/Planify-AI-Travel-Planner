# Planify - AI Travel Planner

## Overview
Planify is an AI-powered travel planner app designed to help users effortlessly plan trips based on their preferences. Using Google's Gemini AI, the app provides personalized travel recommendations, including top places to visit, hotels (budget/luxury), and an itinerary tailored to the user's input. The app integrates Firebase for authentication and database management to ensure a seamless user experience.

## Features

### 🔥 AI-Powered Travel Planning
- AI-generated travel itineraries based on user preferences
- Suggested places to visit, eat, and stay
- Personalized recommendations for different traveler types (family, solo, friends, business, etc.)

### 🌍 Location-Based Search
- Users can search for a location to explore
- Auto-suggestions and autocomplete for destinations
- Displays a carousel of images for searched locations

### 🏨 Smart Hotel Suggestions
- AI-powered recommendations for hotels (budget and luxury)
- Filtering options based on budget, location, and amenities

### 🗺️ Interactive Map & Navigation
- Google Maps integration for location preview and navigation
- Nearby attractions and points of interest
- Distance and estimated travel time calculations

### 🔐 Secure Authentication & Cloud Storage
- Firebase Authentication (Google, Email/Password, etc.)
- Secure user profile management
- Cloud Firestore for saving and retrieving trip plans

### 📱 User-Friendly Interface
- Intuitive UI/UX for easy trip planning
- Multi-language support (future update)

## Tech Stack
- **Frontend:** Flutter (Dart)
- **Backend:** Firebase Firestore & Authentication
- **AI Model:** Google Gemini API
- **Maps & Navigation:** Google Maps API, Geocoding API
- **State Management:** Provider / Riverpod

## Installation & Setup

### Prerequisites
- Flutter SDK installed
- Firebase project set up with necessary configurations
- Google Maps API key
- Gemini API key
- Cloudinary API key, secret, and upload preset

### Steps to Run the Project
1. Clone the repository:
   ```sh
   git clone https://github.com/pranayjha5666/Planify-AI-Travel-Planner.git
   cd Planify-AI-Travel-Planner
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Set up Firebase:
    - Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) in their respective directories.
    - Enable Firebase Authentication and Firestore Database.
4. Add your API keys in the `.env` file:
   ```env
   Mapapikey=your_google_maps_api_key
   Geminiapikey=your_gemini_api_key
   CloudinaryapiKey=your_cloudinary_api_key
   CloudinaryapiSecret=your_cloudinary_api_secret
   CloudinaryuploadPreset=your_cloudinary_upload_preset
   ```
5. Run the app:
   ```sh
   flutter run
   ```



## Contributors
- **Pranay Jha** - [GitHub](https://github.com/pranayjha5666)

