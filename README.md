# c100

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Onboarding & Home Screens

- **Behavior**: The app starts with an onboarding flow every time the app launches because no storage/persistence is used to remember completion.
- **Flow**: Onboarding has multiple pages with indicators and Skip/Next/Get Started actions. "Get Started" navigates to the `HomeScreen`.

## Run

```bash
flutter run
```

If you hot restart or relaunch the app, the onboarding will appear again by design.
