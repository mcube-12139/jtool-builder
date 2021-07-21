function FileInput(_parent, _x, _y, _width, _height, _filter) constructor {
    parent = _parent;
    xx = _x;
    yy = _y;
    right = _x + _width - 1;
    bottom = _y + _height - 1;
    width = _width;
    height = _height;
    filter = _filter;
    font = MIDDLE_FONT;
    filePath = "";
    
    surface = surface_create(width, height);
    
    brushColor = $e1e1e1;
    penColor = $adadad;
    
    if (_parent != pointer_null) {
        _parent.addChild(self);
    }
    
    onChange = pointer_null;
    static mouseEnabled = true;
    static keyboardEnabled = false;
    
    static onGetFocus = pointer_null;
    static onLoseFocus = pointer_null;
    
    static onMouseEnter = function (_x, _y) {
        brushColor = $fbf1e5;
        penColor = $d77800;
    };
    
    static onMouseLeave = function (_x, _y) {
        brushColor = $e1e1e1;
        penColor = $adadad;
    };
    
    static onMouseDown = function (_x, _y) {
        var path = get_open_filename_ext(filter, "", "", "打开文件");
        
        if (path != "") {
            filePath = path;
            if (onChange != pointer_null) {
                onChange(self);
            }
        }
    };
    
    static draw = function () {
        if (!surface_exists(surface)) {
            surface = surface_create(width, height);
        }
        
        surface_set_target(surface);
        
        draw_clear(brushColor);
        draw_set_valign(fa_middle);
        draw_set_font(font);
        draw_text(2, height / 2, filePath);
        draw_set_color(penColor);
        draw_rectangle(1, 1, width - 2, height - 2, true);
        
        surface_reset_target();
        gpu_set_blendenable(false);
        draw_surface(surface, xx, yy);
        gpu_set_blendenable(true);
        
        draw_set_color(c_black);
        draw_set_valign(fa_top);
    };
}