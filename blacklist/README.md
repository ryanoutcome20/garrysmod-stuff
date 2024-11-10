## Usage
Execute the desired dumper version based on the API being used by Facepunch at that point in time. All scripts need to be executed through menustate and the blacklisted server information will be dumped to your data folder.

> [!IMPORTANT]
> Directory will be `data/blacklist_dumper/` with the desired files located inside.

## Contribution
If Facepunch updates their API, I will gladly update the Github with a new file or improve an existing one. If you make a pull request or have an issue, I'll be sure to get back to you as soon as possible.

## Bypassing
In order to bypass the blacklist of your server, you must first identify the blacklist method being used (map, gamemode, etc.) and then change that desired option. It's unlikely for Facepunch to blacklist servers hosted on Cloudflare or other third-party routing services; therefore, it's highly recommended to employ one of these before opening your server for the first time.

If your server is indeed blacklisted, follow the following steps:
- Dump the contents of Facepunches blacklisted server API to find what you were blacklisted with.
- If it was an IP blacklist, then simply change hosts or your routing IP address.
- If it was gamemode simply adjust the title located inside your gamemode. The text file will be named after the gamemodes root directory.
  - Example being: `Hogwarts` would be located in `garrysmod/gamemodes/Hogwarts/hogwarts.txt`.
- If it was description simply follow the same steps as gamemode. Execpt in this case change the root directory name.
  - Example being: `garrysmod/gamemodes/Hogwarts` would be changed to `garrysmod/gamemodes/HogwartsExample`.
- If it was a hostname then simply change the name of your server. 
  - If you'd like to keep the same name, then use invalid ASCII characters such as one from [this website](https://emptycharacter.com/).
- If it was a map, then simply change the name of the map via BSP file.
  - BSP file will be located in `garrysmod/maps`, if you do not have it here then extract it from the workshop with a tool like [gmpublisher](https://github.com/WilliamVenner/gmpublisher). Afterwards edit your start batch file to use the new map name. 

Overall, the security of the blacklist system is terrible and very easily bypassed. I really did expect more and was vastly disappointed.

If you'd like, you can actually develop a module to spoof this information dynamically and allow your server to be very difficult to blacklist. If this repository gets taken down or Facepunch decides to start being more aggressive with blacklisting servers, then I will release the dynamic spoofer.

## Unused Features
Some of the blacklist options inside the API are no longer used, such as `Translations` and `TranslatedHostnames`. If they do start to be used again, the Github will be swiftly updated with a fixed version, and I will try to give a good way to bypass it in the bypass section.
