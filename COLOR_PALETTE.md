# DietCare App Color Palette

This document contains all the color codes used throughout the DietCare application.

## Primary Colors

### Orange (Primary Brand Color)
- **Primary Orange**: `#FF6B35` / `Color(0xFFFF6B35)`
  - Used for: Headers, buttons, active states, accents
  - RGB: (255, 107, 53)
  - HSL: (13°, 100%, 60%)

### Orange Gradient
- **Orange Light**: `#FF6B35` / `Color(0xFFFF6B35)`
- **Orange Dark**: `#E55A2B` / `Color(0xFFE55A2B)`
  - Used for: Gradient backgrounds, button gradients
  - RGB: (229, 90, 43)

### Alternative Orange Gradient (Buttons)
- **Orange Light**: `#FE8347` / `Color(0xFFFE8347)`
- **Orange Dark**: `#A43B08` / `Color(0xFFA43B08)`
  - Used for: Login/signup button gradients

### Accent Colors
- **Brown**: `#8B4513` / `Color(0xFF8B4513)`
  - Used for: Special accents, icons
  - RGB: (139, 69, 19)

## Background Colors

### Main Backgrounds
- **Primary Dark Background**: `#1A1A1A` / `Color(0xFF1A1A1A)`
  - Used for: Main screen backgrounds, Scaffold backgrounds
  - RGB: (26, 26, 26)

- **Card Background**: `#2A2A2A` / `Color(0xFF2A2A2A)`
  - Used for: Card containers, input fields, bottom navigation
  - RGB: (42, 42, 42)

- **Border/Separator**: `#3A3A3A` / `Color(0xFF3A3A3A)`
  - Used for: Borders, dividers, separators
  - RGB: (58, 58, 58)

- **Darker Gray**: `#4A4A4A` / `Color(0xFF4A4A4A)`
  - Used for: Additional depth layers
  - RGB: (74, 74, 74)

## Text Colors

### Primary Text
- **White**: `Colors.white` / `#FFFFFF`
  - Used for: Primary text, headings, important labels
  - RGB: (255, 255, 255)

- **Gray Text**: `#9E9E9E` / `Color(0xFF9E9E9E)`
  - Used for: Secondary text, hints, placeholders, inactive states
  - RGB: (158, 158, 158)

## Material Colors (Used in App)

### Standard Material Colors
- **Green**: `Colors.green`
  - Used for: Nutrition labels (Protein), success indicators
  
- **Blue**: `Colors.blue`
  - Used for: Nutrition labels (Carbs, Fats), payment icons
  
- **Orange**: `Colors.orange`
  - Used for: Nutrition labels (Carbs)
  
- **Red**: `Colors.red`
  - Used for: Delete buttons, error states, pause indicators
  
- **Purple**: `Colors.purple`
  - Used for: Social icons
  
- **Yellow**: `Colors.yellow`
  - Used for: Social icons
  
- **Light Blue**: `Colors.lightBlue`
  - Used for: Calendar highlights

## Color Usage Summary

### By Component

**Headers & Top Sections:**
- Background: Orange gradient (`#FF6B35` to `#E55A2B`)
- Text: White

**Cards & Containers:**
- Background: `#2A2A2A`
- Border: `#3A3A3A`

**Input Fields:**
- Background: `#2A2A2A`
- Border: `#3A3A3A`
- Text: White
- Placeholder: `#9E9E9E`

**Buttons:**
- Primary: Orange gradient (`#FF6B35` to `#E55A2B` or `#FE8347` to `#A43B08`)
- Text: White

**Active States:**
- Color: `#FF6B35` (Orange)
- Border: `#FF6B35`

**Inactive States:**
- Color: `#9E9E9E` (Gray)
- Border: `#3A3A3A`

**Dividers:**
- Color: `#3A3A3A`

---

## Flutter Implementation

### Quick Reference

```dart
// Primary Colors
const primaryOrange = Color(0xFFFF6B35);
const orangeDark = Color(0xFFE55A2B);
const orangeGradientStart = Color(0xFFFE8347);
const orangeGradientEnd = Color(0xFFA43B08);

// Backgrounds
const backgroundColor = Color(0xFF1A1A1A);
const cardBackground = Color(0xFF2A2A2A);
const borderColor = Color(0xFF3A3A3A);

// Text
const textPrimary = Colors.white;
const textSecondary = Color(0xFF9E9E9E);
```

### Example Gradient Usage

```dart
LinearGradient(
  colors: [
    Color(0xFFFF6B35),
    Color(0xFFE55A2B),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
)
```

---

*Last Updated: Based on codebase analysis of DietCare Flutter app*



