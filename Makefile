build:
	@flutter pub get
	@flutter pub run flutter_launcher_icons:main

run: build
	@flutter run
