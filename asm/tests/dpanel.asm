# VGUI.Create
CAP vgui.Create vgui.Create

NEW Type DFrame
SYSR vgui.Create Panel Type
DEL Type

# DPanel Subs
CAP SetSize SetSize Panel
CAP Center Center Panel

CAP SetTitle SetTitle DFrame Panel
CAP MakePopup MakePopup DFrame Panel

# Constants
NEW SizeX 400
NEW SizeY 800

NEW Title Sexy ASM

# Call
SYS SetSize Panel SizeX SizeY
SYS Center Panel

SYS SetTitle Panel Title
SYS MakePopup Panel

RBL