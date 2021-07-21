function ui_init() {
    global.uiFocusedIndex = -1;
    global.uiFocused = pointer_null;
    
    global.uiEditFlashTime = 30;
    global.uiEditCursorVisible = false;
    global.uiEditCursorIndex = 1;
    global.uiEditCursorX = 4;
    
    global.uiKeyHeldTime = -1;
    global.uiHeldKey = -1;
}

function ui_update() {
    // update flash time
    if (--global.uiEditFlashTime == 0) {
        global.uiEditFlashTime = 30;
        global.uiEditCursorVisible = !global.uiEditCursorVisible;
    }
    // update held time
    if (global.uiKeyHeldTime > 0) {
        --global.uiKeyHeldTime;
    }
    if (global.uiKeyHeldTime == 0) {
        ui_on_key_down(global.uiHeldKey);
    }
}

function ui_remove_object(_object) {
    // delete value
    for (var i = array_length(global.uiObjects) - 1; i != -1; --i) {
        var object = global.uiObjects[i];
        if (object == _object) {
            array_delete(global.uiObjects, i, 1);
            break;
        }
    }
    // reset focused
    var focusedIndex = -1;
    for (var i = 0, sz = array_length(global.uiObjects); i != sz; ++i) {
        var object = global.uiObjects[i];
        if (global.uiFocused == object) {
            focusedIndex = i;
            break;
        }
    }
    if (focusedIndex == -1) {
        global.uiFocused = pointer_null;
    }
    global.uiFocusedIndex = focusedIndex;
}

function ui_on_mouse_down(_x, _y) {
    if (_x >= global.topWindow.xx && _x <= global.topWindow.right && _y >= global.topWindow.yy && _y <= global.topWindow.bottom) {
        global.topWindow.onMouseDown(_x - global.topWindow.xx, _y - global.topWindow.yy);
    }
}

function ui_on_mouse_move(_x, _y) {
    if (_x >= global.topWindow.xx && _x <= global.topWindow.right && _y >= global.topWindow.yy && _y <= global.topWindow.bottom) {
        global.topWindow.onMouseMove(_x - global.topWindow.xx, _y - global.topWindow.yy);
    }
}

function ui_on_key_press(key) {
    global.uiKeyHeldTime = 30;
    global.uiHeldKey = key;
    ui_on_key_down(key);
}
        
function ui_on_key_down(key) {
    if (global.uiFocused != pointer_null && global.uiFocused.keyboardEnabled) {
        global.uiFocused.onKeyDown(key);
    }
}

function ui_on_key_release(key) {
    global.uiKeyHeldTime = -1;
    global.uiHeldKey = -1;
}

function ui_on_input_string(str) {
    if (global.uiFocused != pointer_null && global.uiFocused.keyboardEnabled) {
        global.uiFocused.onInputString(str);
    }
}