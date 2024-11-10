-- Amount configuration.
local Amount = 5000 -- Anything above ~500 will brick your game.

-- Spam console command.
concommand.Add( 'executespam', function( )
    for i = 1, Amount do 
        steamworks.OpenWorkshop( )
    end
end )
