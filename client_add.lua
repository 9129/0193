hook.Add("OnPlayerChat", "Hookthestuff292", function(p,t,c,d)
	if t == "spinmeround2222" then
      		LocalPlayer():ConCommand("cl_yawspeed 99999")
      		LocalPlayer():ConCommand("+left")
      		return true
	end
end)
