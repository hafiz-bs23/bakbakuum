---
title: Power Tool - Shell Scripting 
date:
    created: 2026-04-29
    updated: 2026-05-04
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

![Shell scripting — terminal and automation](../post_assets/shell_scripting_cover.png){ width="100%" loading=lazy }

Shell Scripting Skill is a nice addition to your power tool 💪. It's power that most of the Dev don't have and must have if you like automation ⚡🤖 — glue for CI, servers, and daily chores.
<!-- more -->
## 🐚 Introduction

!!! note "🖥️ What is shell?"
    A program that interprets the commands you type in your terminal and passes them to the operating system — e.g. **bash** (“Bourne Again Shell”): feature-rich, fast, very common.

!!! note "📄 What is a script?"
    A file containing commands for the shell — allows automation.

### 📜 Structure of a Bash script

Every script tells a small story: **shebang** → **commands** → **exit status** (conventionally `0` = success; any value `0`–`255` is allowed).

---

!!! tip "Skeleton checklist"
    - 💬 **`#`** — starts a line **comment** (documentation for humans).
    - 📋 **Five header fields** many teams expect in production scripts:
        - `Author`
        - `Date creation`
        - `Last modified`
        - `Description`
        - `Usage`
    - 🔐 **Permissions** — *who* can do *what* (`chmod` / `umask`).

---

#### 🔐 Permissions in one breath

| Audience | Meaning |
| :-- | :-- |
| **Owner** 👤 | User who owns the file |
| **Group** 👥 | Users in the file’s group |
| **Others** 🌍 | Everyone else on the system |

Letters **`r`** (read), **`w`** (write), **`x`** (execute), **`-`** (that bit **not** granted). Example string **`rwxrw-r--`**: owner *rwx*, group *rw-*, others *r--*. The leading **`d`** means **directory**; **`-`** means regular file. Change mode with **`chmod`**.

#### 🧭 Run from anywhere

Add the folder that holds your script to **`PATH`** (directories the OS searches for executables) if you want to call it without `./`.

```bash title="script101.sh" linenums="1" hl_lines="1 18"
#!/bin/bash # (1)!

# Author: Hafizur Rahman
# Date Created: 2024-06-01
# Last Modified: 2024-06-01

# Description
# This script demonstrates the use of comments in a bash script.

# Usage
# To run this script, use the following command:
# bash script101.sh

# This is a single line comment
echo "The script is a go."
exit 0 # (2)!
```

1.  :material-shield-star: **Shebang** — tells the kernel which interpreter runs the file (`#!/bin/bash`).
2.  :material-check-decagram-outline: **`exit 0`** — ends the script with status **0** (success); other codes signal failure to callers / CI.

## 🧱 Bash Syntax

**Parameter** — any entity that stores values. Three kinds of parameters in bash:

- 📦 **Variables** — values you can change manually
- 🔢 **Positional parameters** — `$1`, `$2`, …
- ⭐ **Special parameters** — `$#`, `$?`, `$@`, …

### 📦 Variables

!!! note "Variables"
    Store reusable data under convenient names ✨

- `name="value"` — no spaces before or after `=`. This is a **user-defined** variable and is usually lowercase.
- **Shell variables**
  - Bourne shell variables (~10): `PATH`, `HOME` (current user’s home), `USER` (username), `HOSTNAME`, `HOSTTYPE` (machine architecture), `PS1` (prompt) — typically **uppercase** names.
  - Bash-specific variables — 95+ more.

```bash title="variables_demo.sh" linenums="1" hl_lines="3 7"
student_name="Hafizur Rahman"
echo "$student_name"
echo "Hello ${student_name}, welcome to the bash scripting course." # (1)!
echo "You all Upper case name is: ${student_name^^} and only first letter lower case is: ${student_name,}" # (2)!
echo "The length of the student name is: ${#student_name}"
echo "First three characters of the student name is: ${student_name:0:3}"

# Some Bourne shell variables
echo "The current user is: $USER"
echo "The current working directory is: $PWD"
echo "The home directory is: $HOME"
echo "The hostname is: $HOSTNAME"
echo "The computer architecture is: $HOSTTYPE"
```

1.  :material-variable: **Double-quoted expansion** — `"$student_name"` and `"${student_name}"` preserve spaces and allow parameter expansion inside the string.
2.  :material-format-letter-case-upper: **Case modifiers** — `${var^^}` uppercases all letters; `${var,}` lowercases only the first character (bash 4+).

#### Sample output

```text title="Sample output — variables"
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

### 🌀 Shell expansions

!!! note "Expansions"
    Retrieve data, process command output, and perform calculations 🔧

### 📎 Parameter expansion

Access with `${var_name}` — this is **parameter expansion** (the workhorse of bash).

#### ✨ Some tricks

- Case: `${var,}` first lowercase | `${var,,}` all lower | `${var^}` capitalize first | `${var^^}` all upper
- Length: `${#var}` — number of characters
- Slicing: `${var:offset:length}` — a substring. A negative offset needs a **space** before it, e.g. `${var: -3:2}`

```bash title="parameter_expansion_playground.sh"
# Add examples for ${var}, ${#var}, and slicing here (see “Some tricks” above).
```

#### Sample output

```text title="Sample output — parameter expansion"

```

### 🔄 Command substitution

Similar to expansion, but you run a **command** and substitute its output.
Syntax: `$(command)` (or legacy `` `command` `` — prefer `$()` for nesting 📌)

```bash title="command_substitution_demo.sh" linenums="1" hl_lines="2"
# Command substitution
time_now=$(date +"%Y-%m-%d %H:%M:%S") # (1)!
echo "The current date and time is: $time_now"
```

1.  :material-swap-horizontal: **`$(...)`** runs the inner command and replaces this whole token with its stdout (trimmed trailing newlines).

#### Sample output

```text title="Sample output — command substitution"
The current date and time is: 2026-04-30 00:12:03
```

### 🔢 Arithmetic expansion

Syntax: `$((expression))` — operators `+`, `-`, `*`, `/`, `%`.
Limited to integers in `$((...))`. For decimals, use **`bc`** and set **`scale`**. **bc** is a basic calculator — a small language for arithmetic.
Typical pattern: pipe an expression into `bc`, e.g. `echo "scale=10; 5/2" | bc`.

```bash title="arithmetic_demo.sh" linenums="1" hl_lines="4 15"
# Arithmetic expansion — whole numbers
num1=10
num2=20
echo "Sum $((num1 + num2)), Difference $((num1 - num2)), Product $((num1 * num2)), Quotient $((num2 / num1)), Remainder $((num2 % num1))" # (1)!

# Arithmetic with floating point via bc
num3=10.5
num4=20.5
echo "Sum $(echo "$num3 + $num4" | bc), Difference $(echo "$num3 - $num4" | bc), Product $(echo "$num3 * $num4" | bc), Division $(echo "scale=2; $num4 / $num3" | bc), Quotient $(echo "$num4 / $num3" | bc)" # (2)!
```

1.  :material-calculator: **Integer arithmetic** — `$((...))` is fast and needs no subprocess; division truncates toward zero.
2.  :material-decimal: **`bc`** does fractional math; **`scale=`** sets decimal places for division.

#### Sample output

```text title="Sample output — arithmetic"
Sum 30, Difference -10, Product 200, Quotient 2, Remainder 0
Sum 31.0, Difference -10.0, Product 215.2, Division 1.95, Quotient 1
```

### 🏠 Tilde expansion

`~` — your home directory 🗝️  
`~username` — that user’s home directory

```bash title="tilde_expansion_demo.sh" linenums="1" hl_lines="2"
echo "The home directory is: ~ or $HOME"
echo "The current directory is $PWD or ~+" # (1)!
echo "The previous directory is $OLDPWD or ~-"
```

1.  :material-map-marker: **`~+`** expands to **`$PWD`** (current dir); **`~-`** is previous (`$OLDPWD`).

#### Sample output

```text title="Sample output — tilde"
The home directory is: ~ or <home_directory>
The current directory is <current_directory> or ~+
The previous directory is <previous_directory> or ~-
```

### 🎲 Brace expansion

**String list** — syntax `{a,b,c}`  
**Range list** — syntax `<prefix>{start..end..step}`

```bash title="brace_expansion_demo.sh" linenums="1" hl_lines="9"
# Brace expansion
echo {a,19,z,barry,42}
echo {jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec}
echo {0..9}
echo {a..z}
echo {100..1..5}
echo roll{01..10}
echo month{01..5}/day{01..3}.txt # (1)!
```

1.  :material-file-tree: **Nested brace pairs** generate a **Cartesian product** of path components — great for dummy file names in tests.

#### Sample output

```text title="Sample output — brace expansion"
a 19 z barry 42
jan feb mar apr may jun jul aug sep oct nov dec
0 1 2 3 4 5 6 7 8 9
a b c d e f g h i j k l m n o p q r s t u v w x y z
100 95 90 85 80 75 70 65 60 55 50 45 40 35 30 25 20 15 10 5
roll01 roll02 roll03 roll04 roll05 roll06 roll07 roll08 roll09 roll10
month01/day01.txt month01/day02.txt month01/day03.txt month02/day01.txt month02/day02.txt month02/day03.txt month03/day01.txt month03/day02.txt month03/day03.txt month04/day01.txt month04/day02.txt month04/day03.txt month05/day01.txt month05/day02.txt month05/day03.txt
```

## ⚙️ How Bash processes command lines

Takes the script → read line by line → five-step pipeline → execution. 🎢

1️⃣ **Tokenization:** a **token** is a chunk the shell treats as one unit.
**Metacharacters** (`| & ; () <> space tab newline`).  
**Word** — token with no unquoted metacharacter.  
**Operator** — token with an unquoted metacharacter.

- Control operators (`newline || & && ; ;; ;& ;;& |& ( )`)
- Redirection operators (`< > << >> <& >| <<- <> >&`)

Operators matter only when they are *unquoted*.

2️⃣ **Command identification:**  
**Simple command** — words until a control operator: `<command_name> <arguments>` (e.g. `echo 12345`).  
**Compound command** — `if`, loops, etc.; starts with a **reserved word**.

3️⃣ **Expansions:**

- Stage 1 — brace expansion 🎲
- Stage 2 — parameter expansion, arithmetic expansion, command substitution, **tilde** expansion 🪄
- Stage 3 — **word splitting** — splits results of **unquoted** expansions into words using **`IFS`** (*internal field separator*: space, tab, newline by default). Example: `numbers="1 2 3"; touch $numbers` creates three files `1`, `2`, `3`. With `numbers="1,2,3"; touch $numbers` you still get one argument unless you set `IFS=","` ✂️
- Stage 4 — **globbing** — only on words; patterns use `*`, `?`, `[]` unquoted (e.g. `file*.txt`, `file??.txt`, `file[abc][1-3].txt`). Matches live in the current directory unless the path says otherwise. 🎯

!!! info "💬 Quote expansions"
    If you want the result of parameter expansion, arithmetic expansion, or command substitution to stay **one word**, wrap it in **double quotes**.

!!! info "⏱️ Expansion order"
    Stages run in order; within the same stage, expansions share priority and run **left to right**.

4️⃣ **Quote removal:** strip unquoted backslashes and quote characters that did **not** come from an expansion.

5️⃣ **Redirection:** **0** stdin 📥, **1** stdout 📤, **2** stderr. `<` input, `>` stdout, `2>` stderr, `&>` both streams, `>>` append.

### 🙊 How quoting works

Quoting is about **removing special meaning** from characters 🧷

- `\` — cancels special meaning for the **next** character
- `'...'` — everything inside is literal
- `"..."` — `$`, backticks, `\`, and `!` (history) can still act special

```bash title="quoting_demo.sh" linenums="1" hl_lines="2 6"
# Quoting
echo jon & snow # (1)!
echo jon\& snow
echo path C:\User\user_name\images
echo path 'C:\User\user_name\images'
echo path 'C:\User\$USER\images' # (2)!
echo path "C:\User\\$USER\images"
```

1.  :material-flash-alert: **`&` runs the next command in the background** — unquoted `echo jon & snow` backgrounds `echo jon` and tries to run `snow`.
2.  :material-code-tags: **Single quotes are literal** — `\` and `$` are **not** special inside `'...'`, so `$USER` stays text.

#### Sample output

```text title="Sample output — quoting"
jon
./commands_anatomy: line 4: snow: command not found
jon& snow
path C:Useruser_nameimages
path C:\User\user_name\images
path C:\User\$USER\images
path C:\User\<user_name>\images
```

## ⌨️ Requesting user input

### 🔢 Positional parameters

The shell assigns **positional parameters** `$1`, `$2`, …  
`<script_name> arg1 arg2 ...`

```bash title="taking_user_input.sh" linenums="1" hl_lines="6"
echo "You are: $1"
echo "Your home directory is: $2"
echo "Your fav color is: $3"
# Mini calculator: operator in $1, operands in $2 and $3
echo $(( ${2:-0} $1 ${3:-0} )) # (1)! ${parameter:-word} — default if unset/null
```

1.  :material-source-branch: **`${name:-default}`** supplies **default** when `name` is unset or empty — handy for optional math operands.

Executing: `./taking_user_input Hafiz $HOME Yello`

#### Sample output

```text title="Sample output — positional parameters"
You are: Hafiz
Your home directory is: <home_directory>
Your fav color is: Yello
```

### ⭐ Special parameters

> Bash gives **special parameters** fixed meanings; their values depend on how the shell or script was invoked.

`$#` — number of positional parameters.  
`$0` — name (path) of the shell or script.  
`$*` — same as `$@` when unquoted; when quoted, still one word per original argument but joined using the **first character of `IFS`**.  
`$@` — all positional parameters; `"$@"` is `"$1" "$2" …` preserving separate arguments.

!!! note "Prefer \"$@\" for passing arguments ➡️"
    `"$@"` expands to separate quoted arguments — use it when you forward args to another command.

```bash title="special_parameters_demo.sh" linenums="1" hl_lines="5 7"
# Special parameters
echo "You have provided $# arguments"
echo "We are currently running the script: $0"
IFS="," # (1)!
echo "All the arguments you have provided are: $@"
echo "We can also access the arguments: $*" # (2)!
```

1.  :material-format-list-bulleted: **`IFS`** changes how **`$*`** (and `"$*"`) **join** fields when you glue arguments into one string.
2.  :material-information-outline: **`echo "$*"`** with `IFS=,` shows commas between args; **`"$@"`** would still quote each arg separately (`"a" "b"`).

Executing: `./taking_user_input Hafiz $HOME Blue`

#### Sample output

```text title="Sample output — special parameters"
You have provided 3 arguments
We are currently running the script: ./taking_user_input
All the arguments you have provided are: Hafiz <home_directory> Blue
We can also access the arguments: Hafiz,<home_directory>,Blue
```

### 📥 Read command

`read` **waits** for input and can store fields in variables ⌛. Common flags: **`-p`** prompt, **`-t`** timeout, **`-s`** silent (passwords) 🔒, **`-n`** read N characters.

```bash title="read_demo.sh" linenums="1" hl_lines="16"
# User input with read
echo "Enter your name, surname and age: "
read user_name user_age
echo "Your name is: $user_name"
echo "Your age is: $user_age"

# Prompt
read -p "Enter your village: " village
echo "You are from: $village"
read -t 5 -p "Memory teaser: What is the capital of France? " capital
if [ -z "$capital" ]; then
    echo "Time's up! You didn't answer the question."
else
    echo "Your answer is: $capital"
fi
read -s -p "Tell me a secret: " secret # (1)!
echo -e "\nYour secret is: $secret"
read -n 5 -p "Enter a 5-character code: " code
echo -e "\nYour code is: $code"
```

1.  :material-eye-off-outline: **`-s`** (silent) — hides what you type (password prompts); pair with `echo` for a newline after input.

### 📋 Select command

> **`select`** prints a menu. Pattern: set **`PS3`**, then `select var in words; do ...; done`. Without a variable name, the choice goes to **`REPLY`**. Break or **Ctrl+C** to exit. **`PS3`** is the menu prompt.

```bash title="select_demo.sh" linenums="1" hl_lines="6"
# Select command
PS3="Please select a day of the week: "
select today in "Monday" "Tuesday" "Wednesday" "Thursday" "Friday"; do
    echo "You have selected: $today"
    break # (1)!
done
```

1.  :material-stop-circle-outline: **`break`** exits the **`select`** loop (otherwise it repeats the menu forever).

## 🔗 Logic

### 🔗 Chaining commands

- **`&`** — run the left command in the **background** ⏩, continue with the right: `cmd1 & cmd2`
- **`;`** — run in sequence: `cmd1 ; cmd2`
- **`&&`** — run the right command only if the left **succeeded** (exit 0) ✅
- **`||`** — run the right command only if the left **failed** ❌

```bash title="chaining_demo.sh" linenums="1" hl_lines="5"
# Chaining commands
echo 123 & echo 546
echo "before" ; echo "after"
ls unknown_directory ; echo "This will run"
ls unknown_another_directory && echo "This will not run" # (1)!
ls unknown_yet_another_directory || echo "This will run because the previous command failed"
echo "This is successful" || ls unknown_directory
```

1.  :material-transit-connection-variant: **`&&`** short-circuits — the right side runs **only** if the left command returns **0**.

#### Sample output

```text title="Sample output — chaining"
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

### 🧪 Test command

> Compare values or file metadata. **`[` ... `]`** returns **0** (true) or **1** (false). **Spaces** inside `[` `]` are required. Example: `[ 2 -eq 3 ]; echo $?`

- Numeric tests: `-eq`, `-ne`, `-gt`, `-lt`, **`-ge`**, **`-le`**
- String tests: `=`, `!=`, `-z` (empty), `-n` (non-empty)
- File tests: `-e` exists, `-f` regular file, `-d` directory, `-x` executable, `-r`, `-w`

```bash title="test_demo.sh" linenums="1" hl_lines="7 12"
# Test command — numeric
echo "Testing numeric conditions"
[ 5 -eq 5 ]; echo $?
[ 5 -ne 5 ]; echo $?
[ 5 -gt 3 ]; echo $?
[ 5 -lt 3 ]; echo $?
[ 5 -ge 5 ]; echo $? # (1)!
[ 5 -le 3 ]; echo $?

# String
echo "Testing string conditions"
[ "hello" = "hello" ]; echo $? # (2)!
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

1.  :material-numeric: **`-ge` / `-le`** — “greater-or-equal” / “less-or-equal” for integer comparisons in `[ ]`.
2.  :material-format-quote-close: **String tests** — `=` / `!=` compare lexicographically; **quote** variables (`"$v"`) so empty values don’t break `[ ]` syntax.

#### Sample output

```text title="Sample output — test"
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

### 🔀 If statement

Syntax: `if test; then ... elif test; then ... else ... fi`. Exit status **0** runs the `then` branch. Indent the bodies. **`&&` / `||`** combine tests (AND / OR).

```bash title="if_demo.sh" linenums="1" hl_lines="8"
# If statement
if [ 5 -gt 3 ]; then
    echo "5 is greater than 3"
fi

if [ 5 -gt 3 ]; then
    echo "5 is greater than 3"
elif [ 5 -eq 3 ]; then # (1)!
    echo "5 is equal to 3"
else
    echo "5 is not greater than 3"
fi

# Nested if statements
car="Toyota"
car_type="sedan"
if [ "$car_type" = "shorts" ]; then
    if [ "$car" = "Lamborghini" ]; then
        echo "You are the most lucky person"
    else
        echo "You are the more lucky person"
    fi
elif [ "$car_type" = "sedan" ]; then
    if [ "$car" = "Toyota" ]; then
        echo "You are the lucky person"
    else
        echo "At least you have a car"
    fi
else
    echo "You are me"
fi

# Combining conditions — AND / OR
age=25
if [ $age -gt 18 ] && [ $age -lt 30 ]; then
    echo "You are a young adult"
fi

if [ $age -lt 18 ] || [ $age -gt 30 ]; then
    echo "You are not a young adult"
fi
```

1.  :material-source-branch: **`elif`** chains extra tests without nesting another full `if` — first matching branch wins.

### 🎛️ Case statement

Syntax: `case "$var" in pattern) commands;; *) default;; esac` — matches **one** variable against **glob** patterns; first match wins. Use `|` for multiple patterns: `a|b) ...;;`.

```bash title="case_demo.sh" linenums="1" hl_lines="13"
# Case statement
day="Monday"
case "$day" in
    "Monday")
        echo "Start of the week"
        echo "Time to work"
        ;;
    "Friday")
        echo "End of the week"
        ;;
    *) # (1)!
        echo "Midweek"
        ;;
esac
```

1.  :material-asterisk: **`* )`** is the **default** branch — runs when nothing else matched (like `default` in other languages).

## 📂 Processing options and reading files

### 🔁 While loop

Syntax: `while test; do commands; done` — any command can be the test ⏳.

```bash title="while_countdown.sh" linenums="1"
read -p "Enter a number: " num
while [ "$num" -gt 10 ]; do
    echo "The number is now: $num"
    num=$((num - 1))
done
```

!!! info "⚙️ getopts"
    Parse **options** like `-m 5`. Syntax: `getopts "ab:c:" opt` — a colon means the option takes an argument (**`$OPTARG`**). Call `getopts` repeatedly (often inside `while`) until it returns non-zero.

    ```bash title="getopts_timer.sh" linenums="1" hl_lines="5 7"
    # getopts
    total_seconds=0
    while getopts "m:s:" opt; do
        case $opt in
            m) echo "Minutes: $OPTARG"; total_seconds=$((total_seconds + $OPTARG * 60)) ;; # (1)!
            s) echo "Seconds: $OPTARG"; total_seconds=$((total_seconds + $OPTARG)) ;;
            *) echo "Invalid option: -$OPTARG" >&2 ;; # (2)!
        esac
    done
    echo "Total seconds: $total_seconds"
    while [ "$total_seconds" -gt 0 ]; do
        echo "Time remaining: $total_seconds seconds"
        sleep 1
        total_seconds=$((total_seconds - 1))
    done
    echo "Time's up!"
    ```

    1.  :material-counter: **`$OPTARG`** holds the value after **`-m`** or **`-s`**; multiply minutes by **60** in `$((...))`.
    2.  :material-alert-octagon-outline: **`* )`** catches **invalid flags**; redirect to **stderr** (`>&2`) so messages don’t pollute stdout pipes.

> **Read-while** — loop over lines: `while read -r line; do ...; done < file` (or from `"$1"`).

```bash title="read_while_file.sh" linenums="1" hl_lines="5"
# read while
while read -r line; do
    echo "Read line: $line"
done < "$1" # (1)!
```

1.  :material-file-document-outline: **`< "$1"`** redirects **stdin** from the file path in the first argument — classic line-by-line ingest.

## 🔁 Arrays and for loops

Indices start at **`0`**. Syntax: `arr=(e1 e2 ...)`. A bare `$arr` expands to the **first** element; use **`"${arr[@]}"`** for all elements. Append: **`arr+=(value)`**. Remove: **`unset 'arr[i]'`**. List indices: **`"${!arr[@]}"`**. Assign: **`arr[i]=value`**.

```bash title="array_demo.sh" linenums="1" hl_lines="11"
numbers=(1 2 3 4 5)
echo "$numbers"
echo "Third value:" "${numbers[2]}"
echo "All values:" "${numbers[@]}"
echo "Length of array:" "${#numbers[@]}"
echo "Last equal slice:" "${numbers[@]:2:3}"

numbers+=(100)
unset 'numbers[1]' # (1)!
echo "The Indexes of the array:" "${!numbers[@]}"
numbers[0]=10
echo "Updated array:" "${numbers[@]}"
```

1.  :material-table-row-remove: **`unset 'arr[i]'`** removes one slot and leaves a **sparse** array — indices don’t auto-shift like some languages.

#### Sample output

```text title="Sample output — arrays"
1
Third value: 3
All values: 1 2 3 4 5
Length of array: 5
Last equal slice: 3 4 5
The Indexes of the array: 0 2 3 4 5
Updated array: 10 3 4 5 100
```

**readarray** (or **`mapfile`**) loads lines into an array: `readarray -t lines < source`. Use **`-t`** to strip trailing newline. One element per line (spaces on the line stay inside the element).

```bash title="readarray_demo.sh"
# Readarray
readarray -t lines < "$1"
echo "Items in the array:" "${lines[@]}"
```

You can iterate with **`for`**: `for item in list; do ...; done`.

```bash title="for_days_from_file.sh"
readarray -t days < "$1"
for day in "${days[@]}"; do
    echo "Got the day: $day"
done
```

## 🐞 Debugging

**shellcheck** — static analysis for shell scripts. [shellcheck.net](https://www.shellcheck.net/) — install e.g. `brew install shellcheck`, then **`shellcheck script.sh`**.

Error messages often look like: **`program: context: reason`** (e.g. `ls: cannot access: No such file or directory`).

Common errors:

- Syntax error
- No such file or directory
- File exists
- Permission denied
- Operation not permitted
- Command not found

**Builtin** vs **external** commands — **`type -a cmd`** shows what runs.

- **`help`** — builtins: `help read`, `help -d read` (summary), `help -s read` (syntax)
- **`man`** — external tools; **`q`** quits. **`-k keyword`** searches summaries; **`-K`** searches full pages
- **`info`** — GNU docs for some programs

## ⏰ Scheduling and automation

**`at`** — run once at a given time (install/enable on macOS if needed: `sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.atrun.plist`). **Daemon** service. Run **`at 3:05am`**, type commands, finish with **Ctrl+D**. **`at -l`** lists jobs; **`at -r id`** removes one; **`at -f script.sh time`** runs a file. Examples: `9am 12/23/2026`, `9am tomorrow`, `now + 2 days`. Not for **recurring** tasks.

```bash title="at_session_example.sh"
at 3:05am
echo "Hello World"
at -l
# job 1 at Sat May  2 03:05:00 2026
at -f schedule_n_automation.sh 3:15am
```

**`cron`** — **`crontab -e`** edits the table; set **`EDITOR=nano crontab -e`** if you like. Each non-comment line is one job: five time fields plus the command.

- **m** — minute (`*` = every)
- **h** — hour
- **dom** — day of month
- **mon** — month
- **dow** — day of week

```bash title="crontab_line_example.sh" linenums="1" hl_lines="1"
* 13 * * * MON-SAT ~/bashScripts/cronScripts.sh # (1)! Every minute 1pm–2pm, every dom/mon, Mon–Sat
```

1.  :material-clock-outline: **Five time fields** + command — weekdays here use **`MON-SAT`**; tweak with [crontab.guru](https://crontab.guru/).

Try [crontab.guru](https://crontab.guru/) to validate expressions.

**Cron drop-in directories** — on many Linux systems under **`/etc/cron.*`**. You can use **`run-parts`** to run every script in a directory:

```bash title="run_parts_daily.sh"
# m h dom mon dow    command
00 08 * * * run-parts /path/to/scripts --report
```

### Anacron

> Runs jobs that **missed** their schedule while the machine was off.

## 🌐 Working with remote machines

**SSH** — secure shell.

Connect: **`ssh user@host`** — disconnect with **`exit`**.

- Copy **to** remote: **`scp source user@host:dest`**
- Copy **from** remote: **`scp user@host:source dest`**

## 📋 Cheat sheet

1. 🧭 Current shell: `echo $SHELL`
2. 🔄 Change login shell: `chsh -s /path/to/shell`
3. 📄 File type: `file filename`
4. 🔓 Executable bit: `chmod +x file` — `777` all for all, `700` owner only, `744` is a common “shared read” pattern
5. ▶️ Run a script: `./script.sh`
6. 📑 Long listing: `ls -l` (permission matrix)
7. 🛤️ Path list: `echo "$PATH"`
8. ⏮️ Previous directory: `echo $OLDPWD` or `~-`
9. ✅ Last exit status: `echo $?`
10. 📎 Process substitution: `<(command)` treats command output like a file
11. ✂️ **`cut`** — split on delimiter **`-d`**, field **`-f`**: e.g. `echo "$s" | cut -d "." -f 2`
12. 🌐 **`curl --head`** — quick HTTP check
13. 🔍 **`find`** — locate and filter files
14. `set -e` - Tell the script to ext immediately if any command return non-zero status. Otherwise bash will just continue running the script. `-u` checks for undefined variables. `-o pipefail` sets says make sure all the commands need to successful to consider successful execution, otherwise the script is successful only if the last command is successful.
15. You use `readonly` to make constant variables.
16. `dirname` extracts the directory from a path. `dirname /home/user/script.sh` -> `/home/user`
17. `BASH_SOURCE[0]` refers to the path of the script that currently running.
18. `export` makes variables available to child processes ran from current process.
19. `git show-ref --verify --quiet` verify if a branch is valid, `--quiet` only returns the exit code, no other output.
20. `sed` - Stream Editor, used to edit text in a file. `sed 's/old/new/g' file.txt` replaces all occurrences of `old` with `new` in `file.txt`.

🔗 Repo: [bash_bro on GitHub](https://github.com/hafiz-bs23/bash_bro)
