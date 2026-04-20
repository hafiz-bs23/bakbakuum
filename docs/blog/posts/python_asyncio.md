---
title: Python Asyncio - Mastering Asynchronous Programming
date:
    created: 2025-10-15
categories: [python]
tags:
    - python
    - asyncio
    - concurrency
    - performance
    - asynchronous
authors:
  - hafiz
readtime: 12
slug: python_asyncio
draft: false
---

Master asynchronous programming in Python! Understand cores, threads, concurrency, and how asyncio revolutionizes I/O operations. 🚀⚡

<!-- more -->

## 🧠 Understanding the Fundamentals

Before diving into asyncio, let's understand the core concepts that make it work.

### 🖥️ Processor & Core

A **Processor (CPU)** is the brain of your computer. A **Core** is an independent processing unit within the CPU that can execute instructions.

=== "Concept"
    - **Single-core**: One chef in a kitchen 👨‍🍳
    - **Multi-core**: Multiple chefs working together 👨‍🍳👩‍🍳👨‍🍳

=== "Real Example"
    ```
    Dual-core processor = 2 independent workers
    Quad-core processor = 4 independent workers
    8-core processor = 8 independent workers
    ```

---

### ⚡ What is GigaHz (GHz)?

**GHz** measures how many operations a core can perform per second.

=== "Explanation"
    ```
    1 GHz = 1 billion operations per second
    3.5 GHz = 3.5 billion operations per second
    ```

=== "Real-Life Analogy"
    ```
    Imagine a cashier scanning items:
    
    📦 1 GHz cashier = scans 1 billion items/second
    📦 2.5 GHz cashier = scans 2.5 billion items/second
    
    Higher GHz = Faster processing speed! 🏃‍♂️💨
    ```

---

=== "Components"


### 🔀 Parallelism - True Simultaneous Execution

**Parallelism** means multiple operations executing **at the exact same time** on different cores.

**Formula**: Number of cores = Number of operations executing simultaneously

=== "Concept"
    ```python
    4 cores = 4 tasks running at the SAME TIME
    ```

=== "Real-Life Examples"
    **Example 1: Restaurant Kitchen 🍳**
    ```
    4 chefs (cores) cooking 4 dishes simultaneously:
    - Chef 1: Making pasta 🍝
    - Chef 2: Grilling steak 🥩
    - Chef 3: Preparing salad 🥗
    - Chef 4: Baking cake 🎂
    
    All happening at the SAME TIME = Parallelism
    ```

    **Example 2: Assembly Line 🏭**
    ```
    4 workers (cores) building 4 cars simultaneously:
    - Worker 1: Car A
    - Worker 2: Car B
    - Worker 3: Car C
    - Worker 4: Car D
    
    All cars being built at the SAME TIME = Parallelism
    ```

    **Example 3: Cashiers at Supermarket 🛒**
    ```
    4 cashiers (cores) serving 4 customers simultaneously:
    - Cashier 1: Customer A
    - Cashier 2: Customer B
    - Cashier 3: Customer C
    - Cashier 4: Customer D
    
    All transactions happening at the SAME TIME = Parallelism
    ```

---

### 🧵 Thread - A Set of Operations

A **Thread** is a sequence of operations that needs to be executed. Think of it as a to-do list.

=== "Concept"
    ```python
    Thread = A series of instructions to execute
    
    Example Thread:
    1. Read file
    2. Process data
    3. Save result
    ```

=== "Real-Life Analogy"
    ```
    Thread = Recipe to follow 📝
    
    Recipe 1 (Thread 1): Make Coffee ☕
    - Boil water
    - Add coffee
    - Add sugar
    - Stir
    
    Recipe 2 (Thread 2): Make Toast 🍞
    - Take bread
    - Put in toaster
    - Wait
    - Add butter
    ```

---

### 🔄 Multi-Threading - One Core, Multiple Threads

When you have **one core** but **multiple threads**, the core switches between threads rapidly.

**Process**: Run Thread A → Pause → Run Thread B → Pause → Run Thread A → Pause...

=== "How It Works"
    ```
    One Chef (Core), Two Recipes (Threads):
    
    ⏰ Time 1: Work on pasta (Thread A)
    ⏰ Time 2: Switch to salad (Thread B)
    ⏰ Time 3: Back to pasta (Thread A)
    ⏰ Time 4: Back to salad (Thread B)
    
    The chef is ALWAYS busy, just switching tasks!
    ```

=== "Real-Life Examples"
    **Example 1: Single Parent Multitasking 👨‍👧‍👦**
    ```
    One parent (core), multiple tasks (threads):
    
    🕐 9:00 AM: Help kid 1 with homework
    🕑 9:15 AM: Prepare lunch
    🕒 9:30 AM: Help kid 2 with homework
    🕓 9:45 AM: Continue lunch prep
    
    Rapidly switching = Multi-threading
    ```

    **Example 2: Customer Service Rep 📞**
    ```
    One rep (core), multiple calls (threads):
    
    📞 Call 1: Put on hold
    📞 Call 2: Answer question
    📞 Call 3: Put on hold
    📞 Call 1: Resume helping
    
    Quick context switching = Multi-threading
    ```

    **Example 3: Chef Cooking Multiple Dishes 👨‍🍳**
    ```
    One chef (core), three dishes (threads):
    
    🍳 Stir pasta for 10 seconds
    🥘 Check oven for 5 seconds
    🥗 Chop vegetables for 15 seconds
    🍳 Back to pasta
    
    Constant switching = Multi-threading
    ```

---

### 🔀 Concurrency vs Parallelism

| Feature | Concurrency 🔄 | Parallelism ⚡ |
|---------|---------------|----------------|
| **Cores** | Can work with 1 core | Requires multiple cores |
| **Execution** | Tasks switch rapidly | Tasks run simultaneously |
| **Real analogy** | One chef, multiple dishes | Multiple chefs, multiple dishes |
| **Illusion** | Appears simultaneous | Actually simultaneous |

=== "Concurrency (Switching)"
    ```
    One waiter serving three tables:
    
    Table 1: Take order ✅
    Table 2: Take order ✅
    Table 3: Take order ✅
    Table 1: Serve food ✅
    Table 2: Serve food ✅
    
    One person, but all tables get served!
    ```

=== "Parallelism (Simultaneous)"
    ```
    Three waiters serving three tables:
    
    Waiter 1 → Table 1 (at the same time)
    Waiter 2 → Table 2 (at the same time)
    Waiter 3 → Table 3 (at the same time)
    
    Three people, all working simultaneously!
    ```

---

## 🚀 Enter Python Asyncio

Now that you understand the fundamentals, let's see how **asyncio** solves real problems!

### ❌ Problem 1: Blocking I/O Operations

**Scenario**: You need to download 5 files from the internet.

=== "The Problem"
    ```python
    import time
    import requests

    def download_file(url):
        print(f"⬇️ Downloading {url}...")
        response = requests.get(url)  # BLOCKS here!
        time.sleep(2)  # Simulating download time
        print(f"✅ Downloaded {url}")
        return response

    # Sequential downloads
    urls = ["file1.pdf", "file2.pdf", "file3.pdf"]
    
    start = time.time()
    for url in urls:
        download_file(url)  # Wait for each to finish
    
    print(f"⏱️ Total time: {time.time() - start:.2f}s")
    ```

=== "Output"
    ```bash
    ⬇️ Downloading file1.pdf...
    ✅ Downloaded file1.pdf
    ⬇️ Downloading file2.pdf...
    ✅ Downloaded file2.pdf
    ⬇️ Downloading file3.pdf...
    ✅ Downloaded file3.pdf
    ⏱️ Total time: 6.00s
    
    😢 Problem: 6 seconds wasted waiting!
    ```

=== "Real-Life Analogy"
    ```
    Imagine making coffee ☕:
    
    1. Put kettle on → WAIT 2 minutes 😴
    2. Nothing else happens during waiting!
    3. Kettle boils → Pour water
    4. WAIT for coffee to brew 😴
    
    Your time is wasted just waiting!
    ```

---

### ✅ Solution: Asyncio to the Rescue!

=== "Asyncio Solution"
    ```python
    import asyncio
    import aiohttp
    import time

    async def download_file(session, url):
        print(f"⬇️ Downloading {url}...")
        async with session.get(url) as response:
            await asyncio.sleep(2)  # Simulating download
            print(f"✅ Downloaded {url}")
            return await response.text()

    async def main():
        urls = ["file1.pdf", "file2.pdf", "file3.pdf"]
        
        async with aiohttp.ClientSession() as session:
            # Start all downloads at once!
            tasks = [download_file(session, url) for url in urls]
            await asyncio.gather(*tasks)

    start = time.time()
    asyncio.run(main())
    print(f"⏱️ Total time: {time.time() - start:.2f}s")
    ```

=== "Output"
    ```bash
    ⬇️ Downloading file1.pdf...
    ⬇️ Downloading file2.pdf...
    ⬇️ Downloading file3.pdf...
    ✅ Downloaded file1.pdf
    ✅ Downloaded file2.pdf
    ✅ Downloaded file3.pdf
    ⏱️ Total time: 2.00s
    
    🎉 Result: 3x faster! All downloads started together!
    ```

=== "What Happened?"
    ```
    Smart Coffee Making ☕:
    
    1. Put kettle on → Don't wait! ⚡
    2. While kettle heats, prepare cup ☕
    3. While kettle heats, get coffee beans ☕
    4. While kettle heats, get sugar 🍬
    5. Kettle boils → Pour water
    
    You did multiple tasks while waiting!
    ```

---

### 📚 Core Asyncio Concepts Explained

Understanding these core concepts will make asyncio crystal clear! Let's break them down with simple examples.

---

#### 🔄 Event Loop - The Orchestra Conductor

The **Event Loop** is the heart of asyncio. Think of it as a conductor managing an orchestra.

=== "What is it?"
    ```python
    # The Event Loop is like a manager that:
    # 1. Keeps track of all tasks
    # 2. Decides which task runs next
    # 3. Switches between tasks when they're waiting
    # 4. Makes sure everything runs efficiently
    ```

=== "Real-Life Analogy"
    ```
    Imagine a restaurant manager 👨‍💼:
    
    - Takes orders from customers (receives tasks)
    - Assigns chefs to cook (schedules tasks)
    - Checks on cooking progress (monitors tasks)
    - Serves completed dishes (returns results)
    - Never stops managing until restaurant closes
    
    The manager IS the Event Loop!
    ```

=== "Simple Example"
    ```python
    import asyncio
    
    async def task1():
        print("Task 1: Started 🏁")
        await asyncio.sleep(2)
        print("Task 1: Finished ✅")
    
    async def task2():
        print("Task 2: Started 🏁")
        await asyncio.sleep(1)
        print("Task 2: Finished ✅")
    
    async def main():
        print("Event Loop: Starting! 🎬")
        # Event loop will manage both tasks
        await asyncio.gather(task1(), task2())
        print("Event Loop: All done! 🎉")
    
    # This creates and runs the event loop
    asyncio.run(main())
    ```

=== "Output"
    ```bash
    Event Loop: Starting! 🎬
    Task 1: Started 🏁
    Task 2: Started 🏁
    Task 2: Finished ✅    # Finishes first (1 second)
    Task 1: Finished ✅    # Finishes second (2 seconds)
    Event Loop: All done! 🎉
    
    # Event loop managed both tasks efficiently!
    ```

=== "How It Works"
    ```
    Event Loop Cycle:
    
    ┌─────────────────────────┐
    │  1. Check Task Queue    │
    │     "Any tasks ready?"  │
    └───────────┬─────────────┘
                │
                ▼
    ┌─────────────────────────┐
    │  2. Run Task            │
    │     "Execute code"      │
    └───────────┬─────────────┘
                │
                ▼
    ┌─────────────────────────┐
    │  3. Task says 'await'?  │
    │     "Need to wait?"     │
    └───────────┬─────────────┘
                │
                ▼
    ┌─────────────────────────┐
    │  4. Switch to Next Task │
    │     "Don't waste time!" │
    └───────────┬─────────────┘
                │
                ▼
    ┌─────────────────────────┐
    │  5. Repeat Until Done   │
    └─────────────────────────┘
    ```

=== "Getting Event Loop"
    ```python
    import asyncio
    
    # Method 1: Let asyncio.run() handle it (RECOMMENDED)
    async def main():
        print("Easy way! 😊")
    
    asyncio.run(main())  # Creates and manages loop automatically
    
    # Method 2: Manual control (ADVANCED)
    loop = asyncio.get_event_loop()  # Get the loop
    loop.run_until_complete(main())  # Run tasks
    loop.close()  # Clean up
    ```

---

#### 📋 Task - A Scheduled Async Job

A **Task** is a wrapper around a coroutine that schedules it to run on the event loop.

=== "What is it?"
    ```python
    # Task = Async function scheduled to run
    # - It has a status (pending, running, done)
    # - It can be cancelled
    # - It returns a result when complete
    ```

=== "Real-Life Analogy"
    ```
    Task is like a food order ticket 🎫:
    
    Order Ticket #42:
    - Item: Pizza Margherita 🍕
    - Status: Preparing
    - Chef: Working on it
    - Customer: Waiting
    - Result: Will deliver when done
    
    The ticket IS a Task!
    ```

=== "Creating Tasks"
    ```python
    import asyncio
    
    async def bake_cake():
        print("🎂 Starting to bake cake...")
        await asyncio.sleep(3)
        print("✅ Cake is ready!")
        return "Delicious chocolate cake"
    
    async def main():
        # Method 1: Create task explicitly
        task = asyncio.create_task(bake_cake())
        print(f"Task created: {task}")
        print(f"Task done? {task.done()}")  # False
        
        # Do other things here...
        print("Doing other things while cake bakes... 💼")
        
        # Wait for task to complete
        result = await task
        print(f"Task done? {task.done()}")  # True
        print(f"Result: {result}")
    
    asyncio.run(main())
    ```

=== "Output"
    ```bash
    Task created: <Task pending name='Task-2' coro=<bake_cake()>>
    Task done? False
    🎂 Starting to bake cake...
    Doing other things while cake bakes... 💼
    ✅ Cake is ready!
    Task done? True
    Result: Delicious chocolate cake
    ```

=== "Multiple Tasks"
    ```python
    import asyncio
    
    async def download_file(name, seconds):
        print(f"⬇️ Downloading {name}...")
        await asyncio.sleep(seconds)
        print(f"✅ {name} downloaded!")
        return f"{name}_data"
    
    async def main():
        # Create multiple tasks
        task1 = asyncio.create_task(download_file("File1.pdf", 2))
        task2 = asyncio.create_task(download_file("File2.pdf", 1))
        task3 = asyncio.create_task(download_file("File3.pdf", 3))
        
        # All tasks are now running concurrently!
        print("All downloads started! 🚀")
        
        # Wait for all to complete
        results = await asyncio.gather(task1, task2, task3)
        print(f"Results: {results}")
    
    asyncio.run(main())
    ```

=== "Task Control"
    ```python
    import asyncio
    
    async def long_operation():
        print("Starting long operation... ⏳")
        await asyncio.sleep(10)
        print("Operation complete! ✅")
    
    async def main():
        # Create task
        task = asyncio.create_task(long_operation())
        
        # Wait a bit
        await asyncio.sleep(2)
        
        # Cancel the task
        task.cancel()
        
        try:
            await task
        except asyncio.CancelledError:
            print("Task was cancelled! ❌")
    
    asyncio.run(main())
    ```

---

#### 📚 Call Stack - The Execution History

The **Call Stack** keeps track of which functions are currently executing and in what order.

=== "What is it?"
    ```python
    # Call Stack is like a stack of plates 🍽️:
    # - Last plate added is first plate removed
    # - Shows the chain of function calls
    # - Helps track where you are in code execution
    ```

=== "Real-Life Analogy"
    ```
    Call Stack is like Russian nesting dolls 🪆:
    
    function_a() called:
    ┌─────────────────┐
    │  function_a     │ ← Current function
    └─────────────────┘
    
    function_a() calls function_b():
    ┌─────────────────┐
    │  function_b     │ ← Current function
    ├─────────────────┤
    │  function_a     │ ← Waiting
    └─────────────────┘
    
    function_b() calls function_c():
    ┌─────────────────┐
    │  function_c     │ ← Current function
    ├─────────────────┤
    │  function_b     │ ← Waiting
    ├─────────────────┤
    │  function_a     │ ← Waiting
    └─────────────────┘
    
    function_c() finishes:
    ┌─────────────────┐
    │  function_b     │ ← Resume
    ├─────────────────┤
    │  function_a     │ ← Waiting
    └─────────────────┘
    ```

=== "Simple Example"
    ```python
    def make_sandwich():
        print("🥪 Making sandwich...")
        prepare_bread()  # Adds to call stack
        print("🥪 Sandwich complete!")
    
    def prepare_bread():
        print("  🍞 Getting bread...")
        slice_bread()  # Adds to call stack
        print("  🍞 Bread ready!")
    
    def slice_bread():
        print("    🔪 Slicing bread...")
        # This is the deepest point in call stack
        print("    ✅ Bread sliced!")
    
    make_sandwich()
    ```

=== "Output"
    ```bash
    🥪 Making sandwich...
      🍞 Getting bread...
        🔪 Slicing bread...
        ✅ Bread sliced!
      🍞 Bread ready!
    🥪 Sandwich complete!
    
    # Call Stack:
    # make_sandwich() → prepare_bread() → slice_bread()
    # Then unwinds: slice_bread() → prepare_bread() → make_sandwich()
    ```

=== "Async Call Stack"
    ```python
    import asyncio
    
    async def level_1():
        print("📍 Level 1: Started")
        await level_2()  # Suspend here
        print("📍 Level 1: Resumed")
    
    async def level_2():
        print("  📍 Level 2: Started")
        await level_3()  # Suspend here
        print("  📍 Level 2: Resumed")
    
    async def level_3():
        print("    📍 Level 3: Started")
        await asyncio.sleep(1)  # Suspend here
        print("    📍 Level 3: Resumed")
    
    asyncio.run(level_1())
    ```

=== "Output"
    ```bash
    📍 Level 1: Started
      📍 Level 2: Started
        📍 Level 3: Started
        # [1 second pause - call stack suspended]
        📍 Level 3: Resumed
      📍 Level 2: Resumed
    📍 Level 1: Resumed
    
    # Call stack builds up, then unwinds
    ```

---

#### 📬 Task Queue - The Waiting Line

The **Task Queue** (also called Event Queue) holds tasks that are ready to be executed.

=== "What is it?"
    ```python
    # Task Queue is a line of tasks waiting their turn:
    # - First in, first out (usually)
    # - Event loop picks from this queue
    # - Tasks join the queue when ready to run
    ```

=== "Real-Life Analogy"
    ```
    Task Queue is like a coffee shop line ☕:
    
    ┌──────────────────────────────────┐
    │  Coffee Shop Queue               │
    ├──────────────────────────────────┤
    │  [1] Customer A - Ready          │ ← Served next
    │  [2] Customer B - Ready          │
    │  [3] Customer C - Ready          │
    │  [4] Customer D - Ready          │
    └──────────────────────────────────┘
    
    Barista (Event Loop) serves from the front!
    ```

=== "How Tasks Enter Queue"
    ```python
    import asyncio
    
    async def task_a():
        print("Task A: Running 🏃")
        await asyncio.sleep(1)  # Goes back to queue after waiting
        print("Task A: Done ✅")
    
    async def task_b():
        print("Task B: Running 🏃")
        await asyncio.sleep(1)
        print("Task B: Done ✅")
    
    async def task_c():
        print("Task C: Running 🏃")
        await asyncio.sleep(1)
        print("Task C: Done ✅")
    
    async def main():
        # All tasks added to queue
        await asyncio.gather(task_a(), task_b(), task_c())
    
    asyncio.run(main())
    ```

=== "Output"
    ```bash
    Task A: Running 🏃
    Task B: Running 🏃
    Task C: Running 🏃
    # All start immediately, then all wait
    Task A: Done ✅
    Task B: Done ✅
    Task C: Done ✅
    # All complete after waiting
    
    # Event loop manages the queue efficiently!
    ```

=== "Queue Visualization"
    ```python
    import asyncio
    
    async def process_item(item_num, delay):
        print(f"  ▶️ Processing item {item_num}")
        await asyncio.sleep(delay)
        print(f"  ✅ Item {item_num} done!")
        return f"Result_{item_num}"
    
    async def main():
        print("📋 Adding 5 items to task queue...")
        
        tasks = [
            asyncio.create_task(process_item(1, 2)),
            asyncio.create_task(process_item(2, 1)),
            asyncio.create_task(process_item(3, 3)),
            asyncio.create_task(process_item(4, 1.5)),
            asyncio.create_task(process_item(5, 0.5))
        ]
        
        print("🔄 Event loop processing queue...\n")
        results = await asyncio.gather(*tasks)
        
        print(f"\n📦 All results: {results}")
    
    asyncio.run(main())
    ```

---

#### 🔔 Callback - Do This When Done

A **Callback** is a function that gets called when an async operation completes.

=== "What is it?"
    ```python
    # Callback = "Call me back when you're done"
    # - You give a function to be executed later
    # - Executes when the operation completes
    # - Old way of handling async (before async/await)
    ```

=== "Real-Life Analogy"
    ```
    Callback is like restaurant buzzer 📟:
    
    You: "I'd like a table for 2"
    Host: "It'll be 20 minutes. Here's a buzzer 📟"
    You: *Goes shopping* 🛍️
    Buzzer: *BZZZT* 📟 (This is the CALLBACK!)
    You: *Returns to restaurant*
    Host: "Your table is ready!"
    
    The buzzer calling you back IS a callback!
    ```

=== "Old Style: Callbacks"
    ```python
    import asyncio
    
    def callback_function(task):
        """This gets called when task completes"""
        result = task.result()
        print(f"🔔 Callback fired! Result: {result}")
    
    async def fetch_data():
        print("🌐 Fetching data...")
        await asyncio.sleep(2)
        return "Data from server"
    
    async def main():
        # Create task
        task = asyncio.create_task(fetch_data())
        
        # Add callback (old way)
        task.add_done_callback(callback_function)
        
        print("Task started, callback registered 📋")
        
        # Wait for task
        await task
        print("Task completed ✅")
    
    asyncio.run(main())
    ```

=== "Output"
    ```bash
    Task started, callback registered 📋
    🌐 Fetching data...
    🔔 Callback fired! Result: Data from server
    Task completed ✅
    ```

=== "Modern Style: async/await"
    ```python
    import asyncio
    
    async def fetch_data():
        print("🌐 Fetching data...")
        await asyncio.sleep(2)
        return "Data from server"
    
    async def main():
        # Modern way - much cleaner!
        print("Fetching...")
        result = await fetch_data()
        print(f"✅ Got result: {result}")
        # No callbacks needed!
    
    asyncio.run(main())
    ```

=== "Callback Hell vs Async/Await"
    ```python
    # OLD WAY: Callback Hell 😱
    def old_way():
        fetch_user(user_id, lambda user:
            fetch_posts(user, lambda posts:
                fetch_comments(posts, lambda comments:
                    fetch_likes(comments, lambda likes:
                        print("Finally done!")
                    )
                )
            )
        )
    # Nested callbacks = Hard to read!
    
    # NEW WAY: Clean async/await 😊
    async def new_way():
        user = await fetch_user(user_id)
        posts = await fetch_posts(user)
        comments = await fetch_comments(posts)
        likes = await fetch_likes(comments)
        print("Finally done!")
    # Linear code = Easy to read!
    ```

---

#### 🔀 Subprocess - Running External Programs

A **Subprocess** allows you to run external programs from your Python code asynchronously.

=== "What is it?"
    ```python
    # Subprocess = Running another program
    # - Like running commands in terminal
    # - Can be CPU-intensive tasks
    # - Runs in separate process (not same Python process)
    ```

=== "Real-Life Analogy"
    ```
    Subprocess is like hiring a contractor 👷:
    
    You (Python): "I need this house painted"
    Contractor (Subprocess): "I'll handle it!"
    
    While contractor paints:
    - You can do other things 🛋️
    - Contractor works independently 🎨
    - You check progress occasionally 👀
    - Contractor finishes and reports back ✅
    
    The contractor IS a subprocess!
    ```

=== "Running Shell Commands"
    ```python
    import asyncio
    
    async def run_command(command):
        print(f"🔧 Running: {command}")
        
        # Create subprocess
        process = await asyncio.create_subprocess_shell(
            command,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE
        )
        
        # Wait for completion
        stdout, stderr = await process.communicate()
        
        print(f"✅ Command finished!")
        print(f"Output: {stdout.decode()}")
        return stdout.decode()
    
    async def main():
        # Run shell command asynchronously
        await run_command("echo Hello from subprocess!")
    
    asyncio.run(main())
    ```

=== "Multiple Subprocesses"
    ```python
    import asyncio
    
    async def check_status(service):
        print(f"🔍 Checking {service}...")
        
        process = await asyncio.create_subprocess_shell(
            f"echo Checking {service}...",
            stdout=asyncio.subprocess.PIPE
        )
        
        stdout, _ = await process.communicate()
        print(f"✅ {service}: {stdout.decode().strip()}")
    
    async def main():
        # Check multiple services concurrently
        await asyncio.gather(
            check_status("Database"),
            check_status("API Server"),
            check_status("Cache"),
        )
        print("🎉 All checks complete!")
    
    asyncio.run(main())
    ```

=== "Running Python Scripts"
    ```python
    import asyncio
    
    async def run_python_script(script_name):
        print(f"🐍 Running {script_name}...")
        
        process = await asyncio.create_subprocess_exec(
            'python', script_name,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE
        )
        
        stdout, stderr = await process.communicate()
        
        if process.returncode == 0:
            print(f"✅ {script_name} succeeded!")
        else:
            print(f"❌ {script_name} failed!")
        
        return stdout.decode()
    
    async def main():
        # Run multiple Python scripts concurrently
        results = await asyncio.gather(
            run_python_script("script1.py"),
            run_python_script("script2.py"),
            run_python_script("script3.py"),
        )
    
    asyncio.run(main())
    ```

=== "Real-World Example"
    ```python
    import asyncio
    
    async def compress_video(video_file):
        """Compress video using ffmpeg (external tool)"""
        print(f"🎥 Compressing {video_file}...")
        
        cmd = f"ffmpeg -i {video_file} -c:v libx264 output.mp4"
        
        process = await asyncio.create_subprocess_shell(
            cmd,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE
        )
        
        await process.communicate()
        print(f"✅ {video_file} compressed!")
    
    async def compress_multiple_videos():
        videos = ["video1.mp4", "video2.mp4", "video3.mp4"]
        
        # Compress all videos concurrently
        await asyncio.gather(
            *[compress_video(v) for v in videos]
        )
        print("🎉 All videos compressed!")
    
    # asyncio.run(compress_multiple_videos())
    ```

---

### 🎯 Key Asyncio Features



#### 1. **`async def`** - Define Async Function

=== "Syntax"
    ```python
    async def my_async_function():
        """This function can use await"""
        await some_async_operation()
    ```

=== "Example"
    ```python
    async def fetch_data():
        print("🔍 Fetching data...")
        await asyncio.sleep(1)  # Simulate API call
        print("✅ Data fetched!")
        return {"user": "John"}
    ```

---

#### 2. **`await`** - Pause and Let Others Run

=== "Syntax"
    ```python
    result = await async_function()
    # "I'll wait here, others can work!"
    ```

=== "Example"
    ```python
    async def make_coffee():
        print("☕ Boiling water...")
        await asyncio.sleep(2)  # Release control!
        print("✅ Water boiled!")
    ```

=== "Real-Life"
    ```
    Waiting room analogy:
    
    You: "I need form A, I'll AWAIT" 📝
    System: "While you wait, I'll help others!"
    Person 2: Gets helped ✅
    Person 3: Gets helped ✅
    You: "Form ready!" ✅
    ```

---

#### 3. **`asyncio.gather()`** - Run Multiple Tasks Together

=== "Problem: Sequential Execution"
    ```python
    async def slow_way():
        await task1()  # Wait 2s
        await task2()  # Wait 2s
        await task3()  # Wait 2s
        # Total: 6 seconds 😢
    ```

=== "Solution: Concurrent Execution"
    ```python
    async def fast_way():
        await asyncio.gather(
            task1(),  # All three
            task2(),  # start
            task3()   # together!
        )
        # Total: 2 seconds 🎉
    ```

=== "Full Example"
    ```python
    async def cook_pasta():
        print("🍝 Cooking pasta...")
        await asyncio.sleep(3)
        return "Pasta ready"

    async def make_salad():
        print("🥗 Making salad...")
        await asyncio.sleep(2)
        return "Salad ready"

    async def bake_bread():
        print("🍞 Baking bread...")
        await asyncio.sleep(4)
        return "Bread ready"

    async def prepare_dinner():
        # Start all at once!
        results = await asyncio.gather(
            cook_pasta(),
            make_salad(),
            bake_bread()
        )
        print("🍽️ Dinner ready!")
        return results

    # Run it
    asyncio.run(prepare_dinner())
    ```

=== "Output"
    ```bash
    🍝 Cooking pasta...
    🥗 Making salad...
    🍞 Baking bread...
    🍽️ Dinner ready!
    
    ⏱️ Time: 4 seconds (not 9!)
    ```

---

#### 4. **`asyncio.create_task()`** - Start Task in Background

=== "Concept"
    ```python
    # Start task but don't wait immediately
    task = asyncio.create_task(long_operation())
    
    # Do other things
    await other_stuff()
    
    # Now wait for task to finish
    result = await task
    ```

=== "Example"
    ```python
    async def main():
        # Start brewing coffee (background)
        coffee_task = asyncio.create_task(brew_coffee())
        
        # While coffee brews, make toast
        await make_toast()
        
        # Now get the coffee
        coffee = await coffee_task
        
        print("☕🍞 Breakfast ready!")
    ```

=== "Output"
    ```bash
    ☕ Coffee brewing... (in background)
    🍞 Making toast...
    ✅ Toast ready!
    ✅ Coffee ready!
    ☕🍞 Breakfast ready!
    ```

---

#### 5. **`asyncio.sleep()`** - Non-Blocking Sleep

=== "Blocking Sleep ❌"
    ```python
    import time
    
    def slow():
        time.sleep(5)  # Everything stops! 😴
    ```

=== "Async Sleep ✅"
    ```python
    async def smart():
        await asyncio.sleep(5)  # Others can work! ⚡
    ```

---

### 🎯 Real-World Asyncio Scenarios

#### Scenario 1: Web Scraping Multiple Sites

=== "Problem"
    ```python
    # Scraping 10 websites sequentially
    # Website 1: 2 seconds
    # Website 2: 2 seconds
    # ...
    # Total: 20 seconds 😢
    ```

=== "Asyncio Solution"
    ```python
    async def scrape_website(url):
        async with aiohttp.ClientSession() as session:
            async with session.get(url) as response:
                return await response.text()

    async def scrape_all():
        urls = [f"https://site{i}.com" for i in range(10)]
        
        # Scrape all at once!
        results = await asyncio.gather(
            *[scrape_website(url) for url in urls]
        )
        return results
    
    # Total: 2 seconds! 🎉
    ```

---

#### Scenario 2: Database Queries

=== "Problem"
    ```python
    # 100 database queries, each takes 0.1s
    # Sequential: 10 seconds total 😢
    
    for user_id in range(100):
        user = db.get_user(user_id)  # Wait each time
    ```

=== "Asyncio Solution"
    ```python
    async def get_user(user_id):
        # Async database query
        return await db.fetch_user(user_id)

    async def get_all_users():
        # Get all 100 users concurrently!
        tasks = [get_user(i) for i in range(100)]
        users = await asyncio.gather(*tasks)
        return users
    
    # Total: 0.1 seconds! 🎉
    ```

---

#### Scenario 3: API Requests

=== "Problem"
    ```python
    # Calling 5 different APIs
    # Each takes 1 second
    # Total: 5 seconds 😢
    
    weather = requests.get("weather_api")
    stocks = requests.get("stock_api")
    news = requests.get("news_api")
    ```

=== "Asyncio Solution"
    ```python
    async def fetch_all_data():
        async with aiohttp.ClientSession() as session:
            # Call all APIs at once!
            weather, stocks, news = await asyncio.gather(
                session.get("weather_api"),
                session.get("stock_api"),
                session.get("news_api")
            )
            return weather, stocks, news
    
    # Total: 1 second! 🎉
    ```

---

## 📋 Quick Reference Card

```python
# Basic async function
async def my_func():
    await asyncio.sleep(1)

# Run async function
asyncio.run(my_func())

# Run multiple tasks together
await asyncio.gather(task1(), task2(), task3())

# Create background task
task = asyncio.create_task(long_task())

# Wait for task
result = await task

# Non-blocking sleep
await asyncio.sleep(seconds)
```

---

## ✅ When to Use Asyncio?

| ✅ Use Asyncio | ❌ Don't Use Asyncio |
|---------------|---------------------|
| 🌐 API calls | 🧮 Heavy math calculations |
| 📡 Network requests | 🔢 Data processing |
| 💾 Database queries | 🖼️ Image processing |
| 📁 File I/O operations | 🎥 Video encoding |
| 🌊 Websockets | 🔐 Encryption |

!!! tip "Golden Rule"
    Use asyncio for **I/O-bound** tasks (waiting for external resources).
    
    Use **multiprocessing** for **CPU-bound** tasks (heavy computation).

---

## 🎯 Key Takeaways

1. **Asyncio is NOT parallelism** - It's smart task switching (concurrency)
2. **Perfect for I/O operations** - API calls, file operations, network requests
3. **`async`/`await` keywords** - Make code asynchronous
4. **`asyncio.gather()`** - Run multiple tasks concurrently
5. **Non-blocking** - Don't waste time waiting!

!!! success "Remember"
    Asyncio doesn't make your code faster by running on multiple cores.
    
    It makes your code faster by **not wasting time waiting**! ⚡🚀

---

Happy Async Coding! 🐍✨

