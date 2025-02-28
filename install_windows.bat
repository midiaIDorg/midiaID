@echo off
setlocal enabledelayedexpansion

:: Define allowed arguments
set "possible_pipelines=stable experimental"
set "possible_pipelines_string=stable|experimental"

:: Show usage function
:show_usage
echo Install pipeline with:
echo.
echo ./install [%possible_pipelines_string%]
echo.
exit /b 1

:: Check if an argument is provided
if "%~1"=="" goto show_usage

:: Check if the argument is valid
set "is_valid=0"
for %%p in (%possible_pipelines%) do (
    if "%~1"=="%%p" set "is_valid=1"
)

if !is_valid! equ 0 (
    echo Error: Invalid argument, %~1.
    goto show_usage
)

echo You have chosen to install the '%~1' pipeline.
echo RUNNING: docker pull tenzerlab/midiaid:%~1
docker pull tenzerlab/midiaid:%~1
