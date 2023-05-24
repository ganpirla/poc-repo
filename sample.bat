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


=======



@echo off

set "userfile=usernames.txt"
set "domain1=domain1"
set "domain2=domain2"

for /f %%u in (%userfile%) do (
    echo Checking user: %%u in Domain 1
    net user %%u /domain:%domain1% | findstr /C:"User name" /C:"Account active"
    echo.

    echo Checking user: %%u in Domain 2
    net user %%u /domain:%domain2% | findstr /C:"User name" /C:"Account active"
    echo.
)

pause

