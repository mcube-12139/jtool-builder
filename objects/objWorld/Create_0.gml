ui_init();
create_ui_objects();

global.exeDirectory = filename_dir(parameter_string(0));
global.gameName = "";
global.titleImageFilePath = "";
global.buildDirectory = "";

global.mapDirectory = "";
global.skinDirectory = "";
global.musicDirectory = "";
global.mapNames = [];
global.skinNames = [];
global.musicNames = [];

global.titleMapInfo = pointer_null;
global.mapInfos = [];

global.topWindow = global.rootWindow;

global.mouseXPrev = pointer_null;
global.mouseYPrev = pointer_null;

#macro MIDDLE_FONT fSimSun_12
#macro LARGE_FONT fSimHei_16