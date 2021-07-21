function Window(_isRoot, _x, _y, _width, _height, _caption) constructor {
    children = [];
    isRoot = _isRoot;
    xx = _x;
    yy = _y;
    width = _width;
    height = _height;
    right = _x + _width - 1;
    bottom = _y + _height - 1;
    caption = _caption;
    mouseOnClose = false;
    surface = -1;
    
    mouseObject = pointer_null;
    
    static addChild = function (_child) {
        array_push(children, _child);
    };
    
    static onMouseMove = function (_x, _y) {
        if (!isRoot) {
            mouseOnClose = _y < 24 && _x >= width - 48 && _x < width;
        }
        
        if (mouseObject != pointer_null) {
            if (_x < mouseObject.xx || _x > mouseObject.right || _y < mouseObject.yy || _y > mouseObject.bottom) {
                if (mouseObject.onMouseLeave != pointer_null) {
                    mouseObject.onMouseLeave(_x - mouseObject.xx, _y - mouseObject.yy);
                }
                mouseObject = pointer_null;
            }
        }
                    
        for (var i = 0, sz = array_length(children); i != sz; ++i) {
            var child = children[i];
            
            if (mouseObject != child) {
                if (child.mouseEnabled) {
                    if (_x >= child.xx && _x <= child.right && _y >= child.yy && _y <= child.bottom) {
                        mouseObject = child;
                        if (child.onMouseEnter != pointer_null) {
                            child.onMouseEnter(_x - child.xx, _y - child.yy);
                        }
                    }
                }
            }
        }
    };
    
    static onMouseDown = function (_x, _y) {
        if (!isRoot) {
            if (mouseOnClose) {
                close();
                return;
            }
        }
        
        var lastFocused = global.uiFocused;
        if (global.uiFocused != pointer_null) {
            if (_x < global.uiFocused.xx || _x > global.uiFocused.right || _y < global.uiFocused.yy || _y > global.uiFocused.bottom) {
                if (global.uiFocused.onLoseFocus != pointer_null) {
                    global.uiFocused.onLoseFocus();
                }
                global.uiFocused = pointer_null;
            }
        }
        
        for (var i = 0, sz = array_length(children); i != sz; ++i) {
            var child = children[i];
            
            if (child.mouseEnabled) {
                if (_x >= child.xx && _x <= child.right && _y >= child.yy && _y <= child.bottom) {
                    if (child != lastFocused) {
                        if (child.onGetFocus != pointer_null) {
                            child.onGetFocus();
                        }
                        global.uiFocused = child;
                    }
                    if (child.onMouseDown != pointer_null) {
                        child.onMouseDown(_x - child.xx, _y - child.yy);
                    }
                    break;
                }
            }
        }
    };
    
    static show = function () {
        if (global.uiFocused != pointer_null) {
            if (global.uiFocused.onLoseFocus != pointer_null) {
                global.uiFocused.onLoseFocus();
            }
        }
        global.topWindow = self;
    };
    
    static close = function () {
        if (global.uiFocused != pointer_null) {
            if (global.uiFocused.onLoseFocus != pointer_null) {
                global.uiFocused.onLoseFocus();
            }
        }
        global.topWindow = global.rootWindow;
    }
    
    static draw = function () {
        if (!isRoot) {
            if (!surface_exists(surface)) {
                surface = surface_create(width, height);
            }
            
            surface_set_target(surface);
            
            draw_set_color($f0f0f0);
            draw_rectangle(0, 24, width - 1, height - 1, false);
            
            draw_set_color(c_white);
            draw_rectangle(0, 0, width - 1, 23, false);
            if (mouseOnClose) {
                draw_set_color(c_red);
                draw_rectangle(width - 48, 0, width - 1, 23, false);
            }
            draw_set_color(c_black);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_font(MIDDLE_FONT);
            draw_text(width / 2, 12, caption);
            draw_text(width - 24, 12, "X")
            
            draw_set_color($707070);
            draw_rectangle(1, 1, width - 2, height - 2, true);
            draw_set_color(c_black);
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
        }
        for (var i = 0, sz = array_length(children); i != sz; ++i) {
            var child = children[i];
            
            child.draw();
        }
        if (!isRoot) {
            surface_reset_target();
            
            gpu_set_blendenable(false);
            draw_surface(surface, xx, yy);
            gpu_set_blendenable(true);
        }
    };
}