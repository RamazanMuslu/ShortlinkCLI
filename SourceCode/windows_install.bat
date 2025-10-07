@echo off
setlocal

echo.
echo ######################################################
echo # shortlink CLI Application Setup (Windows)
echo ######################################################
echo.

REM --- Variables ---
set TOOL_NAME="shortlink"
set DEST_DIR="%USERPROFILE%\shortlink-cli"
set SOURCE_FILE="source\windows\shortlink.py"  REM Windows-specific source file
set DEST_PY_FILE="%DEST_DIR%\shortlink.py"
set DEST_CMD_FILE="%DEST_DIR%\shortlink.cmd"
REM -----------------

REM -----------------------------------------------------------
REM 1. Winget Check and Python Installation
REM -----------------------------------------------------------
echo [INFO] Checking Python and dependencies...

REM Check for Winget
winget --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] 'winget' not found. Cannot install Python automatically.
    echo Please install Winget or Python manually first.
    pause
    goto :eof
)

REM Check for Python 3
python --version >nul 2>&1
if errorlevel 0 (
    echo [SUCCESS] Python is already installed.
) else (
    echo [INFO] Python 3 is not installed, installing via Winget...
    winget install Python.Python.3 --silent --scope machine
    if errorlevel 1 (
        echo [ERROR] Python installation via Winget failed.
        pause
        goto :eof
    )
    echo [SUCCESS] Python installation complete.
)

REM -----------------------------------------------------------
REM 2. Check and Install Pip Dependencies (requests)
REM -----------------------------------------------------------
echo [INFO] Checking 'requests' library...

REM Check for requests library
pip show requests >nul 2>&1
if errorlevel 0 (
    echo [SUCCESS] 'requests' library is already installed.
) else (
    echo [INFO] Installing 'requests' library...
    pip install requests
    if errorlevel 1 (
        echo [ERROR] 'requests' installation failed. Ensure you have internet access.
        pause
        goto :eof
    )
    echo [SUCCESS] 'requests' library installation complete.
)


REM -----------------------------------------------------------
REM 3. Copying Files and Setting PATH
REM -----------------------------------------------------------
echo [INFO] Installing application files and setting PATH...

REM Check if source file exists
if not exist %SOURCE_FILE% (
    echo [ERROR] Source file '%SOURCE_FILE%' not found! Make sure to run the script from the root directory.
    pause
    goto :eof
)

REM Create destination directory
mkdir %DEST_DIR% >nul 2>&1
echo [SUCCESS] Destination directory created: %DEST_DIR%

REM Copy the Python file
copy %SOURCE_FILE% %DEST_PY_FILE% >nul
echo [SUCCESS] File copied: shortlink.py

REM Create shortlink.cmd file (The entry point for the command)
echo @echo off > %DEST_CMD_FILE%
echo python %DEST_PY_FILE% %%* >> %DEST_CMD_FILE%
echo [SUCCESS] Command runner created: shortlink.cmd

REM Add to PATH (Permanently adds to User's PATH)
set PATH_TO_ADD=%DEST_DIR%

REM Check if already in PATH
where shortlink.cmd >nul 2>&1
if errorlevel 0 (
    echo [INFO] Command is already callable from PATH.
) else (
    echo [INFO] Adding directory to PATH...
    setx PATH "%%PATH%%;%PATH_TO_ADD%"
    echo [SUCCESS] Directory permanently added to PATH.
    echo [NOTICE] Please open a new Terminal/CMD window for the change to take effect.
)

echo.
echo ######################################################
echo [SETUP COMPLETE]
echo Open a new Terminal/CMD and use: shortlink https://your-url.com
echo ######################################################

endlocal
pause