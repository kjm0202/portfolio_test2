# Technology Stack

## Framework & Language
- **Flutter**: Web application framework
- **Dart**: Programming language (SDK ^3.7.2)
- **Material 3**: UI design system with useMaterial3: true

## Key Dependencies
- `google_fonts: ^6.2.1` - Poppins font family
- `shared_preferences: ^2.5.3` - Theme preference persistence
- `cupertino_icons: ^1.0.8` - iOS-style icons

## Development Tools
- `flutter_lints: ^5.0.0` - Dart/Flutter linting rules
- `flutter_test` - Testing framework
- **FVM**: Flutter Version Management (configured in .fvm/)

## Build System & Commands

### Development
```bash
flutter run -d chrome          # Run in Chrome browser
flutter run -d web-server      # Run on local web server
```

### Building
```bash
flutter build web              # Build for web deployment
flutter build web --release    # Production build
```

### Testing & Analysis
```bash
flutter test                   # Run unit tests
flutter analyze                # Static code analysis
flutter pub get                # Install dependencies
flutter pub upgrade            # Update dependencies
```

## Architecture Patterns
- **Native state management**: StatefulWidget with setState for theme management
- **Widget composition**: Modular UI components in separate files
- **Callback pattern**: Theme toggle uses callback functions for state updates
- **Responsive design**: MediaQuery-based breakpoints (800px)
- **Material 3 theming**: Custom ColorScheme with light/dark variants