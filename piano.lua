local Play = {
   'b17', 'b15', 'a19', 'b17', 'b15', 'a19', 'b17', 'b15', -- PUG PUG PU
   'b16', 'b15', 'a18', 'b16', 'b15', 'a18', 'b16', 'b15', -- OUF OUF OU
   'b16', 'b15', 'a18', 'b16', 'b15', 'a18', 'b16', 'b15', -- OUF OUF OU
   'a28', 'a16', 'a24', 'a28', 'a16', 'a24', 'a28', 'a16', -- KYF KYF KY
}

local Time, Delta = CurTime( ), 0.25
local In = 1
local E = NULL

hook.Add( 'Think', 'Timer', function( )
   if not IsValid( E ) then 
      return 
   end
   
   if Time + Delta <= CurTime( ) then
      net.Start( 'InstrumentNetwork' )
         net.WriteEntity( E )
         net.WriteInt( 3, 3 )
         net.WriteString( Play[ In ] )
      net.SendToServer( )

      timer.Simple( 0.01, function( )
         net.Start( 'InstrumentNetwork' )
            net.WriteEntity( E )
            net.WriteInt( 2, 3 )
         net.SendToServer( )
      end )
      
      In   = math.Clamp( ( In + 1 ) % #Play, 1, #Play )
      Time = CurTime( )
   end
end )

concommand.Add( 'piano_ent', function( )
   E = LocalPlayer():GetEyeTrace( ).Entity

   MsgN( "Set To ", E )
end )