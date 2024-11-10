## Usage
Basic usage is very simple, add the Lua file to your project and then call whichever global you need. 
```
  Seed:ToBytes( function Pointer, number Shift ) -> Generate a table of bytes based on a memory address.
  Seed:Generate( number Size, optional number Shift ) -> Generate a random seed using address memory with optional shift. 
  Seed:GenerateNumber( number Minimum, number Maximum ) -> Random number using the generation function.
```

> [!IMPORTANT]
> Don't use this on the same realm (especially if it's clientside) because otherwise you can just detour or use modules to find the seed with minimal effort.
