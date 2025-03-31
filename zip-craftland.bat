@echo off

REM Check if 7-Zip is installed in the system
where 7z >nul 2>nul
if errorlevel 1 (
    echo 7-Zip is not installed or not in the system PATH.
    exit /b
)

REM Check if a folder path was provided
if not "%~1"=="" (
    echo Usage: zip-craftland.bat
    exit /b
)

REM Get current directory
set "current_directory=%CD%"

REM Get current directory name
for %%I in ("%CD%") do set "current_folder=%%~nI"

REM Get the current date and time
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "datetime=%%a"

REM Extract year, month, day, hour, minute, and second from the retrieved datetime
set "year=%datetime:~2,2%"
set "month=%datetime:~4,2%"
set "day=%datetime:~6,2%"
set "hour=%datetime:~8,2%"
set "minute=%datetime:~10,2%"

REM Combine the extracted date and time components into the YYMMDDHHMMSS format
set "formatted_datetime=%year%%month%%day%%hour%%minute%"

REM Make the folder containing both the name of the current folder and the time
set "new_directory=..\%current_folder%-%formatted_datetime%"

REM Check if the directory exists
if exist "%directory_name%" (
    echo Directory already exists. Deleting...
    rd /s /q "%directory_name%"
    if errorlevel 1 (
        echo Failed to delete the directory.
    ) else (
        echo Directory deleted successfully.
    )
)

REM Create a new directory with the same name
mkdir "%new_directory%"
if errorlevel 1 (
    echo Failed to create the directory.
) else (
    echo Directory created successfully.
)

set "asset_directory=%current_directory%\Assets"
set "project_setting_directory=%current_directory%\ProjectSettings"
set "asset_meta=%current_directory%\Assets.meta"
set "behavior_json=%current_directory%\behavior.Json"
set "main_gproj=%current_directory%\main.gproj"
set "ProjectSettings_meta=%current_directory%\ProjectSettings.meta"

echo %asset_directory%

xcopy /s /e /i "%asset_directory%" "%new_directory%\Assets"
xcopy /s /e /i "%project_setting_directory%" "%new_directory%\ProjectSettings"
xcopy "%asset_meta%" "%new_directory%"
xcopy "%main_gproj%" "%new_directory%"
xcopy "%ProjectSettings_meta%" "%new_directory%"

REM Zip the specified folder using 7-Zip
echo Creating "%zip_name%" from "%new_directory%"...
set "zip_name=%new_directory%.zip"
7z a "%zip_name%" "%new_directory%"
if errorlevel 1 (
    echo An error occurred while creating the zip file.
) else (
    echo Zip file "%zip_name%" created successfully.
)

REM Delete the temporary folder
rmdir /s /q "%new_directory%"