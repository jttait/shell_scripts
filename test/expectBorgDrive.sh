#!/usr/bin/expect -f

set timeout -1

spawn ./testBorgDrive.sh

expect "Enter new passphrase: "

send -- "password123\r"

expect "Enter same passphrase again: "

send -- "password123\r"

expect "Do you want your passphrase to be displayed for verification?* "

send -- "N\r"

expect "Enter choice: "

send -- "1\r"

expect "Enter passphrase for key*"

send -- "password123\r"

expect "Enter choice: "

send -- "3\r"

expect "Enter path to restore to: "

send -- "restore"

expect "Enter passphrase for key*"

send -- "password123\r"

expect "Enter passphrase for key*"

send -- "password123\r"

expect eof
