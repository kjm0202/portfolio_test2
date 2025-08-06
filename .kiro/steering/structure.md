# Project Structure

## Root Directory
```
portfolio_test2/
├── lib/                    # Main application code
├── web/                    # Web-specific assets
├── test/                   # Unit tests
├── .fvm/                   # Flutter Version Management
├── pubspec.yaml           # Dependencies and metadata
└── analysis_options.yaml  # Linting configuration
```

## Source Code Organization (`lib/`)

### Main Application
- `main.dart` - App entry point with StatefulWidget for theme management and MaterialApp configuration
- `portfolio_page.dart` - Main page with navigation, scroll controller, and theme callback handling

### UI Components (Section-based)
- `intro_section.dart` - Hero section with profile and introduction
- `projects_section.dart` - Portfolio projects showcase
- `contact_section.dart` - Contact information and form
- `footer.dart` - Footer component

### Theme System
- `theme.dart` - AppTheme class with light/dark ColorSchemes and ThemeData
- `theme_toggle.dart` - UI component for theme switching with callback pattern

## Naming Conventions
- **Files**: snake_case (e.g., `intro_section.dart`)
- **Classes**: PascalCase (e.g., `IntroSection`, `ThemeProvider`)
- **Variables**: camelCase (e.g., `isDarkMode`, `scrollController`)
- **Constants**: camelCase for local, SCREAMING_SNAKE_CASE for global

## Code Organization Patterns
- One widget per file for major components
- Stateful widgets for components with local state
- Private methods prefixed with underscore (`_buildNavItems`)
- Responsive breakpoint: `width < 800` for mobile detection
- Theme access: `Theme.of(context)` for consistent styling

## Asset Structure (`web/`)
- `index.html` - Web entry point
- `manifest.json` - PWA configuration
- `favicon.png` - Browser icon
- `icons/` - App icons for different sizes