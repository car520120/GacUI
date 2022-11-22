import("net.fasturl")
import("devel.git")

local root_src =  root_src or path.join(os.projectdir(),"src") 
local token_file = token_file or path.join(os.projectdir(),"Import","README.md") 

function file_from_github(zip)
    import("net.http")
    import("lib.detect.find_file")
    local sdkdir = sdkdir or os.projectdir().."/SDKs"
    local zip_dir = find_file(zip, {sdkdir})
    if(zip_dir == nil) then
        local url = vformat("https://ghproxy.com/https://github.com/SakuraEngine/Sakura.Resources/releases/download/SDKs/")
        print("download: "..url..zip.." to: "..os.projectdir().."/SDKs/"..zip)
        http.download(url..zip, os.projectdir().."/SDKs/"..zip, {continue = false})
    end
end

local function proxy_url()
    local proxyurls = {
        "https://github.com/",
        "https://gitclone.com/github.com/",
        "https://ghproxy.com/https://github.com/"
    }
    fasturl.add(proxyurls)
    proxyurls = fasturl.sort(proxyurls)
    return proxyurls
end

local function check_hash()
    local project_hash = {}
    local ss = io.readfile(token_file)
    local sep = "(.-)[\n$]"
    local pattern = ".*%*%*(.+)%*%*.*%[(.+)%].*%((.+)%)"
    local proxyurls = proxy_url()
    string.gsub(ss,sep,function(s)
        local name,hash,tail_url = string.match(s,pattern)
        if  tail_url then
            local tail = - 7 - #hash
            local url = string.sub(tail_url,0,tail) .. ".git"
            if #proxyurls > 0 then
                url = url:replace("/github.com/", "/" .. proxyurls[1] .. "/", {plain = true})
                -- print("*** url :" ,url)
            end
            table.insert(project_hash,{name = name,url = url,hash = hash})
        end
    end)
    return project_hash
end

--[[
    obj = { 
        name="project name",
        hash = "1063abc68d5e1698ec55cc92886806c0617ab9db" ,
        url="https://github.com/xmake-io/xmake.git"
    }
]] 
function clone_project(obj)
    local obj_home = path.join(root_src,obj.name)
    git.clone(obj.url,{outputdir  = obj_home})
    if os.exists(obj_home) then
        git.checkout(obj.hash,{repodir = obj_home})
    end
end

-- obj same clone_project
function update_project(obj)
    local obj_home = path.join(root_src,obj.name)
    print("start sync to :",obj_home)
    if os.exists(obj_home) then
        git.pull({repodir = obj_home})
        git.checkout(obj.hash,{repodir = obj_home})
    else
        clone_project(obj)
    end
    
end

function check_src()
    local new_md5 =  hash.md5(token_file)
    local old_md5 = nil
    local cache_fn = path.join(os.projectdir(),".xmake",os.host(),os.arch(),"cache","import_md5.txt")
    if os.exists(cache_fn) then
        old_md5 = io.readfile(cache_fn)
    else
        os.mkdir(path.directory(cache_fn))
        io.writefile(cache_fn, new_md5)
    end

    if new_md5 == old_md5 and os.exists(root_src) then
        return
    end

    local project_hash = check_hash()

    if not os.exists(root_src) then
        os.mkdir(root_src)
    end
    for _, obj in ipairs(project_hash) do
        update_project(obj)
    end
    print("end sync")
end