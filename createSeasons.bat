@echo off
setlocal

:: Create the VBScript to prompt user input for the location for the season folders, the number of season folders to create, and whether or not to add the specials season folder
echo Set objShell = CreateObject("Shell.Application") > "%temp%\inputBox.vbs"
echo Set objFSO = CreateObject("Scripting.FileSystemObject") >> "%temp%\inputBox.vbs"
echo Set objFolder = objShell.BrowseForFolder(0, "Select Folder", 17, "") >> "%temp%\inputBox.vbs"
echo If objFolder Is Nothing Then >> "%temp%\inputBox.vbs"
echo     WScript.Quit >> "%temp%\inputBox.vbs"
echo End If >> "%temp%\inputBox.vbs"
echo Set objFolderItem = objFolder.Self >> "%temp%\inputBox.vbs"
echo strPath = objFolderItem.Path >> "%temp%\inputBox.vbs"
echo strNumFolders = InputBox("Enter the number of folders to create:", "Number of Folders", "1") >> "%temp%\inputBox.vbs"
echo intSpecials = MsgBox("Include 'Season 0' folder?", vbYesNo + vbQuestion, "Specials") >> "%temp%\inputBox.vbs"
echo WScript.Echo strPath ^& "," ^& strNumFolders ^& "," ^& intSpecials >> "%temp%\inputBox.vbs"

:: Run the VBScript and capture the input
for /f "tokens=1-3 delims=," %%i in ('cscript //nologo "%temp%\inputBox.vbs"') do (
    set "path=%%i"
    set "numFolders=%%j"
    set "includeSpecials=%%k"
)

:: Clean up the VBScript via deleting it
del "%temp%\inputBox.vbs"

:: Check if path is empty, exit if true
if "%path%"=="" (
    echo No path selected. Exiting.
    exit /b 1
)

:: Check if numFolders is empty, exit if true
if "%numFolders%"=="" (
    echo No number of folders entered. Exiting.
    exit /b 1
)

:: Create the specials folder first
if %includeSpecials%==6 (
    md "%path%\Season 0"
)

:: Create the season folders via for loop
for /l %%i in (1,1,%numFolders%) do (
    md "%path%\Season %%i"
)

:: Success
echo Folders created successfully!
pause
endlocal
