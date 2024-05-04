
linux:
	@echo "Building for Linux..."
	@mkdir -p build
	@cp -r src/* build
	@rm -f build/nimlings.nim 
	@nimble build
	@mv nimlings build
	@rm -f build/exercises.nim


.PHONY: linux windows
