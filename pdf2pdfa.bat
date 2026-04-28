@echo off
setlocal enabledelayedexpansion

echo.
echo Script to convert PDF to PDF/A-3b
echo Version 1.1.0

REM =========================
REM === CONFIG
REM =========================
set "GS=gswin64c"
set "ICC_PATH=%~dp0..\iccprofiles\srgb.icc"

REM =========================
REM === CHECK GHOSTSCRIPT
REM =========================
"%GS%" -version >nul 2>nul
if errorlevel 1 (
    echo ERROR: Ghostscript not found or not working: "%GS%"
    goto :end
)

echo Using:
"%GS%" -version
echo.

REM =========================
REM === CHECK ICC PROFILE
REM =========================
if not exist "%ICC_PATH%" (
    echo ERROR: ICC profile not found at: "%ICC_PATH%"
    goto :end
)

REM =========================
REM === INPUT CHECK
REM =========================
if "%~1"=="" (
    echo Usage: pdf2pdfa ^<PDF/A version^> ^<file^|dir^> [output_dir]
    goto :end
)

set "PDFA=%~1"
set "INPUT=%~2"
set "OUT_DIR=%~3"

if not "%PDFA%"=="1" if not "%PDFA%"=="2" if not "%PDFA%"=="3" (
    echo ERROR: Invalid PDF/A version "%PDFA%"
    echo Allowed values: 1, 2, 3
    goto :end
)

echo Converting to PDF/A-%PDFA%
echo.

REM =========================
REM === FILE MODE
REM =========================
if exist "%INPUT%" if not exist "%INPUT%\" (

    if "%OUT_DIR%"=="" (
        set "OUT_FINAL=%CD%\_out"
    ) else (
        set "OUT_FINAL=%OUT_DIR%"
    )

    if not exist "!OUT_FINAL!" mkdir "!OUT_FINAL!" 2>nul

    echo Processing File: "%INPUT%"

    "%GS%" -q ^
      -dPDFA=%PDFA% ^
      -dBATCH -dNOPAUSE -dNOOUTERSAVE -dNOSAFER ^
      -sDEVICE=pdfwrite ^
      -dPDFACompatibilityPolicy=1 ^
      -sProcessColorModel=DeviceRGB ^
      -sColorConversionStrategy=UseDeviceIndependentColor ^
      -sOutputICCProfile="%ICC_PATH%" ^
      -sOutputFile="!OUT_FINAL!\%~nx2" ^
      -f "%INPUT%" 2>nul

    set "EXITCODE=%ERRORLEVEL%"
    goto :end
)

REM =========================
REM === DIRECTORY MODE
REM =========================
if exist "%INPUT%\" (

    if "%OUT_DIR%"=="" (
        set "OUT_FINAL=%INPUT%\_out"
    ) else (
        set "OUT_FINAL=%OUT_DIR%"
    )

    if not exist "!OUT_FINAL!" mkdir "!OUT_FINAL!" 2>nul

    for %%F in ("%INPUT%\*.pdf") do (
        echo Processing: %%~nxF

        "%GS%" -q ^
          -dPDFA=%PDFA% ^
          -dBATCH -dNOPAUSE -dNOOUTERSAVE -dNOSAFER ^
          -sDEVICE=pdfwrite ^
          -dPDFACompatibilityPolicy=1 ^
          -sProcessColorModel=DeviceRGB ^
          -sColorConversionStrategy=UseDeviceIndependentColor ^
          -sOutputICCProfile="%ICC_PATH%" ^
          -sOutputFile="!OUT_FINAL!\%%~nxF" ^
          -f "%%~fF" 2>nul
    )

    echo.
    echo Batch conversion complete - output dir: "!OUT_FINAL!"
    if errorlevel 1 set "EXITCODE=1"
    goto :end
)

REM =========================
REM === INVALID INPUT
REM =========================
echo ERROR: Input not found.
set "EXITCODE=1"
goto :end


REM =========================
REM === CLEAN EXIT
REM =========================
:end
endlocal & exit /b %EXITCODE%
