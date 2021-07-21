function Button(_parent, _x, _y, _width, _height, _text) constructor {
    parent = _parent;
    xx = _x;
    yy = _y;
    right = _x + _width - 1;
    bottom = _y + _height - 1;
    font = MIDDLE_FONT;
    text = _text;
    
    brushColor = $e1e1e1;
    penColor = $adadad;
    
    onClick = pointer_null;
    
    if (_parent != pointer_null) {
        _parent.addChild(self);
    }
    
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
        if (onClick != pointer_null) {
            onClick();
        }
    };
    
    static draw = function () {
        draw_set_color(brushColor);
        draw_rectangle(xx, yy, right, bottom, false);
        draw_set_color(c_black);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_font(font);
        draw_text(round((xx + right) / 2), round((yy + bottom) / 2), text);
        draw_set_color(penColor);
        draw_rectangle(xx + 1, yy + 1, right - 1, bottom - 1, true);
        
        draw_set_color(c_black);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    };
}