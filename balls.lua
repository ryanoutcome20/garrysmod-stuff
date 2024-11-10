local Agents, Trails = { }, { }

local W, H = ScrW( ), ScrH( )

local Speed = 20
local Evap  = 0.1

// =============================================================================
// Generate Starting Agents
// =============================================================================

for i = 1, 40 do 
   table.insert( Agents, 1, {
      Angle = math.random( ),
      Position = {
         X = ( W / 2 ) + i / 2,
         Y = ( H / 2 ) - i / 2
      },

      Color = 255
   } )
end

// =============================================================================
// Update Agents
// =============================================================================

local function Update( )
   local Sys = SysTime( )

   for k,v in ipairs( Agents ) do 
      math.randomseed( v.Position.X * W + v.Position.Y * H + ( k / os.time( ) ) )

      local Random = math.random( )

      -- Move
      local Direction = {
         X = ( v.Position.X + math.cos( v.Angle ) * ( Speed + ( Random / 2 ) ) ),
         Y = ( v.Position.Y + math.sin( v.Angle ) * ( Speed + ( Random / 4 ) ) )
      }

      -- Bounds
      if Direction.X < 0 or Direction.X >= W or Direction.Y < 0 or Direction.Y >= H then 
         Direction.X = math.min( W - 0.01, math.max( 0, Direction.X ) )
         Direction.Y = math.min( H - 0.01, math.max( 0, Direction.Y ) )

         Direction.Angle = Random * 2 * math.pi
      end

      -- Mouse Bounds
      if input.IsMouseDown(MOUSE_LEFT) then
         local DistanceX, DistanceY = Direction.X - gui.MouseX(), Direction.Y - gui.MouseY()
         local Distance = math.sqrt( DistanceX^2 + DistanceY^2 )

         if input.IsMouseDown( MOUSE_RIGHT ) or Distance < 450 then
            if input.IsMouseDown( MOUSE_MIDDLE ) then 
               Direction.Angle = -math.atan2( DistanceY, DistanceX ) - math.pi
            else 
               Direction.Angle = math.atan2( DistanceY, DistanceX ) + math.pi
            end
         end
      end

      Agents[ k ] = {
         Angle    = Direction.Angle or v.Angle,
         Position = Direction,

         Time     = Sys,

         Color    = 255
      }

      table.insert( Trails, Agents[ k ] )
   end
end

// =============================================================================
// Draw Agents
// =============================================================================

local Mat = Material( 'cat.png' )

local function Draw( )
   local Sys = SysTime( )

   local Final = table.Copy( Trails )

   for i = 1, #Trails do
      local Value = Trails[ i ]

      if Value.Time + Evap < Sys then 
         table.remove( Final, i )
         continue
      end

      if not Value then 
         continue
      end

      local Color = Value.Time / ( 4 + i )

      if not Color then 
         continue
      end

      surface.SetDrawColor( HSVToColor( Color, 1, 1 ) )
      surface.DrawRect( Value.Position.X, Value.Position.Y, 5, 5 )
   end

   Trails = Final
end

// =============================================================================
// Draw Performance
// =============================================================================

local function Performance( )
   surface.SetFont( 'Default' )
   surface.SetTextPos( 5, 5 )
   surface.SetTextColor( color_white )

   surface.DrawText( 'Current Frames: ' .. math.Round( 1 / FrameTime( ) ) )
end

// =============================================================================
// Hooks
// =============================================================================

hook.Add( 'DrawOverlay', 'Simulator', function( )
   Update( )

   Draw( )

   Performance( )
end )