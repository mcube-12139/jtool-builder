function ListView(_parent, _x, _y, _width, _height, _lineHeight) constructor {
    parent = _parent;
    xx = _x;
    yy = _y;
    width = _width;
    height = _height;
    right = _x + _width - 1;
    bottom = _y + _height - 1;
    lineHeight = _lineHeight;
    surface = surface_create(_width, _height);
    font = MIDDLE_FONT;
    options = [];
    
    if (_parent != pointer_null) {
        _parent.addChild(self);
    }
    
    brushColor = $e1e1e1;
    penColor = $adadad;
    
    static mouseEnabled = false;
    static keyboardEnabled = false;
    
    static draw = function () {
        if (!surface_exists(surface)) {
            surface = surface_create(_width, _height);
        }
        
        surface_set_target(surface);
        
        draw_clear(brushColor);
        draw_set_valign(fa_middle);
        draw_set_font(font);
        var drawY = lineHeight / 2;
        for (var i = 0, sz = array_length(options); i != sz; ++i) {
            var option = options[i];
            
            draw_text(2, drawY, option);
            drawY += lineHeight;
        }
        draw_set_color(penColor);
        draw_rectangle(1, 1, width - 2, height - 2, true);
        
        surface_reset_target();
        gpu_set_blendenable(false);
        draw_surface(surface, xx, yy);
        gpu_set_blendenable(true);
        
        draw_set_valign(fa_top);
        draw_set_color(c_black);
    };
}