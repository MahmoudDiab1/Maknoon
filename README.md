# Maknoon Quran Reader

A modern, feature-rich Quran reading application built with SwiftUI, following clean architecture principles and best practices.

## Features

- 📖 Quran text display with custom typography
- 🌓 Light/Dark mode support
- 📱 Responsive design with dynamic scaling
- 🔄 Interactive page navigation
- 🎯 Custom tab bar for different reading modes
- 📊 Page information display (Juz, Hizb, Page number)
- 🎨 Beautiful UI with custom themes
- 🔍 Page search functionality

## Technical Architecture

### Core Components

- **Views**
  - `QuranReaderView`: Main reading interface
  - `PageEntryView`: Page number entry screen
  - `CustomTabBar`: Reading mode selector
  - `HeaderView`: Navigation and information display
  - `FooterView`: Page navigation controls

- **ViewModels**
  - `QuranReaderViewModel`: Manages Quran reading state and business logic

- **Models**
  - `QuranTheme`: Theme management
  - `AppAppearance`: Appearance settings
  - `Ayah`: Quran verse model

- **Services**
  - `QuranAPI`: Network layer for Quran data
  - `NetworkService`: Generic networking service
  - `Persistence`: Core Data integration

### Design Patterns

- MVVM Architecture
- Dependency Injection
- Repository Pattern
- Factory Pattern
- Combine for reactive programming

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/maknoon.git
```

2. Open `Maknoon.xcodeproj` in Xcode

3. Build and run the project

## Project Structure

```
Maknoon/
├── Features/
│   └── QuranReader/
│       ├── Views/
│       ├── ViewModels/
│       ├── Models/
│       └── API/
├── Core/
│   ├── NetworkLayer/
│   ├── Persistence/
│   └── Utils/
└── Resources/
    ├── Assets/
    └── Fonts/
```

## Dependencies

- SwiftUI
- Combine
- CoreData

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Quran API integration
- Custom font implementations
- UI/UX design patterns 