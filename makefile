
linux:
	@echo "Building for Linux..."
	@mkdir -p build
	@cp -r src/* build
	@rm -f build/nimlings.nim 
	@nimble build
	@mv nimlings build
	@rm -f build/exercises.nim


windows:
	@echo "Building for Windows..."
	@mkdir build
	@xcopy /s src\* build
	@del /Q build\nimlings.nim 
	@nimble build
	@move nimlings build
	@del /Q build\exercises.nim

.PHONY: linux windows
