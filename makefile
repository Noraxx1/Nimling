
linux:
	@echo "Building for Linux..."
	@mkdir -p build
	@cp -r src/* build
	@rm -f build/nimlings.nim 
	@nimble build
	@mv nimlings build
	@rm -f build/exercises.nim


windows:
    @echo warning windows build is still instable.
    mkdir build
    xcopy /s /y src\*.nim build\
    nimble build
    move nimlings.exe build
    del /Q build\exercises.nim

.PHONY: linux windows
