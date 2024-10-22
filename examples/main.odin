package main

import osd "../"
import "core:fmt"

main :: proc() {
	osd.message("Hello, World!")

	input := osd.prompt("Give me some input")
	fmt.println("Input:", input)

	if color, ok := osd.color(); ok {
		fmt.println("Selected color", color)
	}

	if path, ok := osd.path(.Open); ok {
		fmt.println("Selected file:", path)
	}

	if path, ok := osd.path(.Open_Dir); ok {
		fmt.println("Selected dir", path)
	}

	if path, ok := osd.path(.Save); ok {
		fmt.println("Selected save path", path)
	}
}
