# 🚔 ESX Staff Ped Menu (with Discord & ACE permissions)

A FiveM resource for **ESX 1.7.5** that allows staff members to change into special ped models using a clean **ox_lib** menu.  
Supports both **Badger_Discord_API** (for Discord role-based permissions) and **ACE permissions** from your `server.cfg`.  
Includes optional Discord logging through a server-side webhook.

---

## ✨ Features

- 🧍‍♂️ Open an ox_lib context menu with `/setped`
- 🐆 Choose from a configurable list of ped models (animals, NPCs, etc.)
- ✅ Permission system integrated with:
  - **Badger_Discord_API** (Discord roles)
  - **ACE permissions**
- 🧾 Configurable webhook logging (via server.lua)
- 🎥 Ped preview camera before confirmation
- 🔄 Works on ESX 1.7.5 and compatible forks

---

## 🧩 Dependencies

- [es_extended (v1.7.5+)](https://github.com/esx-framework/es_extended)
- [ox_lib](https://github.com/overextended/ox_lib)
- [Badger_Discord_API](https://github.com/JaredScar/Badger_Discord_API)

---

## ⚙️ Installation

1. **Download** or **clone** this resource:
   ```bash
   git clone https://github.com/JaimeVRX/esx_staffped.git
   ```

2. Place the folder inside your server’s `resources` directory.

3. Add the following line to your `server.cfg`:
   ```ini
   ensure esx_staffped
   ```

4. Add ACE permissions for staff groups (recommended):
   ```ini
   add_ace group.owner staffped.use allow
   add_ace group.admin staffped.use allow
   add_ace group.moderator staffped.use allow
   ```

5. Make sure you have Badger_Discord_API running and configured with your guild ID and bot token.

---

## 🧰 Configuration

Open `config.lua` and add your staff peds:

```lua
Config.Peds = {
    { label = "Panther", model = "a_c_panther" },
    { label = "Mountain Lion", model = "a_c_mtlion" },
    { label = "Cop Male", model = "s_m_y_cop_01" },
    { label = "Security Guard", model = "s_m_m_security_01" }
}

Config.AllowedRoles = { -- Discord role IDs (numbers only)
    "123456789012345678", -- Example: Admin
    "234567890123456789"  -- Example: Moderator
}
```

---

## 🔐 Permission System

The script checks both systems in this order:

1. **Discord Roles** via `Badger_Discord_API:GetDiscordRoles(source)`
2. **ACE Permissions** via `IsPlayerAceAllowed(source, "staffped.use")`

If either check passes, the staff member can open the ped menu.

---

## 🧾 Discord Logging

To enable webhook logging, set your webhook URL in `server.lua`:

```lua
Config.Webhook = "https://discord.com/api/webhooks/XXXXXXXXX/XXXXXXXXX"
```

Logs each ped change with player name, ID, and chosen ped.

---

## 💬 Commands

| Command | Description |
|----------|--------------|
| `/setped` | Opens the staff ped menu (if permissions are valid) |

---

## 🧱 Preview

![Preview Screenshot](https://i.imgur.com/YOUR_PREVIEW.png)

---

## 🧑‍💻 Credits

- Script by **Jaime**
- Built with ❤️ 
- Special thanks to the FiveM community

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
