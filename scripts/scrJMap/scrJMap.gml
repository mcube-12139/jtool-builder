function jmap_load(path) {
    var result = {};
    var mapFile = file_text_open_read(path);
    
    var dataString = file_text_read_string(mapFile);
    
    try {
        if (!file_text_eof(mapFile)) {
            result.hasPlain = true;
        
            file_text_readln(mapFile);
            file_text_readln(mapFile);
            file_text_readln(mapFile);
            file_text_readln(mapFile);
        
            // read plain objects
            var plainObjects = [];
            var plainObjectsString = file_text_read_string(mapFile);
            var plainObjectsStrings = string_split(plainObjectsString, " ");
            for (var i = 0, sz = array_length(plainObjectsStrings) - 1; i != sz; ) {
                var objectX = real(plainObjectsStrings[i++]);
                var objectY = real(plainObjectsStrings[i++]);
                var objectID = real(plainObjectsStrings[i++]);
            
                array_push(plainObjects, {
                    x: objectX,
                    y: objectY,
                    id: objectID
                });
            }
            result.plainObjects = plainObjects;
            file_text_readln(mapFile);
        
            // read plain version
            var plainVersionString = file_text_read_string(mapFile);
            file_text_readln(mapFile);
            try {
                result.plainVersion = string_copy_after_colon(plainVersionString);
            } catch (e) {
                throw "明文version档案格式错误。";
            }
        
            // read plain infinite jump
            var plainInfJumpString = file_text_read_string(mapFile);
            file_text_readln(mapFile);
            try {
                result.plainInfiniteJump = real(string_copy_after_colon(plainInfJumpString));
            } catch (e) {
                throw "明文infinitejump档案格式错误。";
            }
        
            // read plain dot kid
            var plainDotKidString = file_text_read_string(mapFile);
            file_text_readln(mapFile);
            try {
                result.plainDotKid = real(string_copy_after_colon(plainDotKidString));
            } catch (e) {
                throw "明文dotkid档案格式错误。";
            }
        
            // read plain save type
            var plainSaveTypeString = file_text_read_string(mapFile);
            file_text_readln(mapFile);
            try {
                result.plainSaveType = real(string_copy_after_colon(plainSaveTypeString));
            } catch (e) {
                throw "明文savetype档案格式错误。";
            }
        
            // read plain border type
            var plainBorderTypeString = file_text_read_string(mapFile);
            file_text_readln(mapFile);
            try {
                result.plainBorderType = real(string_copy_after_colon(plainBorderTypeString));
            } catch (e) {
                throw "明文bordertype档案格式错误。";
            }
        
            // read plain player save x
            var plainPlayerSaveXString = file_text_read_string(mapFile);
            file_text_readln(mapFile);
            try {
                result.plainPlayerSaveX = real(string_copy_after_colon(plainPlayerSaveXString));
            } catch (e) {
                throw "明文playersavex档案格式错误。";
            }
        
            // read plain player save y
            var plainPlayerSaveYString = file_text_read_string(mapFile);
            file_text_readln(mapFile);
            try {
                result.plainPlayerSaveY = real(string_copy_after_colon(plainPlayerSaveYString));
            } catch (e) {
                throw "明文playersavey档案格式错误。";
            }
        
            // read plain player save x scale
            var plainPlayerSaveXScaleString = file_text_read_string(mapFile);
            file_text_readln(mapFile);
            try {
                result.plainPlayerSaveXScale = real(string_copy_after_colon(plainPlayerSaveXScaleString));
            } catch (e) {
                throw "明文playersavexscale档案格式错误。";
            }
        } else {
            result.hasPlain = false;
        }
    } catch (e) {
        throw e;
    } finally {
        file_text_close(mapFile);
    }
    
    var dataStrings = string_split(dataString, "|");
    result.version = dataStrings[1];
    var attrName;
    try {
        for (var i = 2, sz = array_length(dataStrings); i != sz; ++i) {
            var str = dataStrings[i];
            var colonIndex = string_pos(":", str);
            if (colonIndex == 0) {
                throw "第" + string(i) + "段档案格式错误。";
            }
            attrName = string_copy(str, 1, colonIndex - 1);
            var attrValue = string_copy(str, colonIndex + 1, string_length(str) - colonIndex);
            switch (attrName) {
            case "inf":
                result.inf = real(attrValue);
                break;
            case "dot":
                result.dot = real(attrValue);
                break;
            case "sav":
                result.sav = real(attrValue);
                break;
            case "bor":
                result.bor = real(attrValue);
                break;
            case "px":
                result.px = attrValue;
                break;
            case "py":
                result.py = attrValue;
                break;
            case "ps":
                result.ps = real(attrValue);
                break;
            case "pg":
                result.pg = real(attrValue);
                break;
            case "objects":
                result.objects = attrValue;
                break;
            }
        }
    } catch (e) {
        throw attrName + "档案格式错误。";
    }
    
    return result;
}