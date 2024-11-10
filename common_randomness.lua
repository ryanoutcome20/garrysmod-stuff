local CRandom = { 
    Min = 1000,
    Max = 1000,

    Size = 2500,
    Count = 0,

    Archive = { },
    Data = { }
}

function CRandom:GenerateDots( )
    local Count, Points = 15, { }

    for i = 1, Count do 
        local x, y = math.random( 0, self.Min - 40 ), math.random( 0, self.Max - 40 )

        table.insert( self.Data, {
            x = x,
            y = y
        } )
    end
end

function CRandom:Render( )
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( 0, 0, self.Min, self.Max )

    if self.Count >= 3 then
        local Frequency = { 
            x = { },
            y = { }
        }

        local Common = {
            x = 0,
            y = 0,

            xx = 0,
            xy = 0,
        }

        for k,v in ipairs( self.Archive ) do 
            for i,p in ipairs( v ) do 
                Frequency[ p.x ] = ( Frequency[ p.x ] or 0 ) + 1
                Frequency[ p.y ] = ( Frequency[ p.y ] or 0 ) + 1

                if Frequency[ p.x ] > Common.x then 
                    Common.xx = p.x 
                    Common.xy = p.y
                end
            end
        end

        local Clr = HSVToColor( CurTime( ) * 400 % 360, 1, 1 )

        surface.SetDrawColor( Clr )
        surface.DrawRect( Common.xx, Common.xy, 15, 15 )

        return
    end

    self:GenerateDots( )

    for k,v in ipairs( self.Data ) do
        local Clr = HSVToColor( k * 40 % 360, 1, 1 )

        surface.SetDrawColor( Clr )
        surface.DrawRect( v.x, v.y, 5, 5 )

        surface.DrawCircle( v.x + 2, v.y + 2, 15 + math.sin( CurTime() ) * 15, Clr.r, Clr.g, Clr.b )

        local Next = self.Data[ k + 1 ]
        if Next then             
            surface.DrawLine( v.x, v.y, Next.x, Next.y )
        end
    end

    if #self.Data > self.Size then
        table.insert( self.Archive, self.Data )

        self.Data = { }

        self.Count = self.Count + 1
    end
end

hook.Add( "HUDPaint", "Paint", function()
    CRandom:Render( )
end )