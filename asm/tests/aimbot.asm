# Captures
CAP LocalPlayer LocalPlayer
CAP MsgN MsgN
CAP EyePos EyePos
CAP Entity Entity
CAP IsValid IsValid

# Constants
NEW Target NULL

NEW Me NULL

SYSR LocalPlayer Me 

CAP OBBCenter OBBCenter Entity
CAP LocalToWorld LocalToWorld Entity

CAP Angle Angle Vector

CAP SetEyeAngles SetEyeAngles _ Me

# Loop Targets
NEW Int 1
NEW Num 1
NEW Current NULL
NEW Valid 0
NEW Max 256
NEW Breaker 0

REG Loop 31

AND Int Max Breaker
JNZ 46 Breaker

SYSR Entity Current Int
AND Current Me Valid
JNZ 39 Valid
JNN 48 Current

ADD Int Num Int

JMP Loop

# Break Stuff
BRK 47
STOP

SYS MsgN Current

# Target Stuff
MOV Current Target 

NEW Final NULL

SYSR OBBCenter Final Target
SYSR LocalToWorld Final Target Final

# My Eyes
NEW Eyes NULL

SYSR EyePos Eyes

# Sub
SUBR Final Eyes Final

# Angle
SYSR Angle Final Final

SYS SetEyeAngles Me Final