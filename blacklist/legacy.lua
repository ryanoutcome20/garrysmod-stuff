-- Utility Function
file.CreateDir('blacklist_dumper')

local function DumpToText( Table, Identity )
    local File = 'blacklist_dumper/' .. Identity .. '.txt'

    file.Write( File,  'Blacklist Dumper\nCreated for ' .. Identity .. ' [' .. table.Count( Table ) .. ']\n\n' )

    for k,v in pairs( Table ) do 
        file.Append( File, '[ ' .. k .. ' ] ' .. v .. '\n' )
    end

    MsgN( 'Total Size of ' .. Identity .. ' was ' .. string.NiceSize( table.Count( Table ) ) )
end

-- Blacklist Dumper
local BlackList = {
	Addresses = {},
	Hostnames = {},
	Descripts = {},
	Gamemodes = {},
	Maps = {},
	Translations = {},
	TranslatedHostnames = {}
}

local SteamworksID = 580620784 -- Get this from SteamworksID, this is a legacy feature.

steamworks.FileInfo( SteamworksID, function( result )
    if ( !result ) then return end
    
    MsgN( "Got FileInfo!\n" )

    if result.title == 'Hidden addon' then return MsgN( "Please use the modern blacklist dumper." ) end

    steamworks.Download( result.fileid, false, function( name )
        local fs = file.Open( name, "r", "MOD" )
        local data = fs:Read( fs:Size() )
        fs:Close()
        
        if !data then return end 

        MsgN( "Got data!" ) 

        BlackList = util.JSONToTable( data ) or {}

        BlackList.Addresses = BlackList.Addresses or {}
        BlackList.Hostnames = BlackList.Hostnames or {}
        BlackList.Descripts = BlackList.Descripts or {}
        BlackList.Gamemodes = BlackList.Gamemodes or {}
        BlackList.Maps = BlackList.Maps or {}
        BlackList.Translations = BlackList.Translations or {}
        BlackList.TranslatedHostnames = BlackList.TranslatedHostnames or {}
    end )

    DumpToText( BlackList.Addresses, 'Addresses Legacy' )
    DumpToText( BlackList.Hostnames, 'Hostnames Legacy' )
    DumpToText( BlackList.Descripts, 'Descripts Legacy' )
    DumpToText( BlackList.Gamemodes, 'Gamemodes Legacy' )
    DumpToText( BlackList.Maps, 'Maps Legacy' )
    DumpToText( BlackList.Translations, 'Translations Legacy' )
    DumpToText( BlackList.TranslatedHostnames, 'TranslatedHostnames Legacy' )
end )
steamworks.Unsubscribe( SteamworksID )
