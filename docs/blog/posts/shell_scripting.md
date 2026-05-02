---
title: Power Tool - Shell Scripting 
date:
    created: 2026-04-29
    updated: 2025-04-29
categories: [Development]
tags:
    - Scripting
    - DevOps
authors:
  - hafiz
readtime: 10
slug: power_tool_shell_scripting
draft: false
---
Shell Scripting Skill is a nice addition to your power tool. It's power that most of the Dev don't have and must to have if you like automation.
<!-- more -->
## Introduction
!!! note "What is shell?"
    A program - that interprets the command you type in your terminal and passes them on to the operating system. i.e. bash - "Bourne Again Shell" | feature-rich, fast, very common

!!! note "What is a script?"
    A file containing commands for the shell. | Allows automation

### Structure of Bash Script

Starts with a `shebang` line. Then comes the actual command and then exit code. The exit code can be anything `0-255`. 
- `#` at the start of the line is comment.
- Five pieces of information make your script more professional.
  - `Author`
  - `Date Creation`
  - `Last Modified`
  - `Description`
  - `Usage`
- File Permission | There will be three group and three operations
  - Owner | Creator of the file | 
  - Group | Files group |
  - Public | Every User | 
    `r` for read, `w` for write, `x` for execute and `-` represent nonperishable. The sequence goes like `OOOGGGPPP`. For example `rwxrw-r--` represent Owner have all the permissions, group have read and write permission, and the public have the read permission only. The first char `d` says it's a directory and `-` says it's a file. `chmod` is used for modifying permission.
- To run script anywhere from  the machine, we need to add it in system `PATH` - a variable where the OS looks for the scripts. We need to add the script folder to the `PATH` 

```shell
#!/bin/bash

# Author: Hafizur Rahman
# Date Created: 2024-06-01
# Last Modified: 2024-06-01

# Description
# This script demonstrates the use of comments in a bash script.

# Usage
# To run this script, use the following command:
# bash script101.sh

# This a single line comment
echo "The script is a go."
exit 0
```

## Bash Syntax

`Paramater` - is any entity that store values. Three type of parameters in bash are:

- Variables | Values can manually be changed
- Positional parameters |
- Special parameters | 

### Variables

!!! note "Variables"
    Store reusable data under convenient names

- `name="value"` | No spaces before and after `=`. This is **User defined** variable and all lowercase.
- **Shell variables**
  - Bourne Shell Variables | 10 | `PATH`, `HOME` - Current Users home directory, `USER` - Current user user name, `HOSTNAME` - Current username, `HOSTTYPE` - The architecture of the current computer, `PS1` - Prompt structure | They have all Uppercase names
  - Bash Shell Variables | 95+

```bash
student_name="Hafizur Rahman"
echo "$student_name"
echo "Hello ${student_name}, welcome to the bash scripting course."
echo "You all Upper case name is: ${student_name^^} and only first letter lower case is: ${student_name,}"
echo "The length of the student name is: ${#student_name}"
echo "First three characters of the student name is: ${student_name:0:3}"

# Some Bourne shell variables
echo "The current user is: $USER"
echo "The current working directory is: $PWD"
echo "The home directory is: $HOME"
echo "The hostname is: $HOSTNAME"
echo "The computer architecture is: $HOSTTYPE"
```

#### output

```bash
Hafizur Rahman
Hello Hafizur Rahman, welcome to the bash scripting course.
You all Upper case name is: HAFIZUR RAHMAN and only first letter lower case is: hafizur Rahman
The length of the student name is: 14
First three characters of the student name is: Haf
The current user is: <user_name>
The current working directory is: <current_working_directory>
The home directory is: <directory>
The hostname is: ZTDKW39GPQ3MK
The computer architecture is: aarch64
```

### Shell Expansions

!!! note "Expansions"
    Retrieve data, process command output and perform calculations

### Parameter Expansion

Access - `${var_name}` reference the parameter. | This is called parameter expansion.

#### Some Tricks

- Case: `${var,}` First lowercase | `${var,,}` All lower | `${var^}` Capetalize | `${var^^}` All Upper
- Length: `${#var}` | Number of character
- Slicing: `${var:offset:length}` | Slicing a variable. Negative offset also possible but it will need additional `space` i.e. ` -3:2`

```bash

```

#### output

```bash

```

### Command Substitution

Similler to expansion, but here we use the command. We will look for the value that came-out after the `command` execution.
Syntax - `$(command)`

```bash
# Command Substitution
time_now=$(date +"%Y-%m-%d %H:%M:%S")
echo "The current date and time is: $time_now"
```

#### output

```bash
The current date and time is: 2026-04-30 00:12:03
```

### Aerithmentic Expansion

Syntax - `$((expression))` | Symbols `+`, `-`, `*`, `/`, `%`
But limited only with whole number. There is a workaround. we need to use `bc` command and `scale` variable to work with and set the decimal places. `bc` -> Bacis calculator | a programming language for aerithmetic operation.
Syntax - `scale=<number_of_decimal_value>` `expression` | `bc`
Example - `echo "scale=10 5/2 | bc`

```bash
# Arithmetic Expansion whole number
num1=10
num2=20
echo "Sum $((num1 + num2)), Difference $((num1 - num2)), Product $((num1 * num2)), Quotient $((num2 / num1)), Remainder $((num2 % num1))"

#Aerithmetic Expansion floating point number
num3=10.5
num4=20.5
echo "Sum $(echo "$num3 + $num4" | bc), Difference $(echo "$num3 - $num4" | bc), Product $(echo "$num3 * $num4" | bc), Division  $(echo "scale=2; $num4 / $num3" | bc), Quotient $(echo "$num4 / $num3" | bc)"
```

#### output

```bash
Sum 30, Difference -10, Product 200, Quotient 2, Remainder 0
Sum 31.0, Difference -10.0, Product 215.2, Division  1.95, Quotient 1
```

### Tilda Expansion

`~` | Shows the home directory
`~username` | Shows the `username`'s home directory

```bash
echo "The home directory is: ~ or $HOME"
echo "The current directory is $PWD or ~+"
echo "The previous directory is $OLDPWD or ~-"
```

#### output

```bash
The home directory is: ~ or <home_directory>
The current directory is <current_directory> or ~+
The previous directory is <previous_directory> or ~-
```

### Brace Expansion

String List | Syntax - `{}`
Range List | Syntax - `<prefix>{start..end..gap}`

```bash
# Brace Expansion
echo {a,19,z,barry,42}
echo {jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec}
echo {0..9}
echo {a..z}
echo {100..1..5}
echo roll{01..10}
echo month{01..5}/day{01..3}.txt
```

#### output

```bash
a 19 z barry 42
jan feb mar apr may jun jul aug sep oct nov dec
0 1 2 3 4 5 6 7 8 9
a b c d e f g h i j k l m n o p q r s t u v w x y z
100 95 90 85 80 75 70 65 60 55 50 45 40 35 30 25 20 15 10 5
roll01 roll02 roll03 roll04 roll05 roll06 roll07 roll08 roll09 roll10
month01/day01.txt month01/day02.txt month01/day03.txt month02/day01.txt month02/day02.txt month02/day03.txt month03/day01.txt month03/day02.txt month03/day03.txt month04/day01.txt month04/day02.txt month04/day03.txt month05/day01.txt month05/day02.txt month05/day03.txt
```

## How Bash Process Command Lines

Takes the Script | Read Line by Line | Do 5 Step Process => Execution

**Step-1** | **Tokenization:** Token - characters that is considered as a single unit.
Metacheracters (`| & ; () <> space tab newline`)
Word - Token without unquoted metacharacter
Operator - Token with unquoted metacharacter

- Control Operators (`Newline | || & && ; ;; ;& ;;& |& ( )`)
- Redirection Operators (`< > << >> <& >| <<- <> >&`)
  
Operator only matter when they are *unquoted*.

**Step-2** | **Command Identification:**
Simple Command | words terminated by control operator | `<command_name> <command_argument>` | `echo 12345` | 
Compound Command | Programming constructs: conditional, loop. | `<reserve_word> ..` |

**Step-3** | **Expansions:**

- Stage 1 | Brace Expansion
- Stage 2 |
  - Parameter Expansion
  - Arithmetic Expansion
  - Command Substitution
  - Tilda Expansion
- Stage 3 | Word Splitting | Process to split the result of some **unquoted** expansions (Parameter expansion, Command Substitution, Arithmetic expansions) into separate words | Split by `IFS` *Internal Field Seperator* (`space tab newline`) variable | `numbers="1 2 3";touch $numbers` will create 3 files `1`, `2`, `3` | `numbers="1,2,3";touch $numbers` will create only one file `1,2,3` | We can set `IFS` like `IFS=","`
- Stage 4 | Globbing | Only performed on words | Patterns contains `*`, `?`, `[]` unquoted | Example `file*.txt`, `file??.txt`, `file[abc][1-3].txt` | Search file only in the current directory

!!! info "Remember"
    If you want the output of a parameter expansion, arithmetic expansion, command substitution to be considered as a single world, **wrap the expansion in double quotes**.

!!! info Remember
    Stages run in sequence and expansion in same stage have same priority and performed as the order they found from left to right.

**Step-4** | **Quote Removal:** Remove all unquoted backslashes, single quote cheracters and double quote cheracters that did **not** result from a shell expansion.

**Step-5** | **Redirection:** Stream `0` Standard Input Stream => Provides alternative way to provide input, Stream `1` Standard Output Stream => data produced after successful command execution, Stream `2` Standard Error stream => Error messages and Status | `<` input | `cat < hello.txt` | `>`output, `2>` error output | `cd /root 2> error.txt` | `&>` Standard output and error | `>>` is used for append

### How Quoting works

Quoting ia bout Removing Special Meaning

- `\` | Remove meanig from next character
- `''` | Remove meaning from all charater inside
- `""` | Remove meaning from all except `$` sign and ``\`

```bash
# Quoting
echo jon & snow
echo jon\& snow
echo path C:\User\user_name\images
echo path 'C:\User\user_name\images'
echo path 'C:\User\$USER\images'
echo path "C:\User\\$USER\images"
```

#### Output

```bash
jon
./commands_anotomy: line 4: snow: command not found
jon& snow
path C:Useruser_nameimages
path C:\User\user_name\images
path C:\User\$USER\images
path C:\User\<user_name>\images
```

## Requesting User Input

### Positional parameter

Shell the the positional parameters and assign a number.`<script_name> positional_param_1 positional_param_2 ...`

```bash
echo "You are: $1"
echo "Your home directory is: $2"
echo "Your fav color is: $3"
# Let's make a calculator
echo $(( ${2:-0} $1 ${3:-0} )) # :-0 means if nothing is passed, use 0 as default value. The syntax is ${parameter:-word} where parameter is the variable and word is the default value if parameter is unset or null.
```

Executing the script: `./taking_user_input Hafiz $HOME Yello`

Output

```bash
You are: Hafiz
Your home directory is: <home_directory>
Your fav color is: Yello
```

### Special Parameters

> Parameters that Bash gives special meaning. Value of a special parameter is calculated for us based on our current script.

`$#` gives the number of positional provided.
`$0` give error message, name of the script is provided by this parameter.
`$*` As same as `$@` when unquoted, but when quoted `"$1" "$2" "$3" .. "$N"` but it uses the `IFS` and we can change the IFS if we need.
`$@` Access all the positional parameter and seperate them with `space` | `$1 $2 $3 .. $N`. But if we use `"$@"` you get `"$1" "$2" "$3" .. "$N"`.

!!! note "Remember"
    `“$@”` is the same as `$@`, except that `“$@”` stops word splitting from happening on the positional parameters

```bash
# Special parameter
echo "You have provided $# arguments"
echo "We are currently running the script: $0"
IFS=","
echo "All the arguments you have provided are: $@"
echo "We can also access the arguments: $*"
```

Executing the script: `./taking_user_input Hafiz $HOME Blue`

Output

```bash
You have provided 3 arguments
We are currently running the script: ./taking_user_input
All the arguments you have provided are: Hafiz <home_directory> Blue
We can also access the arguments: Hafiz,<home_directory>,Blue
```

### Read Command

`read` command wait for user input. We can also store them inside variable. We can also use `-p` option to prompt the user some messages before the input. `-t` is a timeout option also we can add. `-s` make the input secret. `-n` specifies the number of characters.

```bash
# User input with read
echo "Enter your name, surname and age: "
read user_name user_age
echo "Your name is: $user_name"
echo "Your age is: $user_age"

# Prompting user input with a message
read -p "Enter your village: " village
echo "You are from: $village"
read -t 5 -p "Memory teaser: What is the capital of France? " capital
if [ -z "$capital" ]; then
    echo "Time's up! You didn't answer the question."
else
    echo "Your answer is: $capital"
fi
read -s -p "Tell me a secret: " secret
echo -e "\nYour secret is: $secret"
read -n 5 -p "Enter a 5-character code: " code
echo -e "\nYour code is: $code"
```

### Select Command

> `select` gives the menu of options to select from. Syntax `PS3=<prompt>select <ver_name> in <spaced options>; do <commands> done`. If `<var_name>` is not given the selected item will be stored in `response`. Looping behavior is by default, we can use `^C` or a `break` command before `done`. `PS3` control the prompt for select.

```bash
# Select command
PS3="Please select a day of the week: "
select today in "Monday" "Tuesday" "Wednesday" "Thursday" "Friday"; do
    echo "You have selected: $today"
    break
done
```

## Logic

### Chaining Commands

- `&` | Sends the `before` command to background and continue the `after` command | Syntax `before & after` | Only care about the current job | Helps to run command asynchronously
- `;` | Runs the command in sequence | Syntax `before ; after` | Only care about the current Job
- `&&` |  Only run the `after` command if the `before` command is successful.
- `||`| Only run the `after` command if the `before` command is unsuccessful.

```bash
# Chaining Commands
echo 123 & echo 546
echo "before" ; echo "after"
ls unknown_directory ; echo "This will run"
ls unknown_another_directory && echo "This will not run"
ls unknown_yet_another_directory || echo "This will run because the previous command failed"
echo "This is successful" || ls unknown_directory # Second command will not run because the first command is successful
```

#### Output

```bash
546
before
after
123
ls: unknown_directory: No such file or directory
This will run
ls: unknown_another_directory: No such file or directory
ls: unknown_yet_another_directory: No such file or directory
This will run because the previous command failed
This is successful
```

### Test commands

> Command to compare different piece of information. Test will return an exit status `0` for success and `1`for failure. Written in between `[  ]`, make sure to include `space`. i.e. `[ 2 -eq 3 ]; echo $?`

- Numeric: We have `-eq`, `-ne`, `-gt`, `-lt`, `-geq`, `-leq`
- String: We have `=`, `!=`, `-z`|To check if empty, `-n`|Opposite of -z
- File: We have `-e`|If file exist, `-f`|If a regular file, `-d`|If a. directory, `-x`|If executable permission, `-r`, `-w`

```bash
# Test Command
# Numeric
echo "Testing numeric conditions"
[ 5 -eq 5 ]; echo $?
[ 5 -ne 5 ]; echo $?
[ 5 -gt 3 ]; echo $?
[ 5 -lt 3 ]; echo $?
[ 5 -ge 5 ]; echo $?
[ 5 -le 3 ]; echo $?

# String
echo "Testing string conditions"
[ "hello" = "hello" ]; echo $?
[ "hello" != "world" ]; echo $?
[ -z "" ]; echo $?
[ -n "not empty" ]; echo $?

# File
echo "Testing file conditions"
touch file1
[ -e file1 ]; echo $?
[ -f file1 ]; echo $?
[ -d file1 ]; echo $?
[ -x file1 ]; echo $?
[ -r file1 ]; echo $?
[ -w file1 ]; echo $?
rm file1
```

#### Output

```bash
Testing numeric conditions
0
1
0
1
0
1
Testing string conditions
0
0
0
0
Testing file conditions
0
0
1
1
0
0
```

### If Statement

Syntax - `if <test_command>; then <consequent_commands> elif <test_command>; then <consequent_commands> else <alternate_command>fi` | If the command exists with 0, will run | It's a better practice to write `consequent_commands` and `alternate_command` with a tab. `elif`, `else` is optional | Nested `if` statement is also possible. `&&` and `||` are used for combining conditions and represent `AND` and `OR` operation.

```bash
# If Statement
if [ 5 -gt 3 ]; then
    echo "5 is greater than 3"
fi

if [ 5 -gt 3 ]; then
    echo "5 is greater than 3"
elif [ 5 -eq 3 ]; then
    echo "5 is equal to 3"
else
    echo "5 is not greater than 3"
fi

# Nasted If Statements
car="Toyota"
car_type="sedan"
if [ $car_type = "shorts" ]; then
    if [ $car = "Lamborghini" ]; then
        echo "You are the most lucky person"
    else
        echo "You are the more lucky person"
    fi
elif [ $car_type = "sedan" ]; then
    if [ $car = "Toyota" ]; then
        echo "You are the lucky person"
    else
        echo "At least you have a car"
    fi
else
    echo "You are me"
fi

# Combining Conditions, And and Or
age=25
if [ $age -gt 18 ] && [ $age -lt 30 ]; then
    echo "You are a young adult"
fi

if [ $age -lt 18 ] || [ $age -gt 30 ]; then
    echo "You are not a young adult"
fi
```

### Case Statement

Syntax - `case "$<variable_name>" in <blobing_pattern_1>) <command_lines|caluse><another_caluse>;; <blobing_pattern_2> <clause>;; ... *) <default_command>;; esac` | Logical check only on a single variable | `$` and `""` is important and remember to use it always | Will take the first match | If we have same output for different cases we can follow the `A|B command;;` pattern.

```bash
# Case Statement
day="Monday"
case "$day" in
    "Monday")
        echo "Start of the week"
        echo "Time to work"
        ;;
    "Friday")
        echo "End of the week"
        ;;
    *)
        echo "Midweek"
        ;;
esac
```

## Processing Options and Reading Files

### While Loop

Syntax - `while <test_command>; do <consiquent_commands> done` | after `while` keyword we can use any command 

```bash
read -p "Enter a number: " num
while [ $num -gt 10 ]; do
    echo "The number is now: $num"
    num=$((num - 1))
done
```

!!! info "Remember"
    `getopts` | Get the options provided to the script |  Syntax - `getopts "<option>:<option>:...:" variable_name` | `:` here says the `option` will receive some arguments for them | `getopts` do not get all the options at once, each time it runs - it takes the next option | Most of the time it runs under a while loop | Arguments provided will be stored under `$OPTARG` variable | Sequence of options doesn't matter
    ```bash
    # getopts
    total_seconds=0
    while getopts "m:s:" opt; do
        case $opt in
            m) echo "Minutes: $OPTARG"; total_seconds=$((total_seconds+(OPTARG * 60))) ;;
            s) echo "Seconds: $OPTARG"; total_seconds=$((total_seconds+OPTARG)) ;;
            *) echo "Invalid option: -$OPTARG" >&2 ;;
        esac
    done
    echo "Total seconds: $total_seconds"
    while [ $total_seconds -gt 0 ]; do
        echo "Time remaining: $total_seconds seconds"
        sleep 1s
        total_seconds=$((total_seconds - 1))
    done
    echo "Time's up!"
    ```

> `read while` loop is a type of while loop that is used mostly for reading file line by line.It use `read` command for the test statement.

```bash
# read while
while read  line; do
    echo "Read line: $line"
done < "$1"
```

## Array and For Loop

Index start from `0`, Syntax - `var=(item1 item2 ...)`. If you do a parameter expansion on an array, you get get the first element only. `@` gives all the values at once. To add a number you use `var+=(value)`, it will be added to the last. To remove an ent fro the array we nee us the `unset`. But the index also gets deleted. You can check out the indexes by `!number[@]`. Replace a value with `var[Index]=value`

```bash
numbers=(1 2 3 4 5)
echo $numbers
echo "Third value:" ${numbers[2]}
echo "All values:" ${numbers[@]}
echo "Length of array:" ${#numbers[@]}
echo "Last equal slice:" ${numbers[@]:2:3}

numbers+=(100)
unset numbers[1]
echo "The Indexes of the array:" ${!numbers[@]}
numbers[0]=10
echo "Updated array:" ${numbers[@]}
```
Output
```bash
1
Third value: 3
All values: 1 2 3 4 5
Length of array: 5
Last equal slice: 3 4 5
The Indexes of the array: 0 2 3 4 5
Updated array: 10 3 4 5 100
```

Readarray is used to make array by reading content from source | Syntax - `readarray array_name < source` | You may have the `\n` after each item. For that you will need `-t` option | One item will he be created per line, even if the line have spaces in them.

```bash
# Readarray
readarray -t lines < "$1"
echo "Items in the array:" ${lines[@]}
```
You. can iterate over the `array` with `for` loop | Syntax - `for item_var in source; do <commands> done` 

```bash
readarray -t days < "$1"
for day in "${days[@]}"; do
    echo "Got the day: $day"
done
```

## Debugging

`shellcheck` is used to check errors in the bash script | It also makes recommendations | Here is the [Link](https://www.shellcheck.net/) | We can also call it from command line, but you need to install it to your system | For mac `brew install shellcheck` | Use it with `shellcheck <bash_fine_name>`

Error Message Structure - `program_name: Narrow down the problem: Reason of the error` | `ls: cannot access: No file or directory`
Common Errors

- Syntax Error
- No such file or directory
- File exists
- Permission denied | You donn't have the access
- Operation not permitted | You don't have permission for operation
- Command not found

Internal command are build in bash, external command are external | `type` is useful | `type -a cd` gives you the command type.

`help` - If you are working with internal command | `help command` | `help command -d` gives short description | `-s` gives the usage information.
`man` - If you are working with external command | short for manual | `man command` opens the manual page | exit qith `q` | `-k` can be used for search in all manual description | `-K` search in thee the manual pages
`info` - If you are working with external command | `info command` open the info page | q

## Scheduling and Automation

`at` Command | Used for scheduling | Need to install it | enable it with this command in mac machine `sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.atrun.plist` | It's a demon service | Syntax-`at time` will open the prompt, go ahead and add command, finish it with `control` + `d` | `at -l` lists all the scheduled jobs | `at -r job_id` will remove the job | If you have a bash file you can add it with `at -f file_name time` syntax | Time must come before the Date | `9am 12/23/2026` | `9am tomorrow` | `9am nextweek` | `now + 2 days` | There is no way to run recurring job.

```bash
at 3:05am
echo "Hello Word"
at -l
job 1 at Sat May  2 03:05:00 2026
at -f schedule_n_automation.sh 3:15am
```

`cron`Command | `crontab` stores the information | `crontab -e` | It's just a text file and can be edited with nano or vim | You can change the editor with `EDITOR=nano crontab -e` command
Every row is a seperate scheduled Job | Each row have 6 columns | 5 are scheduling information | 1 is the `command` we want to run.

- m | minute | `*` means every
- h | hour 
- dom | Day of the month
- mon | Month
- dow | Day of the week
```bash
* 13 * * * MON-SAT ~/bashScripts/cronScripts.sh # Every minute between 1pm-2pm Every single day of the month, Every month, Monday to Saturday
```

A useful website to play with: [CrontabGuru](https://crontab.guru/)

Cron Directories | A folder on system, where we place the Scripts and run | In linux it's soted on `/ect`directory | We can create own crontab folder and directories

Let's say we have a directory called `~/Users/uner_name/cron.daily.8am` | Open regular user crontab for editing with `crontab -e` | `run-parts`takes a directory as an arguments and run all the scripts in that directory | `--report` will log each of the report it ran.

```bash
# m h dom mon dow    Command
00 08 * * * run-parts <path/to/scripts> --report
```

### Anacron

> Detects the scheduled task missed because the machine was power off, and then re-run

## Working with Remote

SSH - `Secure Shell`

Command to comnnect: `ssh <user>@<ip_address>` | Disconnect with `exit`command

Send file to remote - `scp <source> <user>@<ip_address>:<target>`
Receive file from remote - `scp <user>@<ip_address>:<source> <target>`

## Cheat Sheet

1. Check current shell: `echo $SHELL`
2. Change to a new shell: `chsh -s /path/to/shell`
3. `file <file_name>` gives the type of the file.
4. `chmod +x <file_name>` to give execution permission. `777` All permission to all. `700` all for owner. `744`is the recommended.
5. `./<file_name>` Runs a script with `file_name`
6. `ls -l` give file list with permission metrix.
7. `echo "$PATH"` - gives you the list of paths.
8. `echo $OLDPWD` - gives the previous directory. Shortcut `~-`
9. `echo $?` gives you the exit status
10. Process substitution: Make the output of a process file like behavior. `<(command)`
11. `cut` split string with a delimeter with `-d` | `$(string | cut -d "." -f 2)` | `-f` tells which part you want after cut.
12. `curl` and `--head` can be used to hit a url
13. `find` command is very useful for finding files, filtering and perform other operations.

Repo Link [Here](https://github.com/hafiz-bs23/bash_bro)