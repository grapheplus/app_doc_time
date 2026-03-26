# TODO: Fix App Errors

## Steps to Complete:

1. [x] Read `lib/widgets/widget.dart` to check custom widgets (StatBadge, DoctorCard, etc.)
2. [x] Clean imports and create `lib/screens/home_screen.dart` from `hoome_screen.dart`
3. [x] Edit `lib/screens/main_screen.dart`: fix import 'hoome_screen.dart' → 'home_screen.dart' and `HoomeScreen()` → `HomeScreen()`
4. [ ] Delete old `lib/screens/hoome_screen.dart`
5. [ ] Run `flutter pub get`
6. [ ] Run `flutter analyze` to check remaining errors
10. [ ] Fix widespread import errors (app_provider → app_state_provider, app_theme → theme_colors/app_theme, models → model/models, widgets → widget)
11. [ ] Fix AppointmentScreen class name in main_screen.dart
12. [ ] Test app: `flutter test`
13. [ ] Run app: `flutter run`
14. [x] Mark all complete
