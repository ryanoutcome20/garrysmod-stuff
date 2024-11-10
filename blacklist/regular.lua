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

if GetAPIManifest then 
    GetAPIManifest( function( result )
        result = util.JSONToTable( result )
        if ( !result ) then return MsgN( "Couldn't grab APIManifest; connect to the internet?" ) end

        MsgN( "Got API Manifest; version " .. result[ 'ManifestVersion' ] )

        for k, v in pairs( result.Servers.Banned ) do
            if ( v:StartsWith( "map:" ) ) then
                table.ForceInsert( BlackList.Maps, v:sub( 5 ) )
            elseif ( v:StartsWith( "host:" ) or v:StartsWith( "name:" ) ) then
                table.ForceInsert( BlackList.Hostnames, v:sub( 6 ) )
            elseif ( v:StartsWith( "desc:" ) ) then
                table.ForceInsert( BlackList.Descripts, v:sub( 6 ) )
            elseif ( v:StartsWith( "gm:" ) ) then
                table.ForceInsert( BlackList.Gamemodes, v:sub( 4 ) )
            else
                table.ForceInsert( BlackList.Addresses, v )
            end
        end

        DumpToText( BlackList.Addresses, 'Addresses' )
        DumpToText( BlackList.Hostnames, 'Hostnames' )
        DumpToText( BlackList.Descripts, 'Descripts' )
        DumpToText( BlackList.Gamemodes, 'Gamemodes' )
        DumpToText( BlackList.Maps, 'Maps' )

        MsgN( "Finished" )
    end )
else 
    MsgN( "Couldn't find APIManifest; run this in menustate!" )
end
