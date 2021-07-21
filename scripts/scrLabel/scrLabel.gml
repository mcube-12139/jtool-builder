function Label(_parent, _x, _y, _text, _halign, _valign) constructor {
    parent = _parent;
    xx = _x;
    yy = _y;
    font = MIDDLE_FONT;
    text = _text;
    halign = _halign;
    valign = _valign;
    
    if (_parent != pointer_null) {
        _parent.addChild(self);
    }
    
    static mouseEnabled = false;
    static keyboardEnabled = false;
    
    static draw = function () {
        draw_set_halign(halign);
        draw_set_valign(valign);
        draw_set_font(font);
        draw_text(xx, yy, text);
        
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    };
}