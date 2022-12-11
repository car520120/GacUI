
add_rules("mode.debug", "mode.release")
local lib_main = path.join(os.projectdir(),"Tutorial","Lib","GacUI","WinMain.cpp")
local lib_hello = path.join(os.projectdir(),"Tutorial","GacUI_HelloWorlds")

target("HelloWorlds_CPP")
    set_languages("c++20")
    set_kind("binary")
    add_deps("GacUI")
    add_files(lib_main)
    add_files(path.join(lib_hello,"Cpp","Main.cpp"))
    add_filegroups("src", {rootdir = path.join(os.projectdir(),"Tutorial") ,files = {"**.cpp","**.h"}})