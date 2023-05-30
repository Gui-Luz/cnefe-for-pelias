@echo off
set "url=http://ftp.ibge.gov.br/Censos/Censo_Demografico_2010/Cadastro_Nacional_de_Enderecos_Fins_Estatisticos/"

set "curl_command=curl -O -J -L"

echo Downloading files from %url%
echo.

REM Create a "data" directory if it doesn't exist
if not exist data mkdir data

REM Navigate to the "data" directory
cd data

REM Recursive function to download ZIP files
:DownloadFiles
for /f "delims=" %%f in ('curl -s %url%') do (
    echo Downloading %%~nxf
    %curl_command% %url%%%f
)

REM Move up one level
cd ..

echo.
echo Download completed.
