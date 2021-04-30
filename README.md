Created: 
Creted By: JRW254
Version: 1.0

For easy use of the Virtual Desktop on a Window's machine. 

This is just a cobbled together script of the following:

Combined the entire contents of VirtualDesktopAccessor.dll: https://github.com/Ciantic/VirtualDesktopAccessor (Just used the example)
Took one function {Move Windows Around} from Mr. Doge's script here: https://www.autohotkey.com/boards/viewtopic.php?f=6&t=82994
Used a function from Windows Desktop Switcher by pmb6tz (Toggle Pin/Unpin Windows&Apps): https://github.com/pmb6tz/windows-desktop-switcher/issues/55

Add the GUI's myself. They can be and are encouraged to be changed to your liking. Just a simple templete I quickly used and repeated. 


In the VDHub_Func you might need to point the script to the VirtualDesktopAccessor.dll location if you find yourself unable yo switch beween virtual desktops. You can find it on line 85. 

Also, you will probably want to chage the coordinates of the Desktop GUI's, which is a variable located on line 161. The variable that holds the coordinates for the "VD Hub On" GUI is located within VDHub_Controls.


::Installation::
Make sure that you have the following three items in the same folder:
1. VDHub_Controls.ahk
2. VDHub_Func.ahk
3. VirtualDesktopAccessor.dll
