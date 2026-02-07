#!/usr/bin/expect -f

set timeout -1

spawn ./testResticDrive.sh

expect "enter password for new repository: "

send -- "password123\r"

expect "enter password again: "

send -- "password123\r"

expect "Enter choice: "

send -- "1\r"

expect "enter password for repository: "

send -- "password123\r"

expect "Enter choice: "

send -- "2\r"

expect "Enter location to restore to: "

send -- "./restore\r"

expect "enter password for repository: "

send -- "password123\r"

expect eof
catch wait result
exit [lindex $result 3]
