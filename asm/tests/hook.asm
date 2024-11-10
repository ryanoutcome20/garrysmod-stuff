# Grab Hook
CAP hook.Add hook.Add

# Constants
CAP MsgN MsgN

NEW Text Hello!

# Internal Hook Callback
FUN Hook SYS MsgN Text

# Event Constant
NEW Event OnPlayerChat
NEW Name Test

# Call Hook Function
SYS hook.Add Event Name Hook