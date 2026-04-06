# ![Awakener's Orb](https://web.poecdn.com/image/Art/2DItems/Currency/TransferOrb.png) Geforce NOW **bridge** for Awakened PoE Trade

### reddit
https://www.reddit.com/r/pathofexile/comments/1sdav1w/comment/oekwj0z/

### Hotkey Usage

All Hotkeys are changeable in script - comfortable by a GUI

The standard hotkeys are:

| F4 | F5 | F6 | F7 | F9 | F11 |
|-----|-----|------|--------|----------|----------|
| invite trader| goto hideout | price check | open steam overlay | send thanks in local chat | force close script |

### Requirements

-  [GFNPoEPriceCheck.au3](Https://github.com/KloppstockBw/GFNPoEPriceCheck/blob/main/GFNPoEPriceCheck.au3)
  (Alternatively the [GFNPoEPriceCheck.exe](https://github.com/KloppstockBw/GFNPoEPriceCheck/raw/main/GFNPoEPriceCheck.exe) , but you get a smartscreen warning the first run because I'm not going to buy a certificate to sign the exe as trustworthy)
  
- Autoit (Only if you use the .au3 Version) https://www.autoitscript.com/site/autoit/downloads/
  
- Awakened POE Trade
  https://github.com/SnosMe/awakened-poe-trade

- Path of exile for **Steam** in Geforce NOW (GGG Version does not work) 

### Features

- No need to change Awakened PoE Trade settings
- Copy Item Details in background (except in GeForce NOW) 
- config file in documents/mygames/Path Of EXILE containing:
  - URL to google.docs
  - setup status done
  - Hotkey setup
  - F9 message with standard value for thanks
  - Mouse position to paste item details in GFN
  - Auto start awakened Poe trade if wanted
- more to come - I welcome any ideas

### Install
**Video Guide** 
https://www.youtube.com/watch?v=K87GRUXJLl0

1. Create a https://docs.google.com/document/create Google document and share it to everyone wit edit rights
2. Run awakened PoE trade
3. Run GFNPoEPriceCheck
4. Decide in script if you want to autorun awakened on script start (recommended)
5. Show the script where the awakened PoE trade input field is. You have to click on the "Ctrl + V price check" field
6. Copy the URL of your Google document and paste it in the script
7. Change default Website in Steam overlay to the your google document's URL.
8. Open GeForce Now and set Steam overlay default key to F7. Click to "Web browser" button. It will show your google doc. After that click F7 again to hide Steam overlay. So you should leave browser window open
9. Have fun price checking in GeForce NOW

If you have issues you can either delete config or change hotkey by clicking on the icon in tray

![Screenshot 2023-11-10 234637](https://github.com/KloppstockBw/GFNPoEPriceCheck/assets/147773628/768c64b9-7170-4d4e-a0f7-3f18c1586b91)

# Troubleshooting
## When I press F6 in GFN nothing is happening
Check your hotkeys in Awakened Poe Trade. If you have changed it it has to be revert to default settings. Steps to fixing:
1. Check Awakened Poe Trade debug log. If you see something like this:
```
[20:53:28] error [Shortcuts] Failed to register a shortcut "F5". It is already registered by another application.
[20:53:28] error [Shortcuts] Failed to register a shortcut "F6". It is already registered by another application.
```
2. Revert hotkeys to default or just reinstall Awakened Poe Trade.

## When I try to check prices I see the "Record clip" window instead
If you have Zoom Workspace installed, it will conflict with script's shortcuts. What to do:
1. Open Zoom Workspace 
2. Go to Settings → Keyboard shortcuts
3. Change "Record clip" global hotkey or just disable it.

You also could close Zoom before playing - **I strongly recommend that!**

## I entered the game and the hotkey F5 does not send me to hideout
At the same time, "/" is printed in the chat. What to do:

1. Try checking the price of any item
2. If everything works, try f5 again, it should work
3. If it doesn't work, try resetting the configuration

## docs.google.com is either empty or not public
<img width="409" height="276" alt="image" src="https://github.com/user-attachments/assets/96d088a8-03f3-4f66-ac64-ce37d9237738" />

This problem is probably caused by the fact that the Google document does not open and/or the web browser in Steam is not selected as the default tab. What to do:

1. Press F7, your web browser should open.
2. If something other than a browser opens, on the bottom panel in Steam, click on the browser, a Google document should open
<img width="837" height="150" alt="image" src="https://github.com/user-attachments/assets/0e78af9d-5da2-4520-9af1-e475a618b0e4" />

3. Now press F7 again, the overlay will disappear
4. Try checking the price, it should work

## When I try to check prices I only see Awakened Poe Trade main page and no price check
It's probably because you didn't show the script exact location of "Ctrl + V price check" field. Steps to fixing:
1. Right click on script in tray → Reset config
2. On the last step point to the field.

# To do 
- troubleshooting
- Gui to change config and stuff
  
### How it works - short story

- it asks the user for various inputs and safes them to config file
- if the config files contains value it skips the inputs
- in gfn it sends the item details to the steam build in browser where the home page is set to the docs google by the user
- on local PC the scrips reads the docs google site content and copy it to the clipboard
- the scrips renames the gfn window to "Path of exile" so the awakened tool detects it as poe
- finally the scripts copys the data to awakened inside of gfn poe
