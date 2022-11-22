add_rules("mode.debug", "mode.release")
local lib_src = path.join(os.projectdir(),"Import")

local function check_gacui_src(is_no_flection)
    set_languages("c++20")
    add_files(path.join(lib_src,"**.cpp"))
    add_headerfiles(path.join(lib_src,"**.h"))
    add_includedirs(lib_src,{public = true})
    add_defines( "UNICODE", "_UNICODE")
    add_cxflags("/execution-charset:utf-8")
    set_group("libgacui")

    if is_no_flection then
        add_defines("VCZH_DEBUG_NO_REFLECTION")
        remove_files(path.join(lib_src,"VlppWorkflowRuntime.cpp"))
        remove_headerfiles(path.join(lib_src,"VlppWorkflowRuntime.h"))
        remove_files(path.join(lib_src,"GacUIReflection.cpp"))
        remove_headerfiles(path.join(lib_src,"GacUIReflection.h"))
        remove_files(path.join(lib_src,"Skins","DarkSkin","DarkSkinReflection.cpp"))
        remove_headerfiles(path.join(lib_src,"Skins","DarkSkin","DarkSkinReflection.h"))
    end

    on_load(function(target)

        target:remove("files",path.join(lib_src,"GacUICompiler.cpp"))
        target:remove("files",path.join(lib_src,"VlppWorkflowCompiler.cpp"))
        target:remove("headerfiles",path.join(lib_src,"GacUICompiler.h"))
        target:remove("headerfiles",path.join(lib_src,"VlppWorkflowCompiler.h"))
        if is_plat("windows") then
            target:remove("files",path.join(lib_src,"Vlpp.Linux.cpp"))
            target:remove("files",path.join(lib_src,"VlppOS.Linux.cpp"))
            target:add("cxflags","/bigobj")
            target:add("defines","WIN32","_WINDOWS",{public = true})
            target:add("ldflags", "/subsystem:windows",{public = true})
            target:add("syslinks","kernel32","user32","gdi32","comdlg32","ole32","advapi32")
        else
            target:remove("files",path.join(lib_src,"Vlpp.Windows.cpp"))
            target:remove("files",path.join(lib_src,"VlppOS.Windows.cpp"))
        end
    end)
end


target("GacUILite")
    set_kind("static")
    check_gacui_src(true)

target("GacUI")
    set_kind("static")
    check_gacui_src()

target("GacUIComplete")
    set_languages("c++20")
    add_deps("GacUI")
    set_kind("static")
    set_group("libgacui")
    add_files(path.join(lib_src,"GacUICompiler.cpp"))
    add_files(path.join(lib_src,"VlppWorkflowCompiler.cpp"))
    add_headerfiles(path.join(lib_src,"GacUICompiler.cpp"))
    add_headerfiles(path.join(lib_src,"VlppWorkflowCompiler.cpp"))
    on_load(function(target)
        if is_plat("windows") then
            target:add("cxflags","/bigobj")
        end
    end)
target_end()


--
-- If you want to known more usage about xmake, please see https://xmake.io
--
-- ## FAQ
--
-- You can enter the project directory firstly before building project.
--
--   $ cd projectdir
--
-- 1. How to build project?
--
--   $ xmake
--
-- 2. How to configure project?
--
--   $ xmake f -p [macosx|linux|iphoneos ..] -a [x86_64|i386|arm64 ..] -m [debug|release]
--
-- 3. Where is the build output directory?
--
--   The default output directory is `./build` and you can configure the output directory.
--
--   $ xmake f -o outputdir
--   $ xmake
--
-- 4. How to run and debug target after building project?
--
--   $ xmake run [targetname]
--   $ xmake run -d [targetname]
--
-- 5. How to install target to the system directory or other output directory?
--
--   $ xmake install
--   $ xmake install -o installdir
--
-- 6. Add some frequently-used compilation flags in xmake.lua
--
-- @code
--    -- add debug and release modes
--    add_rules("mode.debug", "mode.release")
--
--    -- add macro defination
--    add_defines("NDEBUG", "_GNU_SOURCE=1")
--
--    -- set warning all as error
--    set_warnings("all", "error")
--
--    -- set language: c99, c++11
--    set_languages("c99", "c++11")
--
--    -- set optimization: none, faster, fastest, smallest
--    set_optimize("fastest")
--
--    -- add include search directories
--    add_includedirs("/usr/include", "/usr/local/include")
--
--    -- add link libraries and search directories
--    add_links("tbox")
--    add_linkdirs("/usr/local/lib", "/usr/lib")
--
--    -- add system link libraries
--    add_syslinks("z", "pthread")
--
--    -- add compilation and link flags
--    add_cxflags("-stdnolib", "-fno-strict-aliasing")
--    add_ldflags("-L/usr/local/lib", "-lpthread", {force = true})
--
-- @endcode
--

