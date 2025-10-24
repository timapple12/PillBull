# Makefile for PillBull
# Development and localization commands

.PHONY: help install generate-l10n check-l10n add-language clean test build build-ios run analyze format check setup

# Help
help:
	@echo "PillBull - Development commands"
	@echo ""
	@echo "Main commands:"
	@echo "  install          - Install dependencies"
	@echo "  generate-l10n    - Generate localization files"
	@echo "  check-l10n       - Check localization consistency"
	@echo "  add-language     - Add a new language (LANG_CODE=de LANG_NAME=German NATIVE_NAME=Deutsch)"
	@echo "  clean            - Clean the project"
	@echo "  test             - Run tests"
	@echo "  build            - Build the project"
	@echo ""
	@echo "Examples:"
	@echo "  make add-language LANG_CODE=de LANG_NAME=German NATIVE_NAME=Deutsch"
	@echo "  make generate-l10n"
	@echo "  make check-l10n"

# Install dependencies
install:
	@echo "Installing dependencies..."
	flutter pub get
	@echo "Dependencies installed"

# Generate localization files
generate-l10n:
	@echo "Generating localization files..."
	flutter packages pub run build_runner build --delete-conflicting-outputs
	@echo "Localization files generated"

# Check localization consistency
check-l10n:
	@echo "Checking localization consistency..."
	./scripts/check_l10n_consistency.sh

# Add a new language
add-language:
	@if [ -z "$(LANG_CODE)" ] || [ -z "$(LANG_NAME)" ] || [ -z "$(NATIVE_NAME)" ]; then \
		echo "Error: Please provide LANG_CODE, LANG_NAME and NATIVE_NAME"; \
		echo ""; \
		echo "Example:"; \
		echo "  make add-language LANG_CODE=de LANG_NAME=German NATIVE_NAME=Deutsch"; \
		exit 1; \
	fi
	@echo "🌍 Adding language: $(LANG_NAME) ($(NATIVE_NAME)) with code '$(LANG_CODE)'"
	./scripts/add_language.sh $(LANG_CODE) "$(LANG_NAME)" "$(NATIVE_NAME)"

# Clean the project
clean:
	@echo "Cleaning project..."
	flutter clean
	flutter pub get
	@echo "Project cleaned"

# Run tests
test:
	@echo "Running tests..."
	flutter test
	@echo "Tests completed"

# Build the project
build:
	@echo "Building project..."
	flutter build apk --release
	@echo "Project built"

# Build for iOS
build-ios:
	@echo "Building for iOS..."
	flutter build ios --release
	@echo "iOS project built"

# Run the project
run:
	@echo "Running project..."
	flutter run

# Analyze code
analyze:
	@echo "Running static analysis..."
	flutter analyze
	@echo "Analysis completed"

# Format code
format:
	@echo "Formatting code..."
	dart format .
	@echo "Code formatted"

# Full check (analysis + tests + localization)
check: analyze check-l10n test
	@echo "All checks passed"

# Quick setup for new developers
setup: install generate-l10n
	@echo "Project is ready for development!"
	@echo ""
	@echo "Next steps:"
	@echo "  1. make run    - run the app"
	@echo "  2. make check  - verify code and tests"
	@echo "  3. make add-language LANG_CODE=de LANG_NAME=German NATIVE_NAME=Deutsch - add a new language"