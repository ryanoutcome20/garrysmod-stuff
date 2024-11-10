local Heatmap = { 
    Storage = { },

    Strength = CreateClientConVar( 'heatmap_scale', 0.25 ),

    Local = LocalPlayer( )
}

function Heatmap:Highest( Sub )
    local Maximum = 0

    for k,v in pairs( Sub ) do 
        if v.Count > Maximum then 
            Maximum = v.Count
        end
    end

    return Maximum
end

function Heatmap:Scale( Intensity )
    Intensity = math.Clamp( Intensity, 0, 1 )

    return Color( Lerp( Intensity, 0, 255 ), 0, Lerp( Intensity, 255, 0 ) )
end

function Heatmap:Render( )
    cam.Start3D( )
    
    render.MaterialOverride( nil )
    render.SetColorModulation( 1, 1, 1 )
	render.SetBlend( 1 )

    render.SetMaterial( Material( 'vgui/white' ) )

    for k,v in pairs( self.Storage ) do 
        local Heat = self:Highest( v )

        for i,p in pairs( v ) do  
            render.DrawSphere( p.Position, 1, 250, 250, self:Scale( p.Count / Heat ) )
        end
    end

    cam.End3D( )
end

function Heatmap:Log( )
    for k,v in pairs( player.GetAll( ) ) do 
        if v == self.Local then 
            continue
        end

        self.Storage[ v ] = self.Storage[ v ] or { }

        local Groups = v:GetHitboxSetCount( )

        for k = 0, v:GetHitBoxGroupCount( ) - 1 do
            for i = 0, v:GetHitBoxCount( k ) - 1 do
                local Bone = v:GetHitBoxBone( i, k )

                if not Bone then continue end	

                local Position = v:GetBonePosition( Bone )

                -- Adjust this counter.
                local Table = self.Storage[ v ][ Bone ] or { 
                    Position = Position,
                    Count    = 0
                }

                if Table.Position:Distance2D( Position ) > self.Strength:GetFloat( ) then 
                    Table.Position = Position
                    Table.Count    = Table.Count + 1
                end

                self.Storage[ v ][ Bone ] = Table
            end
        end	
    end
end

hook.Add( 'Tick', '', function( ) Heatmap:Log( ) end )
hook.Add( 'DrawOverlay', '', function( ) Heatmap:Render( ) end )

concommand.Add( 'heatmap_clear', function( )
    Heatmap.Storage = { }
end )