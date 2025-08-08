# 🔐 HardenMe Script – Modular Linux Hardening Toolkit

## 📝 Description

HardenMe is a lightweight, modular Bash script designed to automate essential Linux system hardening tasks for Debian, Ubuntu, and Kali-based systems. Tailored for minimal environments such as IoT devices, servers, and workstations, the script provides predefined hardening profiles and modular functionality to quickly improve a system’s baseline security.

By using simple flags like `--firewall-only`, `--server`, and `--iot`, users can apply specific hardening configurations suited to their deployment environment. This makes it ideal for sysadmins, cybersecurity students, hobbyists, or anyone seeking a fast and understandable way to secure Linux machines.

---

## 🎯 Key Objectives

- Provide a modular, easy-to-use hardening framework.
- Enable automated application of security best practices.
- Avoid bloat by targeting only essential and common vulnerabilities.
- Keep the script understandable and customizable for beginners.

---

## ⚙️ Features

- 🔥 **Firewall Setup (UFW)**  
  Automatically installs and configures the UFW firewall with secure defaults.

- 🧹 **Disable Unused Services**  
  Stops and disables potentially risky or unnecessary services (e.g., Bluetooth, RPC).

- 🔐 **Password Policy Enforcement**  
  Enforces strong password length, complexity, and aging rules via PAM and login.defs.

- 📝 **Audit Logging Enablement**  
  Installs and enables `auditd` to log sensitive system events.

- 🚫 **Root SSH Login Disablement**  
  Prevents direct root login over SSH to reduce remote attack surface.

- 📦 **IoT Profile (Lightweight Security)**  
  Removes compilers and disables USB storage modules for minimal embedded systems.

---

## 🧪 Usage

Run with a simple flag:
```bash
sudo ./hardenme.sh --server
```

### Available Flags:

- `--firewall-only` → Only set up UFW
- `--server` → Apply full server hardening
- `--iot` → Lightweight hardening for IoT/embedded Linux
- `--help` → View usage info

---

## ✅ Ideal Use Cases

- Hardening cloud servers, VPS, or home servers
- Securing Raspberry Pi or custom IoT builds
- Teaching Linux security in cybersecurity labs
- Creating custom install ISOs with pre-hardened settings
