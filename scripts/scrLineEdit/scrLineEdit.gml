function LineEdit(_parent, _x, _y, _width, _height) constructor {
    parent = _parent;
    xx = _x;
    yy = _y;
    right = _x + _width - 1;
    bottom = _y + _height - 1;
    width = _width;
    height = _height;
    font = MIDDLE_FONT;
    text = "";
    surface = surface_create(_width, _height);
    
    onChange = pointer_null;
    
    if (_parent != pointer_null) {
        _parent.addChild(self);
    }
    
    static mouseEnabled = true;
    static keyboardEnabled = true;
    
    static onMouseEnter = pointer_null;
    static onMouseLeave = pointer_null;
    static onMouseDown = pointer_null;
    
    static onGetFocus = function () {
        ui_edit_show_cursor();
        draw_set_font(font);
        global.uiEditCursorIndex = string_length(text) + 1;
        global.uiEditCursorX = 4 + string_width(text);
    };
    
    static onLoseFocus = function () {
        if (onChange != pointer_null) {
            onChange(self);
        }
    };
    
    static onKeyDown = function (key) {
        draw_set_font(font);
        if (key == vk_backspace) {
            // delete
            ui_edit_show_cursor();
            if (global.uiEditCursorIndex > 1) {
                --global.uiEditCursorIndex;
                global.uiEditCursorX -= string_width(string_char_at(text, global.uiEditCursorIndex));
                text = string_delete(text, global.uiEditCursorIndex, 1);
            }
        } else if (key == vk_left) {
            // move left
            ui_edit_show_cursor();
            if (global.uiEditCursorIndex > 1) {
                --global.uiEditCursorIndex;
                global.uiEditCursorX -= string_width(string_char_at(text, global.uiEditCursorIndex));
            }
        } else if (key == vk_right) {
            // move right
            ui_edit_show_cursor();
            if (global.uiEditCursorIndex <= string_length(text)) {
                global.uiEditCursorX += string_width(string_char_at(text, global.uiEditCursorIndex));
                ++global.uiEditCursorIndex;
            }
        }
    };
    
    static onInputString = function (str) {
        ui_edit_show_cursor();
        draw_set_font(font);
        text = string_insert(str, text, global.uiEditCursorIndex);
        global.uiEditCursorIndex += string_length(str);
        global.uiEditCursorX += string_width(str);
    };
    
    static draw = function () {
        // ensure surface
        if (!surface_exists(surface)) {
            surface = surface_create(width, height);
        }
        
        surface_set_target(surface);
        
        // draw background
        draw_clear(c_white);
        draw_set_color(c_black);
        draw_set_valign(fa_middle);
        draw_set_font(font);
        
        // draw text
        draw_text(4, height / 2, text);
        
        if (global.uiFocused == self) {
            // is selected
            
            if (global.uiEditCursorVisible) {
                // draw cursor
                var cursorX = global.uiEditCursorX;
                draw_rectangle(cursorX, 2, cursorX, height - 3, false);
            }
        }
        draw_rectangle(1, 1, width - 2, height - 2, true);
        draw_set_valign(fa_top);
        
        surface_reset_target();
        
        // draw surface
        gpu_set_blendenable(false);
        draw_surface(surface, xx, yy);
        gpu_set_blendenable(true);
    };
}

function ui_edit_show_cursor() {
    // show cursor
    global.uiEditCursorVisible = true;
    global.uiEditFlashTime = 25;
}