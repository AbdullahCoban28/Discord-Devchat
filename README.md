# DevChat to Discord Message Relay

This project includes a message relay system between DevChat and Discord.

## Installation

1. **Prerequisites**
   - Node.js and npm should be installed.
   - Lua should be installed.
   - Required npm packages like `discord.js`, `ws`, `@permaweb/aoconnect`, and `fs` should be installed.

2. **Installation of Required npm Packages**
   Run the following command in the terminal or command prompt to install the required npm packages:

3. **Project Directory Structure**
The project directory should be structured as follows:
/root/DevChat/src/
|-- capture.js
|-- index.js
|-- process.lua
|-- client.lua
|-- chatroom.lua
|-- router.lua


4. **Setup and Usage**
- Load Lua scripts in the aos terminal:
  ```
  .load /root/DevChat/src/router.lua
  .load /root/DevChat/src/client.lua
  .load /root/DevChat/src/chatroom.lua
  .load /root/DevChat/src/process.lua
  ```
- Register the channel:
  ```
  ao.send({ Target = "xnkv_QpWqICyt8NpVMbfsUQciZ4wlm5DigLrfXRm8fY", Action = "Register", Name = "AbdullahDiscordDevchat" })
  ```
- Join the registered channel:
  ```
  Join("AbdullahDiscordDevchat")
  ```
- Send a test message:
  ```
  Say("Hello, this is a first test message.", "AbdullahDiscordDevchat")
  ```
- Start the WebSocket server by running index.js script:
  ```
  node /root/DevChat/src/index.js
  ```
- Run capture.js script to capture DevChat messages:
  ```
  node /root/DevChat/src/capture.js
  ```

5. **Testing**
- Test by sending a message from DevChat:
  ```
  Say("Hello, this is a test message.", "AbdullahDiscordDevchat")
  ```
- Check if the message appears in the Discord channel.

6. **License**
This project is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file for details.
