;~* Sinden Profiler - Coded by Hexxed
;~* This AHK allows you to easily swap out different Config files to/from the Sinden Lightgun Application (hereafter known as Profiles).
;~* Make sure to place this AHK (or compiled exe) into it's own folder. Doesn't really matter where.
;~* The first time this program is run it will create a Configs folder and prompt you for where the Sinden lightgun app is currently installed.
;~* Choose the exe file (default is Lightgun.exe) in the Sinden Lightgun folder. It will be automatically saved in an ini so is only needed the first time this is ever run.
;~* You can call the new Profiles anything you want from No Recoil to Automatic Recoil to Rambo Mode to Afternoon settings to Night Time Dim. The options are endless.
;~* This program can be run while the Sinden App is still running so you can make a change in the Sinden App, click Save Settings in that app and then click New Profile in here and it will save the values to your new Profile.
;~* Go ahead and change whatever you want (remember to hit Save Settings in Sinden app first) and make as many Profiles as you want!
;~* The Sinden app needs to be shut down when a Profile is loaded however since the Sinden Lightgun app only takes the values on start up.
;~* This AHK can also be be used to load a Profile via another AHK or a command line and skip the GUI with the following call:
;~* SindenProfiler.ahk "Profile Name"
;~* To automatically stop the Sinden App then load the new Profile add -s (Example: SindenProfiler.ahk -s "Profile Name")
;~* To automatically stop the Sinden App, load the new Profile and then restart the Sinden app again add -ss (Example: SindenProfiler.ahk -ss "Profile Name")
;~* If you want to return to your previous Sinden Profile, just send SindenProfiler.ahk Restore and everything will be back the way it was.
;~* This was coded for a single instance of Sinden software however you can have 2 copies (in different folders) and then run 1 for 1 instance of Sinden and another for the 2nd.
;~* If you have any issues or move the Sinden program folder, just delete the SindenProfiler.ini file in the AHK folder and it will start fresh or click Tools - Change Sinden Folder
;~* If you still have any issues, you probably know where to find me. ;) (Likely on the Sinden Discord server.) Have fun! Hexxed

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; add the check to make sure the ini file exists, if not create
Global SindenConfigFile1
Global SindenEXE1
IniRead, SindenConfigFile1, SindenProfiler.ini, Folders, SindenConfigFile1
IniRead, SindenEXE1, SindenProfiler.ini, Programs, SindenEXE1
Global ConfigsPath := A_ScriptDir . "\Configs"

If !FileExist(ConfigsPath)	{	; If the Configs folder doesn't exist then make it
	 FileCreateDir, %ConfigsPath%	; Create a folder called Configs in the same folder as this ahk
}

if (SindenConfigFile1 = "ERROR" or SindenConfigFile1 = "" or SindenEXE1 = "ERROR" or SindenEXE1 = "" ) {		; Means this hasn't been run before so need to find the Sinden folder
	MsgBox,,Please locate the Sinden program, Can't locate Sinden Executable file. `nIt will likely be called "Lightgun.exe"`nPlease select it next.
	FileSelectFile, SelectedFile, 3, , Please select the Sinden Executable file. It will likely be called "Lightgun.exe", Exe File (*.exe)	; Ask the user to find the Sinden exe file
		if (SelectedFile = "") {
			MsgBox, You need to select the Sinden exe file to continue. Restart to try again.
			ExitApp
		}
		else {
			MsgBox, Saving the following path as the primary Sinden lightgun file: `n%SelectedFile%	
			IniWrite, %SelectedFile%, SindenProfiler.ini, Programs, SindenEXE1
			SindenExe1 := SelectedFile
			SindenConfigFile1:= SelectedFile . ".Config"
			IniWrite, %SindenConfigFile1%, SindenProfiler.ini, Folders, SindenConfigFile1
		}
}

	switch A_Args.Length()
	{
	case "0":	; Prompt for new config file name to be saved
	
	case "1":  ; Backup existing Sinden Config file and overwrite main .Config with supplied name
			param := A_Args[1]  ; Fetch the contents of the variable whose name is contained in A_Index.
			BackupConfig := SindenConfigFile1 . ".Backup"
			if (param = "Restore") {	; Restore the Backup to the main Config
				MsgBox Restoring orginal Profile
				if FileExist(BackupConfig) {		; Verify that the Backup file exists
					FileCopy, %BackupConfig%, %SindenConfigFile1%, true	; Restore the Sinden Config from the backup
					ExitApp
				}
			}
					
			NewConfigFile := ConfigsPath . "\" . param
			if FileExist(NewConfigFile) {		; Verify that the file as specified exists
				FileCopy, %SindenConfigFile1%, %BackupConfig%, true	; Make a backup of the Sinden Config
				FileCopy, %NewConfigFile%, %SindenConfigFile1%, true	; Copy the new config over the Sinden Config file
			}
			else {
				NewConfigFile := NewConfigFile . ".Config"	; Verify that they just didn't send the .Config extension so add it and reVerify
				if FileExist(NewConfigFile) {  
					FileCopy, %SindenConfigFile1%, %BackupConfig%, true	; Make a backup of the Sinden Config
					FileCopy, %NewConfigFile%, %SindenConfigFile1%, true	; ; Copy the new config over the Sinden Config file
				}
				Else
					MsgBox The Profile "%param%" cannot be found. Please make sure it exists or that you've entered it correctly.
			}
		ExitApp
		Return
		
		
	case "2": 	; 2 values were passed. If -s then just stop the Sinden App and load profile. If -ss then also restart it.
		SSFlag:= ""
		ProfName:= ""
		for n, param in A_Args  ; For each parameter:
		{
			Switch param {
			case "-ss":
				SSFlag:= "ss"
			case "-s":
				SSFlag:= "s"
			default:
				ProfName:= param
			}
			;msgbox Parameter number %n% is %param%.
		}
		
		if (SSFlag = "" or ProfName = "") {
			MsgBox,,Sinden Profiler - Invalid parameters detected.,If a Profile with spaces in the name is being sent, please enclose the name in quotation marks.`n`nIf you meant to include a Stop command then the proper syntax is SindenProfiler.ahk -s "Profile Name" `n`nIf you meant to include a Stop/Start command the proper syntax is SindenProfiler.ahk -ss "Profile Name"
			ExitApp
		}
		
		StopProg1()
		Sleep, 500
		NewConfigFile := ConfigsPath . "\" . ProfName . ".Config"
		BackupConfig := SindenConfigFile1 . ".Backup"
		if FileExist(NewConfigFile) {  
			FileCopy, %SindenConfigFile1%, %BackupConfig%, true	; Make a backup of the Sinden Config
			FileCopy, %NewConfigFile%, %SindenConfigFile1%, true	; ; Copy the new config over the Sinden Config file
		}
		Else {
			MsgBox,,Sinden Profiler - Invalid Profile,The Profile "%ProfName%" cannot be found. Please make sure it exists or that you've entered it correctly.
			ExitApp
		}
		Sleep, 1000
		
		if (SSFlag = "ss")
			StartProg1()
		Sleep, 1000
		
		ExitApp
		Return
	
	default:
		MsgBox Multiple parameters detected. If a single file with spaces in the name is being sent, please enclose the name in quotation marks.
		ExitApp
		Return
	}

	; Create the sub-menus for the menu bar:
	Menu, ToolsMenu, Add, Open Sinden Folder, OpenSindenFolder
	Menu, ToolsMenu, Add, Change Sinden Folder, ChangeSindenFolder
	Menu, ToolsMenu, Add, Open Profile Folder, OpenProfileFolder
	Menu, ToolsMenu, Add, Rescan Profiles Folder, Rescan
	
	Menu, HelpMenu, Add, Help, Help
	Menu, HelpMenu, Add, &About, About

	; Create the menu bar by attaching the sub-menus to it:
	Menu, MyMenuBar, Add, &Tools, :ToolsMenu
	Menu, MyMenuBar, Add, &Help, :HelpMenu
	
	; Attach the menu bar to the window:
	Gui, Menu, MyMenuBar

	Gui, Add, Text, x20 y20, Sinden Profiles:
	Gui, Add, ListBox, x20 y40 w200 r14 vMyListBox gMyListBox 
	Gui, Add, Button, x240 y40 w100 h30 vNew gNew, New Profile
	Gui, Add, Button, x240 y78 w100 h30 vLoad gLoad, Load Profile
	Gui, Add, Button, x240 y116 w100 h30v Rename gRename, Rename Profile
	Gui, Add, Button, x240 y154 w100 h30 vDelete gDelete, Delete Profile
	Gui, Add, Button, x240 y192 w100 h30 vDuplicate gDuplicate, Copy Profile
		
	Gui, Add, Button, x20 y240 w100 h30 gStopProgram1, Stop Sinden App
	Gui, Add, Button, x120 y240 w100 h30 gStartProgram1, Start Sinden App
	
	Gui, Add, Button, x240 y300 w100 h30 Default gClose, Close

	LoadProfiles()

	Gui, Show, w360 h350, Sinden Profiler
Return

About:
	msgbox,,Sinden Profiler - Coded by Hexxed,This AHK allows you to easily swap out different Config files to/from the Sinden Lightgun Application (hereafter known as Profiles).`n`nMake sure to place this AHK (or compiled exe) into it's own folder. Doesn't really matter where.`n`nThe first time this program is run it will create a Configs folder and prompt you for where the Sinden lightgun app is currently installed.`n`nChoose the exe file (default is Lightgun.exe) in the Sinden Lightgun folder. It will be automatically saved in an ini so is only needed the first time this is ever run.`n`nYou can call the new Profiles anything you want from No Recoil to Automatic Recoil to Rambo Mode to Afternoon settings to Night Time Dim. The options are endless.`n`nThis program can be run while the Sinden App is still running so you can make a change in the Sinden App, click Save Settings in that app and then click New Profile in here and it will save the values to your new Profile.`n`nGo ahead and change whatever you want (remember to hit Save Settings in Sinden app first) and make as many Profiles as you want!`n`nThe Sinden app needs to be shut down when a Profile is loaded however since the Sinden Lightgun app only takes the values on start up.`n`nThis AHK can also be be used to load a Profile via another AHK or a command line and skip the GUI with the following call:`n`nSindenProfiler.ahk "Profile Name"`n`nTo automatically stop the Sinden App then load the new Profile add -s (Example: SindenProfiler.ahk -s "Profile Name")`n`nTo automatically stop the Sinden App, load the new Profile and then restart the Sinden app again add -ss (Example: SindenProfiler.ahk -ss "Profile Name")`n`nIf you want to return to your previous Sinden Profile, just send SindenProfiler.ahk Restore and everything will be back the way it was.`n`nThis was coded for a single instance of Sinden software however you can have 2 copies (in different folders) and then run 1 for 1 instance of Sinden and another for the 2nd.`n`nIf you have any issues or move the Sinden program folder, just delete the SindenProfiler.ini file in the AHK folder and it will start fresh or click Tools - Change Sinden Folder`n`nIf you still have any issues, you probably know where to find me. (Likely on the Sinden Discord server.)`n`nHave fun and enjoy! Hexxed
return

Help:
	MsgBox,, Sinden Profiler Help File,New Profile - Prompts for a new Profile Name and then copies the current Sinden app settings over to new Profile.`n`nLoad Profile - Makes a backup of current Sinden App Profile and then loads the selected Profile from the list. Sinden App must be off for it to work.`n`nRename Profile - Prompts you to rename the currently highlighted Profile in the list.`n`nDelete Profile - Deletes the currently highlighted Profile in the list.`n`nCopy Profile - Prompts you for a name and then copies the currently highlighted Profile in the list.`n`nStop Sinden App - Stops the Sinden app.`n`nStart Sinden App - Starts the Sinden app`n`nChange Sinden Folder - Allows you to reselect the Sinden App if moved or changed location.
Return

LoadProfiles(){
	ConfigDir := ConfigsPath . "\*.Config"
	Loop, %ConfigDir%  ; Change this folder and wildcard pattern to suit your preferences.
	{
		ConfigName:= StrReplace(A_LoopFileName, ".Config")
		GuiControl,, MyListBox, %ConfigName%
	}
}

MyListBox:
	if (A_GuiEvent != "DoubleClick")
		return
	; Otherwise, the user double-clicked a list item, so treat that the same as pressing Load Profile.
	; So fall through to the next label.
Load:
	GuiControlGet, MyListBox  ; Retrieve the ListBox's current selection.
	if (MyListBox == ""){
		MsgBox,,No Profile Selected, Please select an existing Profile to the left to load.
		Return
	}
	
	MsgBox, 4,Sinden Profiler, Would you like to load the following Sinden Profile?`n`n%MyListBox%
	IfMsgBox, No
		return
	
	NewConfigFile := ConfigsPath . "\" . MyListBox . ".Config"
	BackupConfig := SindenConfigFile1 . ".Backup"
	if FileExist(NewConfigFile) {  
		FileCopy, %SindenConfigFile1%, %BackupConfig%, true	; Make a backup of the Sinden Config
		FileCopy, %NewConfigFile%, %SindenConfigFile1%, true	; ; Copy the new config over the Sinden Config file
	}
	Else
		MsgBox The Profile "%MyListBox%" cannot be found. Please make sure it exists or that you've entered it correctly.
	
Return

New:	
	InputBox, UserInput, Sinden Profile Maker, Please enter a name for new Sinden Profile. `nIf an existing file with the same name already exists it will be overwritten., ,
	if ErrorLevel {
		return
	}
	else {
		; Copy the Sinden Config file with the new name in the Configs folder - Overwrite if file already exists
		FullFileName:= ConfigsPath . "\" . UserInput . ".Config"
		;MsgBox, Saving new Sinden Profile as: %UserInput%
		FileCopy, %SindenConfigFile1%, %FullFileName%, 1  ; Copy the Sinden config
		Rescan()
	}	
Return

Rename:
	GuiControlGet, MyListBox  ; Retrieve the ListBox's current selection.
	if (MyListBox ==""){
		MsgBox,8192,No Profile Selected, Please select an existing Profile to the left to rename.
		Return
	}
	InputBox, UserInput, Sinden Profile Maker, Please enter a new name for this Sinden Profile. `nIf an existing Profile with the same name already exists it will be overwritten.,,,,,,,,%MyListBox%
	if ErrorLevel
		Return
	if (UserInput == MyListBox)
		Return
	ProfFolder:= A_ScriptDir . "\Configs\"
	FullFileName:= ConfigsPath . "\" . MyListBox . ".Config"
	;MsgBox, Saving new Sinden Profile as: %UserInput%
	NewFileName:= ProfFolder . UserInput . ".Config"
	if FileExist(NewFileName) {
		MsgBox,4,  Sinden Profiler - Confirmation, This Profile already exists. Do you want to overwrite it?
		IfMsgBox, No
			Return
	}
	FileMove, %FullFileName%, %NewFileName%, 1  ; Move and rename the selected Sinden Profile
	Rescan()
Return

Duplicate:
	GuiControlGet, MyListBox  ; Retrieve the ListBox's current selection.
	if (MyListBox == ""){
		MsgBox,8192,No Profile Selected, Please select an existing Profile to the left to duplicate.
		Return
	}
	InputBox, UserInput, Sinden Profile Maker, Please enter a new name for this Sinden Profile. `nIf an existing Profile with the same name already exists it will be overwritten.,,,,,,,,%MyListBox%
	if ErrorLevel
		Return
	if (UserInput == MyListBox)
		Return
	ProfFolder:= A_ScriptDir . "\Configs\"
	FullFileName:= ConfigsPath . "\" . MyListBox . ".Config"
	;MsgBox, Saving new Sinden Profile as: %UserInput%
	NewFileName:= ProfFolder . UserInput . ".Config"
	if FileExist(NewFileName) {
		MsgBox,4,  Sinden Profiler - Confirmation, This Profile already exists. Do you want to overwrite it?
		IfMsgBox, No
			Return
	}
	FileCopy, %FullFileName%, %NewFileName%, 1  ; Copy and rename the selected Sinden Profile
	Rescan()
Return

Delete:
	GuiControlGet, MyListBox  ; Retrieve the ListBox's current selection.
	if (MyListBox ==""){
		MsgBox,8192,No Profile Selected, Please select an existing Profile to the left to delete.
		Return
	}
	MsgBox, 4,Sinden Profiler - Confirmation, Would you like to delete the following Sinden Profile?`n`n%MyListBox%
	IfMsgBox, No
		Return
	ProfFolder:= A_ScriptDir . "\Configs\"
	FullFileName:= ProfFolder . MyListBox . ".Config"
	FileDelete, %FullFileName%
	Rescan()
Return

OpenSindenFolder:
	SplitPath, SindenEXE1,, dir
	Run, Explorer %dir%	; Open Sinden folder with Windows Explorer
Return

OpenProfileFolder:
	Run, Explorer %ConfigsPath%	; Open Configs (Profiles) folder with Windows Explorer
Return

ChangeSindenFolder:
	MsgBox,,Please locate the Sinden program, Locate Sinden Executable file. `nIt will likely be called "Lightgun.exe"`nPlease select it next.
	FileSelectFile, SelectedFile, 3, , Please select the Sinden Executable file. It will likely be called "Lightgun.exe", Exe File (*.exe)	; Ask the user to find the Sinden exe file
	if (SelectedFile = "") {
		MsgBox, You need to select the Sinden exe file to continue. Try again.
	}
	else {
		MsgBox, Saving the following path as the primary Sinden lightgun file: `n%SelectedFile%	
		IniWrite, %SelectedFile%, SindenProfiler.ini, Programs, SindenEXE1
		SindenConfigFile1:= SelectedFile . ".Config"
		IniWrite, %SindenConfigFile1%, SindenProfiler.ini, Folders, SindenConfigFile1
	}
Return

StopProgram1:
	StopProg1()
Return

StopProg1(){
	GroupAdd, lightgunInstances, ahk_exe %sindenEXE1%
	WinClose, ahk_group lightgunInstances
	Sleep, 200
	RunWait, taskkill /f /t /im %sindenEXE1%,, Hide UserErrorLevel
}

StartProgram1:
	StartProg1()
Return

StartProg1(){
	Run, %SindenEXE1% autostart, %SindenEXE1%
}

Rescan:
	Rescan()
Return

Rescan() {
	GuiControl,, MyListBox, |
	LoadProfiles()
}

Run:
	Run SindenProfiler.ahk -ss Restore
Return


Close:
GuiClose:
ExitApp
