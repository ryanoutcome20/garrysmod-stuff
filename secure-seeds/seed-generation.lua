-- =============================================================================
-- Seed Generation Library
-- =============================================================================

//-/~ Main Table
Seed = { }

//-/~ Convert To Bytes
function Seed:ToBytes( Pointer, Shift )
    local Address, Reconstructed = string.Right( string.format( '%p', Pointer ), 2 ), { }

    for i = 1, #Address do 
        local Byte = string.byte( Address[ i ] )

        -- Convert this to something less linear.
        Byte = bit.bswap( Byte )
        Byte = bit.rol( Byte, Shift )
        Byte = bit.lshift( Byte, Shift )

        -- Insert our table.
        table.insert( Reconstructed, math.abs( Byte ) % 10 ) 
    end

    return Reconstructed
end

//-/~ Generate
function Seed:Generate( Size, Shift )
    local Seed, Count = '', 0

    Shift = Shift or os.time( )

    while true do 
        Seed = Seed .. table.concat( self:ToBytes( function( ) end, Shift * Count ) )

        if #Seed > Size then 
            break
        end

        Count = Count + 1
    end

    return Seed
end

//-/~ Generate Number
function Seed:GenerateNumber( Min, Max )
    -- This is best used in seperate realms because otherwise I can just detour or use a module to find the seed.
    math.randomseed( Seed:Generate( 128 ) )

    local Number = math.random( Min, Max )

    math.randomseed( os.time( ) ) -- Play nicely with other addons.

    return Number
end
