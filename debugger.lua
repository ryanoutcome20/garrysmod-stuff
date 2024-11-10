local Debugger = { 
    ENT = NULL
}

-- =============================================================================
-- Entity Debugger Module
-- =============================================================================

function Debugger:Server( )
    for k,v in pairs( ents.GetAll( ) ) do 
        local Phys = v:GetPhysicsObject( )

        if not IsValid( Phys ) then 
            continue 
        end

        v:SetNW2Angle( 'PhysAngle', Phys:GetAngles( ) )
        v:SetNW2Vector( 'PhysVelocity', Phys:GetVelocity( ) )
        v:SetNW2Float( 'PhysMass', Phys:GetMass( ) )
        v:SetNW2Vector( 'PhysInertia', Phys:GetInertia( ) )
        v:SetNW2Vector( 'PhysInv', Phys:GetInvInertia( ) )
        v:SetNW2String( 'PhysState', ( Phys:IsAsleep( ) and 'Asleep' or 'Awake' ) .. ' (' .. ( Phys:IsCollisionEnabled( ) and 'Collide' or 'No-Collide' ) .. ')' )
        
        local Linear, Angular = Phys:GetDamping( )

        v:SetNW2Float( 'PhysDampingL', Linear )
        v:SetNW2Float( 'PhysDampingA', Angular )
    end
end

function Debugger:Draw( )
    if self.ENT == NULL then 
        return
    end

    local Targets = {
        [ 'Angle' ] = self.ENT:GetNW2Angle( 'PhysAngle' ),
        [ 'Velocity' ] = self.ENT:GetNW2Vector( 'PhysVelocity' ),
        [ 'Mass' ] = self.ENT:GetNW2Float( 'PhysMass' ),
        [ 'Inertia' ] = self.ENT:GetNW2Vector( 'PhysInertia' ),
        [ 'Inverted Inertia' ] = self.ENT:GetNW2Vector( 'PhysInv' ),
        [ 'State' ] = self.ENT:GetNW2String( 'PhysState' ),
        [ 'Damping Linear' ] = self.ENT:GetNW2Float( 'PhysDampingL' ),
        [ 'Damping Angular' ] = self.ENT:GetNW2Float( 'PhysDampingA' ),

        [ 'Position' ] = self.ENT:GetPos( ),
        [ 'AbsVelocity' ] = self.ENT:GetAbsVelocity( ),
        [ 'Object' ] = tostring( self.ENT ),
        [ 'Material' ] = self.ENT:GetMaterial( ) .. ' (' .. tostring( self.ENT:GetColor( ) ) .. ')'
    }

    -- Loop.
    local Count = 0

    for k,v in pairs( Targets ) do 
    	draw.SimpleText( Count .. ' - ' .. k , 'Trebuchet24', 50, 50 + Count * 24, color_white )
        draw.SimpleText( v, 'Trebuchet24', 250, 50 + Count * 24, color_white )

        Count = Count + 1
    end
end

-- =============================================================================
-- Concommand & Hook
-- =============================================================================

if SERVER then 
    hook.Add( 'Think', 'DFix', function( )
        Debugger:Server( )
    end )

    return
end

concommand.Add( 'debugger_attach', function( )
    local Trace = LocalPlayer( ):GetEyeTrace( )

    if not Trace.HitWorld then 
        Debugger.ENT = Trace.Entity
    end
end )

hook.Add( 'HUDPaint', 'DDraw', function( )
    Debugger:Draw( )
end )