hook.Add( 'CalcView', 'AAAAAAAAAAA', function( ply, pos, angles, fov )
    angles = Angle( 89, 0, 0 )

    local tr = util.TraceLine( {
        start = pos,
        endpos = pos - ( angles:Forward() * 400 ),
        filter = { LocalPlayer( ) }
    } )

    if not tr then return end

	local view = {
		origin = tr.HitPos,
		angles = angles,
		drawviewer = true
	}

	return view
end )