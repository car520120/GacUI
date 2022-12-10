add_rules("mode.debug", "mode.release")
set_policy("build.across_targets_in_parallel", false)

local cc_src = path.join(os.projectdir(),"src","GacUI","Tools","GacGen","GacGen")
local cp_src = path.join(os.projectdir(),"src","VlppParser2","Tools","CodePack","CodePack")
local gp_src = path.join(os.projectdir(),"src","VlppParser2","Tools","GlrParserGen","GlrParserGen")
local cm_src = path.join(os.projectdir(),"src","Workflow","Tools","CppMerge","CppMerge")
local vl_src = path.join(os.projectdir(),"src","Vlpp","Release","IncludeOnly")
local ui_src = path.join(os.projectdir(),"src","GacUI","Release","IncludeOnly")
local vo_src = path.join(os.projectdir(),"src","VlppOS","Release","IncludeOnly")
local wf_src = path.join(os.projectdir(),"src","Workflow","Release","IncludeOnly")
local vr_src = path.join(os.projectdir(),"src","VlppRegex","Release","IncludeOnly")
local vp_src = path.join(os.projectdir(),"src","VlppParser","Release","IncludeOnly")
local v2_src = path.join(os.projectdir(),"src","VlppParser2","Release","IncludeOnly")
local vg_src = path.join(os.projectdir(),"src","VlppReflection","Release","IncludeOnly")

local function check_gacui_src(is_no_flection)
    set_languages("c++20")
    add_files(path.join(vl_src,"**.cpp"),{rules = {"CheckCodePack"}})
    add_files(path.join(ui_src,"**.cpp"),{rules = {"CheckCodePack"}})
    add_files(path.join(vp_src,"**.cpp"),{rules = {"CheckCodePack"}})
    add_files(path.join(v2_src,"**.cpp"),{rules = {"CheckCodePack"}})
    add_files(path.join(vr_src,"**.cpp"),{rules = {"CheckCodePack"}})
    add_files(path.join(vo_src,"**.cpp"),{rules = {"CheckCodePack"}})
    add_files(path.join(vg_src,"**.cpp"),{rules = {"CheckCodePack"}})
    add_headerfiles(path.join(vl_src,"**.h"))
    add_headerfiles(path.join(ui_src,"**.h"))
    add_headerfiles(path.join(vp_src,"**.h"))
    add_headerfiles(path.join(v2_src,"**.h"))
    add_headerfiles(path.join(vr_src,"**.h"))
    add_headerfiles(path.join(vo_src,"**.h"))
    add_headerfiles(path.join(vg_src,"**.h"))
    add_includedirs(vp_src,vr_src,vo_src,vg_src,{public = true})
    add_includedirs(vl_src,ui_src,wf_src,v2_src,{public = true})
    add_defines( "UNICODE", "_UNICODE")
    add_cxflags("/execution-charset:utf-8")
    set_group("libgacui")
    add_configfiles(path.join(ui_src,"DarkSkin*.h"),{copyonly = true,prefixdir = "config/Skins/DarkSkin"})
    add_includedirs("$(buildir)/config",{public = true})
    if is_no_flection then
        add_defines("VCZH_DEBUG_NO_REFLECTION")
        remove_files(path.join(ui_src,"GacUIReflection.cpp"))
        remove_headerfiles(path.join(ui_src,"GacUIReflection.h"))
        remove_files(path.join(ui_src,"DarkSkinReflection.cpp"))
        remove_headerfiles(path.join(ui_src,"DarkSkinReflection.h"))
    else
        add_files(path.join(wf_src,"VlppWorkflowRuntime.cpp"),{rules = {"CheckCodePack"}})
        add_headerfiles(path.join(wf_src,"VlppWorkflowRuntime.h"))
        add_files(path.join(wf_src,"VlppWorkflowLibrary.cpp"),{rules = {"CheckCodePack"}})
        add_headerfiles(path.join(wf_src,"VlppWorkflowLibrary.h"))
    end

    on_load(function(target)
        target:remove("files",path.join(ui_src,"GacUICompiler.cpp"))
        target:remove("headerfiles",path.join(ui_src,"GacUICompiler.h"))
        if is_plat("windows") then
            -- target:add("files","Tutorial/Lib/GacUI/WinMain.cpp")
            target:remove("files",path.join(vl_src,"Vlpp.Linux.cpp"))
            target:remove("files",path.join(vo_src,"VlppOS.Linux.cpp"))
            target:add("cxflags","/bigobj")
            -- target:add("defines","WIN32","_WINDOWS",{public = true})
            -- target:add("ldflags", "/subsystem:windows",{public = true})
            target:add("syslinks","kernel32","user32","gdi32","comdlg32","ole32","advapi32")
        else
            target:remove("files",path.join(vl_src,"Vlpp.Windows.cpp"))
            target:remove("files",path.join(vo_src,"VlppOS.Windows.cpp"))
        end
    end)
end

--[[
local token_fn = nil
local is_code_pack = false
local store_obj = {}
rule("StoreObjectToken")
    on_load(function (target, opt)
        local gendir = path.join(target:autogendir({root = true}), target:plat(), "codepack")
        local target_gendir = path.join(gendir, target:name())
        token_fn = path.join(target_gendir, "codepack_object.txt")
        if (not os.exists(token_fn)) then
            is_code_pack = true
            os.mkdir(target_gendir)
            return
        end
        local fo = io.open(token_fn, "r")
        for key in fo:lines() do
            store_obj[key] = 1
        end
    end)

    after_build(function (target)
        if not is_code_pack then
            for _,v in pairs(store_obj) do
                if 1 == v then
                    is_code_pack = true
                    break
                end
            end
            if not is_code_pack then
                return
            end
        end
        -- print("*****  " , token_fn)
        local fo = io.open(token_fn, "w")
        for key,v in pairs(store_obj) do
            if 2 == v then
                fo:write(key .. "\n")
            end
        end
        fo:close()
    end)

rule("CheckCodePack")
    after_build_files(function (target, sourcebatch, opt)
        for _, fn in ipairs(sourcebatch.sourcefiles) do
            local key = hash.md5(target:objectfile(fn)) .. " " .. fn 
            -- print("999999999999   " ,  file_hash.md5(target:objectfile(fn)))
            if not store_obj[key] then
                is_code_pack = true
            end
            store_obj[key] = 2
        end
    end)
]]


local base_ui_lite = "GacUILite"
local base_ui = "GacUI"
local base_ui_complete = "GacUIComplete"
if not use_base_code then
    base_ui_lite = "Base" .. base_ui_lite
    base_ui = "Base" .. base_ui
    base_ui_complete = "Base" .. base_ui_complete
end


target(base_ui_lite)
    set_kind("static")
    check_gacui_src(true)

target(base_ui)
    set_kind("static")
    check_gacui_src()

target(base_ui_complete)
    set_languages("c++20")
    add_deps(base_ui)
    set_kind("static")
    set_group("libgacui")
    add_defines( "UNICODE", "_UNICODE")
    add_cxflags("/execution-charset:utf-8")
    add_files(path.join(ui_src,"GacUICompiler.cpp"))
    add_files(path.join(wf_src,"VlppWorkflowCompiler.cpp"))
    add_headerfiles(path.join(ui_src,"GacUICompiler.h"))
    add_headerfiles(path.join(wf_src,"VlppWorkflowCompiler.h"))
    on_load(function(target)
        if is_plat("windows") then
            target:add("cxflags","/bigobj")
        end
    end)


target("CppMerge")
    set_languages("c++20")
    set_kind("binary")
    set_group("tools")
    add_deps(base_ui_complete)
    add_defines( "UNICODE", "_UNICODE")
    add_cxflags("/execution-charset:utf-8")
    add_files(path.join(cm_src,"Main.cpp"))


target("GacGen")
    set_languages("c++20")
    set_kind("binary")
    set_group("tools")
    add_deps(base_ui_complete)
    add_defines( "UNICODE", "_UNICODE")
    add_cxflags("/execution-charset:utf-8")
    add_files(path.join(cc_src,"**.cpp"))


target("GlrParserGen")
    set_languages("c++20")
    set_kind("binary")
    set_group("tools")
    add_deps(base_ui)
    add_defines( "UNICODE", "_UNICODE")
    add_cxflags("/execution-charset:utf-8")
    add_files(path.join(gp_src,"**.cpp"))


target("CodePack")
    set_languages("c++20")
    set_kind("binary")
    set_group("tools")
    add_deps(base_ui_complete)
    add_defines( "UNICODE", "_UNICODE")
    add_cxflags("/execution-charset:utf-8")
    add_files(path.join(cp_src,"**.cpp"))
--[[
    add_rules("StoreObjectToken")
    after_build(function (target)
        -- import("core.base.option")
        if not use_base_code and is_code_pack then
            local genfn = path.join(os.projectdir(),"src","*/Release/CodegenConfig.xml")
            for _, fn in ipairs(os.files(genfn)) do
                -- print(path.join("$(curdir)",fn))
                -- print(target:targetfile() .. "  " .. fn)
                os.exec(target:targetfile() .. " " .. fn)
            end
        end
    end)
]]

target("import")
    set_kind("phony")
    add_deps("CodePack")
    on_run(function(target)
        local code_dirs = {}
        local import = target:dep("CodePack")
        local genfn = path.join(os.projectdir(),"src","*/Release/CodegenConfig.xml")
        for _, fn in ipairs(os.files(genfn)) do
            -- print(path.join("$(curdir)",fn))
            -- print(target:targetfile() .. "  " .. fn)
            local dir = path.directory(fn)
            table.insert(code_dirs,dir)
            -- local gac_inc = path.join(dir,"**.h|IncludeOnly/*")
            -- local gac_cpp = path.join(dir,"**.cpp|IncludeOnly/*")
            -- os.rm(gac_inc)
            -- os.rm(gac_cpp)
            -- os.exec(import:targetfile() .. " " .. fn)
        end
        local target_dir = path.join(os.projectdir(),"Import")
        if os.exists(target_dir) then
            os.rm(path.join(target_dir,"**.h"))
            os.rm(path.join(target_dir,"**.cpp"))
        else
            os.mkdir(target_dir)
        end

        for _,dir in ipairs(code_dirs) do
            local gac_inc = path.join(dir,"**.h|IncludeOnly/*")
            local gac_cpp = path.join(dir,"**.cpp|IncludeOnly/*")
            os.cp(gac_inc,target_dir)
            os.cp(gac_cpp,target_dir)
        end
        local DarkSkinDir = path.join(target_dir,"Skins","DarkSkin")
        os.mv(path.join(target_dir,"DarkSkin*.h"),DarkSkinDir)
        os.mv(path.join(target_dir,"DarkSkin*.cpp"),DarkSkinDir)
    end)