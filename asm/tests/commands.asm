# Get Command Function
CAP concommand.Add concommand.Add

# Print Constants
CAP MsgN MsgN

NEW Text Hello!

# Internal Command Callback
FUN Command SYS MsgN Text

# Name Constant
NEW Name Hello

# Call Command Function
SYS concommand.Add Name Command