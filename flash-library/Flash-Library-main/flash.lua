-- =============================================================================
-- Flash Library
-- =============================================================================

-- Main Table
Flash = { }

-- =============================================================================
-- Utility Sub-Library
-- =============================================================================

math.randomseed( os.time( ) )

Format = string.format
Msg    = print

function isstring( Variable )
   return type( Variable ) == 'string'
end

function isnumber( Variable )
   return type( Variable ) == 'number'
end

function istable( Variable )
   return type( Variable ) == 'table'
end   

function isbool( Variable )
   return type( Variable ) == 'boolean'
end

function MsgN( ... )
   -- Get our data and convert to a string.
   local Data = { ... }

   for k,v in ipairs( Data ) do 
      Data[ k ] = tostring( v )
   end

   -- Print provided data with newline.
   print( table.concat( Data ), '\n' )
end

function PrintTable( Table, Indent, Done )
	Done   = Done or {}
	Indent = Indent or 0

   -- Prevent it from looping itself.
   Done[ Table ] = true 

   -- Loop Table.
   for k,v in pairs( Table ) do 
      print( string.rep( ' ', Indent ) .. Format( '[ %s ] = %s', tostring( k ), tostring( v ) ) )

      if istable( v ) and not Done[ v ] then
         PrintTable( v, Indent + 2, Done )
      end
   end
end

-- =============================================================================
-- String Sub-Library
-- =============================================================================

function string.starts( String, Text )
   return string.sub( String, 1, #Text ) == Text
end

function string.ends( String, Text )
   return string.sub( String, -#Text ) == Text
end

function string.split( String, Seperator, Concat )
   local Final, Count = { }, 1

   for i = 1, #String do 
      local Index = string.sub( String, i, i )
   
      if not Index then 
         break
      end

      if Index == Seperator then 
         if i > 1 then 
            Count = Count + 1
         end
      else
         Final[ Count ] = ( Final[ Count ] or '' ) .. Index 
      end
   end

   return Concat and table.concat( Final ) or Final
end

function string.replace( String, Seperator )
   return string.split( String, Seperator, true ) -- It'll do the same job.
end

function string.path( File )
   local Sub = string.split( File, '/' )

   Sub[ #Sub ] = nil

   return table.concat( Sub, '/' ) .. '/'
end

function string.file( File )
   local Sub = string.split( File, '/' )

   return Sub[ #Sub ]
end

function string.extension( File )
   local File = string.split( string.file( File ), '.' )

   return File[ #File ]
end

function string.left( String, Length )
   return string.sub( String, 1, Length )
end

function string.right( String, Length )
   return string.sub( String, -Length )
end

function string.table( String )
   local Final = { }

   for i = 1, #String do 
      table.insert( Final, string.sub( String, i, i ) )
   end

   return Final
end

-- =============================================================================
-- Math Sub-Library
-- =============================================================================

math.tau = 2 * math.pi

function math.round( Number, Decimals )
	local Multiplier = 10 ^ ( Decimals or 0 )
	
   return math.floor( Number * Multiplier + 0.5 ) / Multiplier
end

function math.randomfloat( Minimum, Maximum )   
   return Minimum + ( Maximum - Minimum ) * math.random( )
end