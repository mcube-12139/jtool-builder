function create_ui_objects() {
    // root window
    global.rootWindow = new Window(true, 0, 0, 1024, 576, pointer_null);

    // map
    global.mapLabel = new Label(global.rootWindow, 16, 32, "地图：", fa_left, fa_bottom);
    global.mapListView = new ListView(global.rootWindow, 16, 40, 256, 256, 24);
    global.mapDirectoryLabel = new Label(global.rootWindow, 16, 328, "目录：", fa_left, fa_bottom);
    global.mapDirectoryInput = new DirectoryInput(global.rootWindow, 16, 336, 256, 24);
    global.mapDirectoryInput.onChange = function (directoryInput) {
        global.mapDirectory = directoryInput.directory;
    
        var mask = directoryInput.directory + "/*.*";
        global.mapNames = [];
        for (var fileName = file_find_first(mask, 0); fileName != ""; fileName = file_find_next()) {
            if (fileName != "." && fileName != "..") {
                array_push(global.mapNames, fileName);
            }
        }
        global.mapListView.options = global.mapNames;
    };
    
    // skin
    global.skinLabel = new Label(global.rootWindow, 280, 32, "皮肤：", fa_left, fa_bottom);
    global.skinListView = new ListView(global.rootWindow, 280, 40, 256, 256, 24);
    global.skinFileLabel = new Label(global.rootWindow, 280, 328, "文件：", fa_left, fa_bottom);
    global.skinFileInput = new FileInput(global.rootWindow, 280, 336, 256, 24, "INI文件(*.ini)|*.ini");
    global.skinFileInput.onChange = function (fileInput) {
        var iniFile = file_text_open_read(fileInput.filePath);
    
        file_text_readln(iniFile);
        var namesLine = file_text_read_string(iniFile);
        var equalIndex = string_pos("=", namesLine);
        if (equalIndex != 0) {
            var namesString = string_copy(namesLine, equalIndex + 1, string_length(namesLine) - equalIndex);
            var names = string_split(namesString, ",");
            global.skinNames = names;
            global.skinListView.options = global.skinNames;
        } else {
            show_message("错误：文件内容格式不正确。");
        }
    
        file_text_close(iniFile);
    };
    global.skinDirectoryLabel = new Label(global.rootWindow, 280, 384, "目录：", fa_left, fa_bottom);
    global.skinDirectoryInput = new DirectoryInput(global.rootWindow, 280, 392, 256, 24);
    global.skinDirectoryInput.onChange = function (directoryInput) {
        global.skinDirectory = directoryInput.directory;
    };

    // music
    global.musicLabel = new Label(global.rootWindow, 544, 32, "音乐：", fa_left, fa_bottom);
    global.musicListView = new ListView(global.rootWindow, 544, 40, 256, 256, 24);
    global.musicDirectoryLabel = new Label(global.rootWindow, 544, 328, "目录：", fa_left, fa_bottom);
    global.musicDirectoryInput = new DirectoryInput(global.rootWindow, 544, 336, 256, 24);
    global.musicDirectoryInput.onChange = function (directoryInput) {
        global.musicDirectory = directoryInput.directory;
    
        var mask = directoryInput.directory + "/*.*";
        global.musicNames = [];
        for (var fileName = file_find_first(mask, 0); fileName != ""; fileName = file_find_next()) {
            if (fileName != "." && fileName != "..") {
                array_push(global.musicNames, fileName);
            }
        }
        global.musicListView.options = global.musicNames;
    };
    
    // game name
    global.gameNameLabel = new Label(global.rootWindow, 80, 444, "游戏名：", fa_right, fa_middle);
    global.gameNameLineEdit = new LineEdit(global.rootWindow, 80, 432, 288, 24);
    global.gameNameLineEdit.onChange = function (lineEdit) {
        global.gameName = lineEdit.text;
    };
    
    // title image
    global.titleImageLabel = new Label(global.rootWindow, 96, 476, "封面文件：", fa_right, fa_middle);
    global.titleImageFileInput = new FileInput(global.rootWindow, 96, 464, 288, 24, "PNG文件(*.png)|*.png");
    global.titleImageFileInput.onChange = function (fileInput) {
        global.titleImageFilePath = fileInput.filePath;
    };
    
    // map info
    global.mapInfoLabel = new Label(global.rootWindow, 96, 508, "地图属性：", fa_right, fa_middle);
    global.mapInfoFileInput = new FileInput(global.rootWindow, 96, 496, 288, 24, "文本文件(*.txt)|*.txt");
    global.mapInfoFileInput.onChange = function (fileInput) {
        global.mapInfoFilePath = fileInput.filePath;
    };
    
    // build directory
    global.buildDirectoryLabel = new Label(global.rootWindow, 592, 444, "输出目录：", fa_right, fa_middle);
    global.buildDirectoryInput = new DirectoryInput(global.rootWindow, 592, 432, 288, 24);
    global.buildDirectoryInput.onChange = function (directoryInput) {
        if (string_begin_with(directoryInput.directory, global.exeDirectory)) {
            show_message("不能选择exe目录或其下的子目录。");
        } else {
            global.buildDirectory = directoryInput.directory;
        }
    };
    
    // build
    global.buildButton = new Button(global.rootWindow, 452, 536, 120, 32, "生成");
    global.buildButton.font = LARGE_FONT;
    global.buildButton.onClick = function (_x, _y) {
        if (show_question("确定生成游戏？")) {
            game_build();
        }
    };
}

function string_begin_with(str, beginning) {
    var length = string_length(str);
    var beginningLength = string_length(beginning);
    
    if (length < beginningLength) {
        return false;
    }
    
    return string_copy(str, 1, beginningLength) == beginning;
}

function string_split(str, sepChar) {
    var result = [];
    var length = string_length(str);
    
    var lastIndex = 1;
    for (var i = 1; ; ++i) {
        var char;
        if (i != length + 1) {
            char = string_char_at(str, i);
        }
        if (i == length + 1 || char == sepChar) {
            array_push(result, string_copy(str, lastIndex, i - lastIndex));
            lastIndex = i + 1;
        }
        if (i == length + 1) {
            break;
        }
    }
    
    return result;
}

function string_copy_after_colon(str) {
    var colonIndex = string_pos(":", str);
    if (colonIndex == 0) {
        throw pointer_null;
    }
    
    return string_copy(str, colonIndex + 1, string_length(str) - colonIndex);
}

function string_encode_real(n) {
    if (n == 0) {
        return string_repeat(chr(0), 8);
    }
    var byte = [];
    byte[0] = 0;
    byte[7] = 0;
    if (n < 0) {
        n = -n;
        byte[7] |= $80;
    }
    var e = floor(log2(n));
    var m = n / power(2, e) - 1;
    e += 1023;
    
    for (var i = 0; i != 11; ++i) {
        if (i < 4) {
            byte[6] |= (e & (1 << i)) << 4;
        } else {
            byte[7] |= (e & (1 << i)) >> 4;
        }
    }
    for (var i = 51; i != -1; --i) {
        m *= 2;
        if (m >= 1) {
            byte[i div 8] |= 1 << (i mod 8);
            --m;
        }
    }
    var result = "";
    for (var i = 7; i != -1; --i) {
        for (var j = 0; j != 8; ++j) {
            result += (byte[i] & (128 >> j)) != 0 ? "1" : "0";
        }
    }
    
    return result;
}

function bin_string_to_num(bin) {
    var result = 0;
    var length = string_length(bin);
    for (var i = 1; i <= length; ++i) {
        result = result << 1;
        if (string_char_at(bin, i) == "1") {
            result |= 1;
        }
    }
    
    return result;
}

function base32_encode_int(n) {
    var base32String = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@";
    var result = "";
    
    while (n > 0) {
        var decimal = n / 32;
        n = floor(decimal);
        var index = (decimal - n) * 32;
        result = string_char_at(base32String, index + 1) + result;
    }
    
    return result;
}

function game_build() {
    var mapIndexMap = ds_map_create();
    var skinIndexMap = ds_map_create();
    var musicIndexMap = ds_map_create();
    
    var mapNameLength = array_length(global.mapNames);
    var skinNameLength = array_length(global.skinNames);
    var musicNameLength = array_length(global.musicNames);
    var mapUsed = array_create(mapNameLength, false);
    var skinUsed = array_create(skinNameLength, false);
    var musicUsed = array_create(musicNameLength, false);
    
    var dirName = global.buildDirectory + "/" + global.gameName;
    var gamePath = dirName + "/";
    var binaryPath = program_directory + "/bin/";
    // var binaryPath = "";
    
    try {
        // check build directory
        if (global.buildDirectory == "") {
            throw "输出目录未设置。";
        }
        
        // check game name
        if (global.gameName == "") {
            throw "游戏名未设置。";
        }
        
        // check title image
        if (global.titleImageFilePath != "" && !file_exists(global.titleImageFilePath)) {
            throw "封面文件不存在。";
        }
        
        if (global.mapInfoFilePath != "" && !file_exists(global.mapInfoFilePath)) {
            throw "地图属性文件不存在。";
        }
        
        // check runner
        if (!file_exists(binaryPath + "runner.exe")) {
            throw "Runner程序不存在，本工具可能已损坏。";
        }
        if (!file_exists(binaryPath + "data.win")) {
            throw "Runner程序不存在，本工具可能已损坏。";
        }
        if (!file_exists(binaryPath + "options.ini")) {
            throw "Runner程序不存在，本工具可能已损坏。";
        }
        
        // check used resource
        for (var i = 0, sz = mapNameLength; i != sz; ++i) {
            var mapName = global.mapNames[i];
            mapIndexMap[? mapName] = i;
        }
    
        for (var i = 0, sz = skinNameLength; i != sz; ++i) {
            var skinName = global.skinNames[i];
            skinIndexMap[? skinName] = i;
        }
    
        for (var i = 0, sz = musicNameLength; i != sz; ++i) {
            var musicName = global.musicNames[i];
            musicIndexMap[? musicName] = i;
        }
        
        // check map info
        if (global.mapInfoFilePath != "") {
            var mapInfoFile = file_text_open_read(global.mapInfoFilePath);
            
            try {
                while (!file_text_eof(mapInfoFile)) {
                    var mapInfoString = file_text_read_string(mapInfoFile);
                    file_text_readln(mapInfoFile);
                    
                    var mapInfoStrings = string_split(mapInfoString, "|");
                    if (array_length(mapInfoStrings) != 3) {
                        throw "地图属性" + mapInfoString + "行格式错误。";
                    }
                    
                    // check map
                    var mapName = mapInfoStrings[0];
                    if (mapName == "") {
                        throw "地图属性" + mapInfoString + "行格式错误。";
                    }
                    var notTitleMap = mapName != "?title";
                    if (notTitleMap) {
                        if (string_pos(".", mapName) == 0) {
                            mapName += ".jmap";
                        }
                        if (!ds_map_exists(mapIndexMap, mapName)) {
                            throw "地图属性中的地图" + mapName + "不存在。";
                        }
                        var mapIndex = mapIndexMap[? mapName];
                        mapUsed[mapIndex] = true;
                    }
                    
                    // check skin
                    var skinName = mapInfoStrings[1];
                    if (skinName != "") {
                        if (!ds_map_exists(skinIndexMap, skinName)) {
                            throw "地图属性中的皮肤" + skinName + "不存在。";
                        }
                        var skinIndex = skinIndexMap[? skinName];
                        skinUsed[skinIndex] = true;
                    }
                    
                    // check music
                    var musicName = mapInfoStrings[2];
                    if (musicName != "") {
                        if (string_pos(".", musicName) == 0) {
                            musicName += ".ogg";
                        }
                        if (!ds_map_exists(musicIndexMap, musicName)) {
                            throw "地图属性中的音乐" + musicName + "不存在。";
                        }
                        var musicIndex = musicIndexMap[? musicName];
                        musicUsed[musicIndex] = true;
                    }
                    
                    var mapInfo = new MapInfo(mapName, skinName, musicName);
                    if (notTitleMap) {
                        // not title
                        // add map info
                        array_push(global.mapInfos, mapInfo);
                    } else {
                        // title
                        global.titleMapInfo = mapInfo;
                    }
                }
            } catch (e) {
                throw e;
            } finally {
                file_text_close(mapInfoFile);
            }
        }
        
        for (var i = 0, sz = array_length(global.mapInfos); i != sz; ++i) {
            var mapInfo = global.mapInfos[i];
            var mapName = mapInfo.mapName;
            var skinName = mapInfo.skinName;
            var musicName = mapInfo.musicName;
        
            if (!file_exists(global.mapDirectory + "/" + mapName)) {
                throw "地图" + mapName + "不存在。";
            }
            
            if (skinName != "" && !directory_exists(global.skinDirectory + "/" + skinName)) {
                throw "皮肤" + skinName + "不存在。";
            }
            
            if (musicName != "" && !file_exists(global.musicDirectory + "/" + musicName)) {
                throw "音乐" + musicName + "不存在。";
            }
            
            var mapIndex = mapIndexMap[? mapName];
            mapUsed[mapIndex] = true;
            if (skinName != "") {
                var skinIndex = skinIndexMap[? skinName];
                skinUsed[skinIndex] = true;
            }
            if (musicName != "") {
                var musicIndex = musicIndexMap[? musicName];
                musicUsed[musicIndex] = true;
            }
        }
        
        // create game directory
        directory_create(dirName);
        if (!directory_exists(dirName)) {
            throw "目录创建失败，游戏名可能不合法。";
        }
    } catch (e) {
        show_message(e);
        ds_map_destroy(mapIndexMap);
        ds_map_destroy(skinIndexMap);
        ds_map_destroy(musicIndexMap);
        
        return;
    }
    
    // calculate used resource
    var usedSkins = [];
    var usedMusics = [];
    ds_map_clear(skinIndexMap);
    ds_map_clear(musicIndexMap);
    for (var i = 0, j = 0, sz = array_length(global.skinNames); i != sz; ++i) {
        if (skinUsed[i]) {
            var skinName = global.skinNames[i];
            
            array_push(usedSkins, skinName);
            skinIndexMap[? skinName] = j;
            ++j;
        }
    }
    for (var i = 0, j = 0, sz = array_length(global.musicNames); i != sz; ++i) {
        if (musicUsed[i]) {
            var musicName = global.musicNames[i];
            
            array_push(usedMusics, musicName);
            musicIndexMap[? musicName] = j;
            ++j;
        }
    }
    
    // copy exe
    file_copy(binaryPath + "runner.exe", gamePath + global.gameName + ".exe");
    file_copy(binaryPath + "data.win", gamePath + "data.win");
    file_copy(binaryPath + "options.ini", gamePath + "options.ini");
    
    // create resource directory
    directory_create(gamePath + "resource");
    
    // create map, skin, and music directory
    var resourcePath = gamePath + "resource/";
    var skinDirectory = resourcePath + "skin";
    var musicDirectory = resourcePath + "music";
    directory_create(skinDirectory);
    directory_create(musicDirectory);
    var skinPath = skinDirectory + "/";
    var musicPath = musicDirectory + "/";
    
    // copy title image
    if (global.titleImageFilePath != "") {
        file_copy(global.titleImageFilePath, resourcePath + "title-image.png");
    }
    
    var dataFile = file_text_open_write(resourcePath + "data");
    
    // write game name
    file_text_write_string(dataFile, global.gameName);
    file_text_writeln(dataFile);
    
    // write title map info
    var titleSkinIndex = global.titleMapInfo != pointer_null ? skinIndexMap[? global.titleMapInfo.skinName] : -1;
    var titleMusicIndex = global.titleMapInfo != pointer_null ? musicIndexMap[? global.titleMapInfo.musicName] : -1;
    file_text_write_real(dataFile, titleSkinIndex);
    file_text_writeln(dataFile);
    file_text_write_real(dataFile, titleMusicIndex);
    file_text_writeln(dataFile);
    
    try {
        // write skin data
        skinNameLength = array_length(usedSkins);
        file_text_write_real(dataFile, skinNameLength);
        file_text_writeln(dataFile);
        for (var i = 0, sz = skinNameLength; i != sz; ++i) {
            var skinName = usedSkins[i];
        
            file_text_write_string(dataFile, skinName);
            file_text_writeln(dataFile);
            
            // copy files
            directory_create(skinPath + skinName);
            var srcSkinNamePath = global.skinDirectory + "/" + skinName + "/";
            var dstSkinNamePath = skinPath + skinName + "/";
            var skinFileMask = srcSkinNamePath + "*.*";
            
            var unusedSkinFileMap = ds_map_create();
            unusedSkinFileMap[? "sidebar.png"] = pointer_null;
            unusedSkinFileMap[? "menu.png"] = pointer_null;
            unusedSkinFileMap[? "playerstart.png"] = pointer_null;
            unusedSkinFileMap[? "popup.png"] = pointer_null;
            
            for (var fileName = file_find_first(skinFileMask, 0); fileName != ""; fileName = file_find_next()) {
                if (fileName != "." && fileName != ".." && !ds_map_exists(unusedSkinFileMap, fileName)) {
                    file_copy(srcSkinNamePath + fileName, dstSkinNamePath + fileName);
                }
            }
            ds_map_destroy(unusedSkinFileMap);
        }
    
        // write music data
        musicNameLength = array_length(usedMusics);
        file_text_write_real(dataFile, musicNameLength);
        file_text_writeln(dataFile);
        for (var i = 0, sz = musicNameLength; i != sz; ++i) {
            var musicName = usedMusics[i];
        
            file_text_write_string(dataFile, musicName);
            file_text_writeln(dataFile);
        
            file_copy(global.musicDirectory + "/" + musicName, musicPath + musicName);
        }
    
        // write map data
        mapNameLength = array_length(global.mapInfos);
        file_text_write_real(dataFile, mapNameLength);
        file_text_writeln(dataFile);
        for (var i = 0, sz = mapNameLength; i != sz; ++i) {
            var mapInfo = global.mapInfos[i];
            var mapName = mapInfo.mapName;
            var mapSkinName = mapInfo.skinName;
            var mapMusicName = mapInfo.musicName;
            
            var mapSkinIndex = mapSkinName == "" ? -1 : skinIndexMap[? mapSkinName];
            var mapMusicIndex = mapMusicName == "" ? -1 : musicIndexMap[? mapMusicName];
            
            var mapData = jmap_load(global.mapDirectory + "/" + mapName);
            file_text_write_real(dataFile, variable_struct_exists(mapData, "inf") ? mapData.inf : false);
            file_text_writeln(dataFile);
            file_text_write_real(dataFile, variable_struct_exists(mapData, "dot") ? mapData.dot : false);
            file_text_writeln(dataFile);
            file_text_write_real(dataFile, variable_struct_exists(mapData, "sav") ? mapData.sav : 0);
            file_text_writeln(dataFile);
            file_text_write_real(dataFile, variable_struct_exists(mapData, "bor") ? mapData.bor : 0);
            file_text_writeln(dataFile);
            file_text_write_string(dataFile, variable_struct_exists(mapData, "objects") ? mapData.objects : "");
            file_text_writeln(dataFile);
            
            file_text_write_real(dataFile, mapSkinIndex);
            file_text_writeln(dataFile);
            file_text_write_real(dataFile, mapMusicIndex);
            file_text_writeln(dataFile);
        }
    } catch (e) {
        show_message(e);
    } finally {
        file_text_close(dataFile);
    }
}