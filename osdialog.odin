package osdialog

import "core:c"
import "core:strings"

when ODIN_OS == .Windows {
	@(extra_linker_flags = "-lcomdlg32")
	foreign import osdialog {"osdialog.o", "osdialog_win.o"}
} else when ODIN_OS == .Darwin {
	@(extra_linker_flags = "-framework AppKit")
	foreign import osdialog {"osdialog.o", "osdialog_mac.o"}
} else {
	@(extra_linker_flags = "-DOSDIALOG_GTK3 $(pkg-config --cflags --libs gtk+-3.0)")
	foreign import osdialog {"osdialog.o", "osdialog_gtk3.o"}
}

@(private)
foreign osdialog {
	osdialog_message :: proc(level: c.int, buttons: c.int, message: cstring) -> c.int ---
	osdialog_prompt :: proc(level: c.int, message: cstring, text: cstring) -> cstring ---
	osdialog_color_picker :: proc(color: ^Color, opacity: c.int) -> c.int ---
	osdialog_file :: proc(action: c.int, path: cstring, filename: cstring, filters: ^Filters) -> cstring ---
}

MessageLevel :: enum {
	Info,
	Warning,
	Error,
}

MessageButtons :: enum {
	Ok,
	Ok_Cancel,
	Yes_No,
}

PathAction :: enum {
	Open,
	Open_Dir,
	Save,
}

Filters :: struct {}

Color :: struct {
	r: u8,
	g: u8,
	b: u8,
	a: u8,
}

message :: proc(message: string, level: MessageLevel = .Info, buttons: MessageButtons = .Ok) -> bool {
	c_message := strings.clone_to_cstring(message)
	defer delete(c_message)

	return osdialog_message(c.int(level), c.int(buttons), c_message) == 1
}

prompt :: proc(message: string, text: string = "", level: MessageLevel = .Info) -> (string, bool) #optional_ok {
	c_message, c_text := strings.clone_to_cstring(message), strings.clone_to_cstring(text)
	defer {delete(c_message);delete(c_text)}

	res := osdialog_prompt(c.int(level), c_message, c_text)
	if res == nil {
		return "", false
	}

	return string(res), true
}

path :: proc(action: PathAction, path: string = "", filename: string = "") -> (string, bool) #optional_ok {
	c_path, c_filename := strings.clone_to_cstring(filename), strings.clone_to_cstring(filename)
	defer {delete(c_path);delete(c_filename)}

	res := osdialog_file(c.int(action), c_path, c_filename, nil)
	if res == nil {
		return "", false
	}

	return string(res), true
}

color :: proc(color: Color = {255, 255, 255, 255}, opacity: bool = true) -> (Color, bool) #optional_ok {
	color := color
	if osdialog_color_picker(&color, c.int(opacity)) == 1 {
		return color, true
	}

	return color, false
}
