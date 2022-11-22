module_root = path.absolute("xmgr/modules")
import("find_sdk", {rootdir = module_root})
find_sdk.check_src()