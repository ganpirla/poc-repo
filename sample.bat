@echo off

set users=user1 user2 user3

for %%u in (%users%) do (
    echo Checking user: %%u
    net user %%u /domain | findstr /C:"User name" /C:"Account active"
    echo.
)

pause


======


@echo off

set "userfile=usernames.txt"

for /f %%u in (%userfile%) do (
    echo Checking user: %%u
    net user %%u /domain | findstr /C:"User name" /C:"Account active"
    echo.
)

pause

