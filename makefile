BUILD_DIR = build

all: clean build

clean:
	@echo "Cleaning build directory..."
	@rm -rf $(BUILD_DIR)

build:
	@echo "Creating build directory..."
	@mkdir -p $(BUILD_DIR)
	@cp -r src/* $(BUILD_DIR)
	@rm $(BUILD_DIR)/nimlings.nim 
	@nimble build
	@mv nimlings $(BUILD_DIR)
	@rm build/exercises.nim

.PHONY: all clean build
