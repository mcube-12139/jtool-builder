ui_update();

if (mouse_x != global.mouseXPrev || mouse_y != global.mouseYPrev) {
    global.mouseXPrev = mouse_x;
    global.mouseYPrev = mouse_y;
    ui_on_mouse_move(mouse_x, mouse_y);
}

if (mouse_check_button_pressed(mb_left)) {
    ui_on_mouse_down(mouse_x, mouse_y);
}

if (keyboard_check_pressed(vk_anykey)) {
    ui_on_key_press(keyboard_key);
}

if (keyboard_check_released(vk_anykey)) {
    ui_on_key_release(keyboard_key);
}

if (keyboard_string != "") {
    ui_on_input_string(keyboard_string);
    keyboard_string = "";
}