# Flash Library
A simple Lua library that seeks to bring some basic math, string, and table operations to Lua. The Flash library also includes additional helper functions to help with debugging and other tasks.

This is an **internal** library for myself, it'll be built upon when I need extra things. If you'd like to contribute features or share ideas then submit a pull request or open an issue.

## Table of Contents
- [ Installation ](#installation)
- [ Loading the Library ](#loading-the-library)
- [Usage Examples](#usage-examples)
  - [Utility Functions](#utility-functions)
  - [String Functions](#string-functions)
  - [Math Functions](#math-functions)
- [Contributions](#contributions)

## Installation
Clone the repository or download the flash.lua file.

```bash 
git clone https://github.com/ryanoutcome20/flash-library.git
```

Place the flash.lua file into your files directory.

## Loading the Library
To load the Flash library, require the file in your Lua script via:

```lua 
require( 'flash' ) 
```

This will load the Flash table and all of its sub-libraries into your environment.

## Usage Examples

This is by no means a comprehensive list of functions included, please browse the file to find
all of the functions added.

### Utility Functions

**MsgN( ... )**

Prints the provided arguments with a newline.

```lua 
MsgN( 'Hello', 'World!' ) -- Output: Hello World! 
```

**PrintTable( Table )**

Prints a table recursively.

```lua 
local Table = { 
   Key = 'Value', 

   Key2 = { 
      nestedKey = 'Value2' 
   } 
} 

PrintTable( Table ) -- Output:
--[[
[ Key ] = Value
[ Key2 ] = table: 00A01630
  [ nestedKey ] = Value2
--]]
```

### String Functions

**string.starts( String, Text )**

Checks if a string starts with the text.

```lua 
print( string.starts( 'Hello World', 'Hello' ) ) -- Output: true 
```

**string.split( String, Separator )**

Splits a string by a given separator.

```lua 
print( string.split( 'a,b,c', ',' ) ) -- Output: { 'a', 'b', 'c' } 
```

**string.extension( File )**

Gets the extension from a path.

```lua 
print( string.extension( 'hello.lua' ) ) -- Output: 'lua' 
```

### Math Functions
**math.round( Number, Decimals )**

Rounds a number to the specified decimal places (optional).

```lua 
print( math.round( 3.14159, 2 ) ) -- Output: 3.14 
```

**math.randomfloat( Minimum, Maximum )**

Generates a random floating point number between the specified range.

```lua 
math.randomfloat( 1.0, 5.0 ) -- Output: Random float between 1.0 and 5.0 
```

### Contributions
Feel free to submit a pull request or open an issue if you find any bugs or have suggestions for improvements.

❤️
