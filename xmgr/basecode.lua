add_rules("mode.debug", "mode.release")
set_policy("build.across_targets_in_parallel", false)

local rf_src = path.join(os.projectdir(),"src","GacUI","Test","GacUISrc","Metadata_Generate")
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

local no_refection = 0
local no_compiler = 1
local gacui_full = 2

-- 0 no reflection 1 no compiler 2 gacui full
local function check_gacui_src(build_flag)
    set_languages("c++20")
    add_files(path.join(vl_src,"**.cpp"))
    add_files(path.join(ui_src,"**.cpp"))
    add_files(path.join(vp_src,"**.cpp"))
    add_files(path.join(v2_src,"**.cpp"))
    add_files(path.join(vr_src,"**.cpp"))
    add_files(path.join(vo_src,"**.cpp"))
    add_files(path.join(vg_src,"**.cpp"))
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
    add_filegroups("src", {rootdir = path.join(os.projectdir(),"src") ,files = {"**.cpp","**.h"}})
    add_configfiles(path.join(ui_src,"DarkSkin*.h"),{copyonly = true,prefixdir = "config/Skins/DarkSkin"})
    add_includedirs("$(buildir)/config",{public = true})
    if no_refection == build_flag then
        add_defines("VCZH_DEBUG_NO_REFLECTION")
        remove_files(path.join(ui_src,"GacUIReflection.cpp"))
        remove_headerfiles(path.join(ui_src,"GacUIReflection.h"))
        remove_files(path.join(ui_src,"DarkSkinReflection.cpp"))
        remove_headerfiles(path.join(ui_src,"DarkSkinReflection.h"))
    else
        add_files(path.join(wf_src,"VlppWorkflowRuntime.cpp"))
        add_headerfiles(path.join(wf_src,"VlppWorkflowRuntime.h"))
        add_files(path.join(wf_src,"VlppWorkflowLibrary.cpp"))
        add_headerfiles(path.join(wf_src,"VlppWorkflowLibrary.h"))
        if gacui_full == build_flag then
            add_files(path.join(wf_src,"VlppWorkflowCompiler.cpp"))
            add_headerfiles(path.join(wf_src,"VlppWorkflowCompiler.h"))
        end
    end

    on_load(function(target)
        if no_compiler >= build_flag then
            target:remove("files",path.join(ui_src,"GacUICompiler.cpp"))
            target:remove("headerfiles",path.join(ui_src,"GacUICompiler.h"))
        end
        if is_plat("windows") then
            target:remove("files",path.join(vl_src,"Vlpp.Linux.cpp"))
            target:remove("files",path.join(vo_src,"VlppOS.Linux.cpp"))
            target:add("cxflags","/bigobj")
            target:add("syslinks","kernel32","user32","gdi32","comdlg32","ole32","advapi32")
        else
            target:remove("files",path.join(vl_src,"Vlpp.Windows.cpp"))
            target:remove("files",path.join(vo_src,"VlppOS.Windows.cpp"))
        end
    end)
end

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
    set_group("libgacui")
    check_gacui_src(no_refection)

target(base_ui)
    set_kind("static")
    set_group("libgacui")
    check_gacui_src(no_compiler)

target(base_ui_complete)
    add_deps(base_ui)
    set_kind("static")
    set_group("libgacui")
    add_cxflags("/bigobj")
    add_files(path.join(ui_src,"GacUICompiler.cpp"))
    add_headerfiles(path.join(ui_src,"GacUICompiler.h"))
    add_files(path.join(wf_src,"VlppWorkflowCompiler.cpp"))
    add_headerfiles(path.join(wf_src,"VlppWorkflowCompiler.h"))
    add_filegroups("src", {rootdir = path.join(os.projectdir(),"src") ,files = {"**.cpp","**.h"}})

target("CppMerge")
    set_languages("c++20")
    set_kind("binary")
    set_group("tools")
    add_deps(base_ui_complete)
    add_defines( "UNICODE", "_UNICODE")
    add_cxflags("/execution-charset:utf-8")
    add_files(path.join(cm_src,"Main.cpp"))
    add_filegroups("src", {rootdir = cm_src ,files = {"**.cpp","**.h"}})

target("GacGen")
    set_languages("c++20")
    set_kind("binary")
    set_group("tools")
    check_gacui_src(gacui_full)
    add_defines( "UNICODE", "_UNICODE")
    add_cxflags("/execution-charset:utf-8")
    add_files(path.join(cc_src,"**.cpp"))
    add_defines("VCZH_DEBUG_METAONLY_REFLECTION")

target("GlrParserGen")
    set_languages("c++20")
    set_kind("binary")
    set_group("tools")
    add_deps(base_ui)
    add_defines( "UNICODE", "_UNICODE")
    add_cxflags("/execution-charset:utf-8")
    add_files(path.join(gp_src,"**.cpp"))
    add_filegroups("src", {rootdir = gp_src ,files = {"**.cpp","**.h"}})

target("CodePack")
    set_languages("c++20")
    set_kind("binary")
    set_group("tools")
    add_deps(base_ui_complete)
    add_defines( "UNICODE", "_UNICODE")
    add_cxflags("/execution-charset:utf-8")
    add_files(path.join(cp_src,"**.cpp"))
    add_filegroups("src", {rootdir = cp_src ,files = {"**.cpp","**.h"}})

target("Reflection_bin")
    set_languages("c++20")
    set_kind("binary")
    set_group("tools")
    add_deps(base_ui_complete)
    add_defines( "UNICODE", "_UNICODE")
    add_cxflags("/execution-charset:utf-8")
    add_files(path.join(rf_src,"**.cpp"))
    add_includedirs(rf_src)
    add_filegroups("src", {rootdir = rf_src ,files = {"**.cpp","**.h"}})
    after_build(function (target)
        local os_arch = is_arch("x64") and "64" or "32"
        local reflection_fn = path.join(target:targetdir(),"Reflection" .. os_arch .. ".bin")
        if not os.exists(reflection_fn) then
            local meta_dir = path.join(target:targetdir(),"../../../Resources/Metadata/")
            local meta_fn = path.join(meta_dir,"Reflection*.*")
            os.mkdir(meta_dir)
            os.run(target:targetfile())
            os.mv(meta_fn,target:targetdir())
            os.rmdir(path.directory(meta_dir))
        end
    end)
    
target("import")
    set_kind("phony")
    add_deps("CodePack")
    on_run(function(target)
        local code_dirs = {}
        local import = target:dep("CodePack")
        local genfn = path.join(os.projectdir(),"src","*/Release/CodegenConfig.xml")
        for _, fn in ipairs(os.files(genfn)) do
            local dir = path.directory(fn)
            table.insert(code_dirs,dir)
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