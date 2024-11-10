local ASM = { 
    Debug   = false,
    Halt    = false,
    Opcodes = { },
    Cache   = { },
    Pointer = { },
    Ignores = { 
        [ '#' ] = true,
        [ '--' ] = true,
        [ '//' ] = true
    },
    Files   = {
        [ '-g' ] = 'GAME',
        [ '-l' ] = 'LUA',
        [ '-d' ] = 'DATA'
    }
}

/*
    MOV source goal
    DEL source
    ADJ source value
    SIZ source goal

    AND name1, name2, goal
    OR  name1, name2, goal
    NOT name1, name2, goal

    SUB  name1, name2, goal
    SUBR name1, name2, goal
    ADD  name1, name2, goal
    ADDR name1, name2, goal
    MUL  name1, name2, goal
    MULR name1, name2, goal
    DIV  name1, name2, goal
    DIVR name1, name2, goal

    NEW  name value
    NEWR name value

    CAP  function goal meta cache
    SYSR function goal ...
    SYS  function ...

    FUN name ...
    FUNL name ...

    CMD name ...

    CALL name ...
    GET  number goal

    TBLD source index
    TBLW source index goal
    TBLC source goal
    TBLE source

    REG name line
    JMP name
    BRK line
    
    JNZ line out
    JIN line out
    JNN line out
    JNT line out

    STOP

    LF file

    PRN ...

    STK
    RBL
    DBG bool
*/

// =============================================================================
// Utility Functions
// =============================================================================

function ASM:Out( Text, Pop )
    MsgC( color_white, '[', Pop or Color( 132, 255, 255 ), 'ASM', color_white, '] ' .. Text .. '\n' )
end

function ASM:DbgOut( Text, Pop )
    if not self.Debug then 
        return
    end

    self:Out( Text, Pop )
end

function ASM:Error( Message, ... )
    self:Out( string.format( Message, ... ) )

    self.Halt = true

    error( 'Failed.' )

    return -1
end

// =============================================================================
// Opcodes
// =============================================================================

function ASM.Opcodes:MOV( Source, Goal )
    if not ASM.Cache[ Source ] then
        ASM:Error( 'Invalid Argument #1 to MOV (couldn\'t fetch cache from %s)', Source )
    end
    
    if not isstring( Goal ) then
        ASM:Error( 'Invalid Argument #2 to MOV (string expected got %s)', type( Goal ) )
    end

    ASM.Cache[ Goal ] = ASM.Cache[ Source ]
end

function ASM.Opcodes:DEL( Source )
    ASM.Cache[ Source ] = nil
end

function ASM.Opcodes:ADJ( Source, Value )
    if not ASM.Cache[ Source ] then 
        ASM:Error( 'Invalid Argument #1 to ADJ (couldn\'t fetch cache from %s)', Source )
    end 

    ASM.Cache[ Source ] = Value
end

function ASM.Opcodes:SIZ( Source, Goal )
    local Contents = ASM.Cache[ Source ]

    if not Contents then 
        ASM:Error( 'Invalid Argument #1 to SIZ (couldn\'t fetch cache from %s)', Contents )
    end

    if not isstring( Goal ) then 
        ASM:Error( 'Invalid Argument #2 to SIZ (string expected got %s)', type( Goal ) )
    end

    if type( Contents ) == 'table' then 
        ASM.Cache[ Goal ] = table.Count( Contents )
    elseif type( Contents ) == 'string' then
        ASM.Cache[ Goal ] = #Contents
    else
        ASM:Error( 'Failed to find contents for SIZ (couldn\'t find a size operator for %s)', type( Contents ) )
    end
end

function ASM.Opcodes:AND( Name, Name2, Goal )
    if not isstring( Name ) then
        ASM:Error( 'Invalid Argument #1 to AND (string expected got %s)', type( Name ) )
    end

    if not isstring( Name2 ) then
        ASM:Error( 'Invalid Argument #2 to AND (string expected got %s)', type( Name2 ) )
    end

    ASM.Cache[ Goal ] = ( tostring( ASM.Cache[ Name ] ) == tostring( ASM.Cache[ Name2 ] ) ) and 1 or 0
end

function ASM.Opcodes:OR( Name, Name2, Goal )
    if not isstring( Name ) then
        ASM:Error( 'Invalid Argument #1 to OR (string expected got %s)', type( Name ) )
    end

    if not isstring( Name2 ) then
        ASM:Error( 'Invalid Argument #2 to OR (string expected got %s)', type( Name2 ) )
    end

    ASM.Cache[ Goal ] = ( tostring( ASM.Cache[ Name ] ) == tostring( ASM.Cache[ Name2 ] ) ) and 0 or 1
end

function ASM.Opcodes:NOT( Name, Name2, Goal )
    if not isstring( Name ) then
        ASM:Error( 'Invalid Argument #1 to NOT (string expected got %s)', type( Name ) )
    end

    if not isstring( Name2 ) then
        ASM:Error( 'Invalid Argument #2 to NOT (string expected got %s)', type( Name2 ) )
    end

    ASM.Cache[ Goal ] = ( tostring( ASM.Cache[ Name ] ) != tostring( ASM.Cache[ Name2 ] ) ) and 1 or 0
end

function ASM.Opcodes:SUB( Name, Name2, Goal )
    if not isstring( Name ) then
        ASM:Error( 'Invalid Argument #1 to SUB (string expected got %s)', type( Name ) )
    end

    if not isstring( Name2 ) then
        ASM:Error( 'Invalid Argument #2 to SUB (string expected got %s)', type( Name2 ) )
    end

    ASM.Cache[ Goal ] = tonumber( ASM.Cache[ Name ] ) - tonumber( ASM.Cache[ Name2 ] )
end

function ASM.Opcodes:SUBR( Name, Name2, Goal )
    if not isstring( Name ) then
        ASM:Error( 'Invalid Argument #1 to SUBR (string expected got %s)', type( Name ) )
    end

    if not isstring( Name2 ) then
        ASM:Error( 'Invalid Argument #2 to SUBR (string expected got %s)', type( Name2 ) )
    end

    ASM.Cache[ Goal ] = ASM.Cache[ Name ] - ASM.Cache[ Name2 ]
end

function ASM.Opcodes:ADD( Name, Name2, Goal )
    if not isstring( Name ) then
        ASM:Error( 'Invalid Argument #1 to ADD (string expected got %s)', type( Name ) )
    end

    if not isstring( Name2 ) then
        ASM:Error( 'Invalid Argument #2 to ADD (string expected got %s)', type( Name2 ) )
    end

    ASM.Cache[ Goal ] = tonumber( ASM.Cache[ Name ] ) + tonumber( ASM.Cache[ Name2 ] )  
end

function ASM.Opcodes:ADDR( Name, Name2, Goal )
    if not isstring( Name ) then
        ASM:Error( 'Invalid Argument #1 to ADDR (string expected got %s)', type( Name ) )
    end

    if not isstring( Name2 ) then
        ASM:Error( 'Invalid Argument #2 to ADDR (string expected got %s)', type( Name2 ) )
    end

    ASM.Cache[ Goal ] = ASM.Cache[ Name ] + ASM.Cache[ Name2 ]
end

function ASM.Opcodes:MUL( Name, Name2, Goal )
    if not isstring( Name ) then
        ASM:Error( 'Invalid Argument #1 to MUL (string expected got %s)', type( Name ) )
    end

    if not isstring( Name2 ) then
        ASM:Error( 'Invalid Argument #2 to MUL (string expected got %s)', type( Name2 ) )
    end

    ASM.Cache[ Goal ] = tonumber( ASM.Cache[ Name ] ) * tonumber( ASM.Cache[ Name2 ] )  
end

function ASM.Opcodes:MULR( Name, Name2, Goal )
    if not isstring( Name ) then
        ASM:Error( 'Invalid Argument #1 to MULR (string expected got %s)', type( Name ) )
    end

    if not isstring( Name2 ) then
        ASM:Error( 'Invalid Argument #2 to MULR (string expected got %s)', type( Name2 ) )
    end

    ASM.Cache[ Goal ] = ASM.Cache[ Name ] * ASM.Cache[ Name2 ]
end

function ASM.Opcodes:DIV( Name, Name2, Goal )
    if not isstring( Name ) then
        ASM:Error( 'Invalid Argument #1 to DIV (string expected got %s)', type( Name ) )
    end

    if not isstring( Name2 ) then
        ASM:Error( 'Invalid Argument #2 to DIV (string expected got %s)', type( Name2 ) )
    end

    ASM.Cache[ Goal ] = tonumber( ASM.Cache[ Name ] ) / tonumber( ASM.Cache[ Name2 ] )  
end

function ASM.Opcodes:DIVR( Name, Name2, Goal )
    if not isstring( Name ) then
        ASM:Error( 'Invalid Argument #1 to DIVR (string expected got %s)', type( Name ) )
    end

    if not isstring( Name2 ) then
        ASM:Error( 'Invalid Argument #2 to DIVR (string expected got %s)', type( Name2 ) )
    end
    
    ASM.Cache[ Goal ] = ASM.Cache[ Name ] / ASM.Cache[ Name2 ]
end

function ASM.Opcodes:NEW( Name, ... )
    if not isstring( Name ) then
        ASM:Error( 'Invalid Argument #1 to NEW (string expected got %s)', type( Name ) )
    end

    local Text = table.concat( { ... }, ' ' )

    if Text[ 1 ] == '{' and Text[ #Text ] == '}' then
        Text = string.Replace( Text, '{', '' )
        Text = string.Replace( Text, '}', '' )

        ASM.Cache[ Name ] = string.Split( Text, ',' )

        return
    end

    ASM.Cache[ Name ] = Text
end

function ASM.Opcodes:NEWR( Name, Value )
    if not isstring( Name ) then
        ASM:Error( 'Invalid Argument #1 to NEWR (string expected got %s)', type( Name ) )
    end

    local Types = {
        [ 'nil' ] = nil,
        [ 'NULL' ] = NULL,
        [ 'table' ] = { },
        [ 'string' ] = '',
        [ 'number' ] = 0
    }

    Types = Types[ Value ]
    
    if not Types and Value != 'nil' then 
        ASM:Error( 'Invalid Argument #2 to NEWR (couldn\'t fetch type of %s)', Value )
    end

    ASM.Cache[ Name ] = Types
end

function ASM.Opcodes:CAP( Function, Goal, Meta, Cache )
    if not isstring( Function ) then
        ASM:Error( 'Invalid Argument #1 to CAP (string expected got %s)', type( Function ) )
    end

    if Meta then
        local Target = { }

        if Cache then 
            Target = ASM.Cache[ Cache ]
        else 
            Target = FindMetaTable( Meta )
        end

        if not Target then 
            ASM:Error( 'Couldn\'t find target to CAP (%s)', Cache and 'CACHE' or 'META' )
        end

        ASM.Cache[ Goal ] = Target[ Function ] 

        return
    end

    local Parts = { }
    
    for Part in string.gmatch( Function, '[^%.]+' ) do
        table.insert( Parts, Part )
    end

    local lastPart = table.remove( Parts )
    
    local targetTable = _G
    for k,v in ipairs( Parts ) do
        targetTable = targetTable[ v ]
    end

    if not targetTable then 
        ASM:Out( 'Failed to grab function of the name "' .. Function .. '"!' )
        return
    end 

    ASM.Cache[ Goal ] = targetTable[ lastPart ]
end

function ASM.Opcodes:SYS( Source, ... )
    if not ASM.Cache[ Source ] then 
        ASM:Error( 'Invalid Argument #1 to SYS (couldn\'t fetch cache from %s)', Source )
    end 

    local Table = { ... }

    for i = 1, #Table do 
        Table[ i ] = ASM.Cache[ Table[ i ] ] or Table[ i ]
    end

    ASM.Cache[ Source ]( unpack( Table ) )
end

function ASM.Opcodes:SYSR( Source, Goal, ... )
    if not ASM.Cache[ Source ] then 
        ASM:Error( 'Invalid Argument #1 to SYSR (couldn\'t fetch cache from %s)', Source )
    end 

    local Table = { ... }

    for i = 1, #Table do 
        Table[ i ] = ASM.Cache[ Table[ i ] ] or Table[ i ]
    end

    ASM.Cache[ Goal ] = ASM.Cache[ Source ]( unpack( Table ) )
end

function ASM.Opcodes:FUN( Name, ... )
    if not isstring( Name ) then
        ASM:Error( 'Invalid Argument #1 to FUN (string expected got %s)', type( Name ) )
    end

    local Opcode = string.Split( table.concat( { ... }, ' ' ), ',' )

    for i = 1, #Opcode do 
        Opcode[ i ] = string.Split( Opcode[ i ], ' ' )
    end

    ASM.Cache[ Name ] = function( ... )
        for i = 1, #Opcode do 
            ASM:Parse( Opcode[ i ] )
        end
    end
end

function ASM.Opcodes:FUNL( Name, ... )
    if not isstring( Name ) then
        ASM:Error( 'Invalid Argument #1 to FUNL (string expected got %s)', type( Name ) )
    end

    local Code = table.concat( { ... }, ' ' ) 

    ASM.Cache[ Name ] = function( ... )
        CompileString( Code, Name )( ... )
    end
end

function ASM.Opcodes:LF( File )
    ASM:File( File, 'GAME' )
end

function ASM.Opcodes:CMD( Name, ... )
    RunConsoleCommand( Name, ... )
end

function ASM.Opcodes:TBLD( Source, Index )
    table.remove( ASM.Cache[ Source ], Index )
end

function ASM.Opcodes:TBLW( Source, Index, Goal )
    ASM.Cache[ Goal ] = ASM.Cache[ Source ][ Index ]
end

function ASM.Opcodes:TBLC( Source, Goal )
    ASM.Cache[ Goal ] = table.Copy( ASM.Cache[ Source ] )
end

function ASM.Opcodes:TBLE( Source )
    ASM.Cache[ Source ] = table.Empty( ASM.Cache[ Source ] )
end

function ASM.Opcodes:REG( Name, Line )
    ASM.Pointer[ Name ] = Line
end

function ASM.Opcodes:JMP( Name )
    return ASM.Pointer[ Name ]
end

function ASM.Opcodes:BRK( Line )
    return Line
end

function ASM.Opcodes:JNZ( Line, Out )
    if ASM.Cache[ Out ] == 1 then 
        return Line
    end
end

function ASM.Opcodes:JIN( Line, Out )
    if not IsValid( ASM.Cache[ Out ] ) then 
        return Line
    end
end

function ASM.Opcodes:JNN( Line, Out )
    if IsValid( ASM.Cache[ Out ] ) then 
        return Line
    end
end

function ASM.Opcodes:JNT( Line, Out )
    if not ASM.Cache[ Out ] then 
        return Line
    end
end

function ASM.Opcodes:RBL( )
    ASM.Cache = { }
end

function ASM.Opcodes:STK( )
    local Counter = 0

    while true do
        local Info = debug.getinfo( Counter + 1 )

        if not Info then 
            break
        end

        MsgN( string.format( '%s%s is at stack level %s (%s)', string.rep( ' ', Counter ), Info.func, Counter, Info.short_src ) )

        Counter = Counter + 1    
    end

    MsgN( '\nTotal Cache Size: ', table.Count( ASM.Cache ) )

    for k,v in pairs( ASM.Cache ) do 
        MsgN( ' ', k, ' -> ', tostring( v ) )
    end
end

function ASM.Opcodes:STOP( )
    return -1
end

function ASM.Opcodes:DBG( Valid )
    ASM.Debug = tobool( Valid )
end

// =============================================================================
// Parser
// =============================================================================

function ASM:Parse( Text )
    for i = 1, #Text do 
        Text[ i ] = string.Replace( string.Replace( Text[ i ], string.char( 13 ), ' ' ), ' ', '' ) 
    end

    local Opcode = self.Opcodes[ Text[ 1 ] ]

    if not Opcode then 
        return
    end

    self:DbgOut( Text[ 1 ] )

    return Opcode( self.Opcodes, unpack( Text, 2 ) )
end

// =============================================================================
// Debug Tester & Parser
// =============================================================================

function ASM:File( File, Type )
    local Code = file.Read( File, Type )

    if not Code then
        return self:Out( 'Couldn\'t open file "' .. File .. '"!' )
    end

    local Split, PC, Max = string.Split( Code, '\n' ), 1, 1

    self.Halt = false

    while true do
        if not Split[ PC ] then 
            break
        end

        local Text = string.Split( Split[ PC ], ' ' )

        PC  = PC + 1
        Max = Max + 1

        if Max >= #Split + 150 then 
            self:Out( 'Stack Overflow!' )
            break 
        end

        if not Text then 
            break
        end

        if self.Ignores[ Text[ 1 ] ] then 
            continue
        end

        if self.Halt then 
            break
        end

        local Parsed = self:Parse( Text )

        if Parsed then 
            self:DbgOut( string.format( 'Adjusting program counter: %s -> %s', PC, Parsed ) )

            PC = tonumber( Parsed )
        end 
    end

    self.Pointer = { }
end

// =============================================================================
// Commands
// =============================================================================

concommand.Add( 'asm', function( _, __, Arguments )
    ASM:Parse( Arguments )
end )

concommand.Add( 'asm_out', function( _, __, Arguments )
    if Arguments[ 1 ] == '-a' then
        PrintTable( ASM )
    else 
        PrintTable( ASM.Cache )
    end
end )

concommand.Add( 'asm_file', function( _, __, Arguments )
    ASM:File( Arguments[ 1 ], ASM.Files[ Arguments[ 2 ] ] or 'GAME' )
end )

concommand.Add( 'asm_reload', function( )
    include( 'asm/asm.lua' )
end )