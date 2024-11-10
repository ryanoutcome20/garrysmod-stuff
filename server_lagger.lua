// This shit is dumb. If you do it too much you'll get a net channel overflow and be kicked.
// Will max out the net channel for everyone though since once you change it everyone else needs the message that it has changed.
local Max = 15

local Enabled = CreateClientConVar( 'funny_lag', 0 )

timer.Create( 'server_funny', 0.10, 0, function( ) // It'll kick you if you do it too fast. 
    if not Enabled:GetBool( ) then 
        return
    end

    for i = 0, Max do 
        RunConsoleCommand( 'finger_' .. i, math.random( ) .. ' ' .. math.random( ) )
    end
end )