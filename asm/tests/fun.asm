-- I am a comment
// I am a comment
#  I am a comment
;  I am a comment

/*
   We 
   are
   a
   comment
*/

.Test
   NEW[ "Example", 5 ]

   MUL[ "Example", 5 ]

   PRN[ "Example Equals: ", Example ]
.

# Main will be called automatically
.Main

# Code doesn't need to have proper indenting
CALL[ "Test" ]

   # Code can also have sub functions within a code block. They all access shared memory but its specific to this runtime, 
   # once another file is ran that file will have a custom metatable environment (setfenv).
   .Hello 
      PRN[ "Hello!" ]
   .

   CALL[ "Hello" ] # You can call it with or without the quotes.

   # Due to this design idea you can make names with spaces!
   .Example Test
      GET[ 1, "Value" ]

      PRN[ "Value" ]
   .

   CALL[ "Example Test", 25 ] # This is gonna print whatever you put in the second argument.
.