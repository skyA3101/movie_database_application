# 🎬 movie_database_application_

A powerful Flutter app to explore the latest and trending movies, built using the [TMDB API](https://www.themoviedb.org/documentation/api).

## Features

**Trending & Now Playing**: Discover trending and currently playing movies.
-  **Detailed Movie Pages**:
    - Auto-playing YouTube trailer
    - Casts, genres, and movie overview
    - "More like this" section for recommendations
-  **Search**: Instantly search for any movie using debounce for optimized performance.
-  **Bookmark**: Save your favorite movies to a local list for offline access.
-  **Share**: Share movie details with friends via deep links or app share.
-  **Offline Support**: Bookmarked content and previously visited details available offline.
-  **Clean MVVM Architecture**: Maintains separation of concerns with proper state management.

## ️ Tech Stack

- **Flutter** & **Dart**
- **TMDB API**
- **YouTube Player** (`youtube_player_flutter`)
- **Local Database**: `sqflite`
- **State Management**: `Provider`
- **Networking**: `Retrofit` + `Dio`
- **Routing**: `go_router`

## Getting Started

### Prerequisites

- Flutter SDK (>= 3.10.0)
- A TMDB API key
- YouTube API key (optional if using YouTube links directly)

### Setup Instructions

1. **Clone the repo**

```bash
git clone https://github.com/skyA3101/movie_database_application.git
cd movie_database_application

```
##### Note: Apk, (app-release.apk) is located in apk folder. Use app-release.apk directly for testing on android phone.


