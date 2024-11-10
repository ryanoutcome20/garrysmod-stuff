-- Basic Config.
local Config = { 
    [ 'Pages' ] = 10, -- Pages of addons to download.
    [ 'Delay' ] = 5, -- Delay between fetching addon IDs and actually downloading them. Don't use zero.
}

-- Generate our table of addons.
local IDs = { }

for i = 1, Config[ 'Pages' ] do -- ( x * 50 )
    local Page = ( i - 1 ) * 50

    steamworks.GetList( "popular", { 'Addon' }, Page, 50, 7, 0, function( data ) 
        for k,v in ipairs( data.results ) do 
            table.insert( IDs, v )
        end
    end )
end

-- Execute our addons and mount them.
timer.Simple( Config[ 'Delay' ], function( )
    for k,v in ipairs( IDs ) do 
        steamworks.DownloadUGC( v, function( path, file )
            game.MountGMA( path )
        end )
    end
end )
