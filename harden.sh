#!/bin/bash

set -e

# === Color Codes ===
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}[+] HardenMe Script Loaded...${NC}"

# === MODULES ===

# 1. Firewall Setup
setup_firewall() {
  echo -e "${GREEN}[+] Setting up UFW firewall...${NC}"
  apt-get update -y
  apt-get install -y ufw
  ufw default deny incoming
  ufw default allow outgoing
  ufw allow OpenSSH
  ufw --force enable
  echo -e "${GREEN}[✔] UFW firewall enabled.${NC}"
}

# 2. Disable Unused Services
disable_unused_services() {
  echo -e "${GREEN}[+] Disabling unnecessary services...${NC}"
  local services=(avahi-daemon cups bluetooth rpcbind nfs-common)
  for svc in "${services[@]}"; do
    if systemctl list-units --type=service --all | grep -q "$svc"; then
      systemctl stop "$svc" 2>/dev/null || true
      systemctl disable "$svc" 2>/dev/null || true
      echo " - Disabled $svc"
    fi
  done
}

# 3. Enforce Password Policies
enforce_password_policies() {
  echo -e "${GREEN}[+] Enforcing password policies...${NC}"
  echo "PASS_MAX_DAYS 90" >> /etc/login.defs
  echo "PASS_MIN_DAYS 7" >> /etc/login.defs
  echo "PASS_WARN_AGE 14" >> /etc/login.defs
  apt-get install -y libpam-pwquality
  sed -i '/pam_pwquality.so/ s/$/ retry=3 minlen=12 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1/' /etc/pam.d/common-password
  echo -e "${GREEN}[✔] Password policy enforced.${NC}"
}

# 4. Enable Audit Logging
enable_audit_logging() {
  echo -e "${GREEN}[+] Enabling audit logging...${NC}"
  apt-get install -y auditd audispd-plugins
  systemctl enable auditd
  systemctl start auditd
  echo -e "${GREEN}[✔] Auditd is enabled.${NC}"
}

# 5. Disable Root SSH Login
disable_root_ssh() {
  echo -e "${GREEN}[+] Disabling root SSH login...${NC}"
  sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
  systemctl reload sshd
  echo -e "${GREEN}[✔] Root login over SSH disabled.${NC}"
}

# 6. Disable Compilers (IoT)
disable_compilers() {
  echo -e "${GREEN}[+] Removing compilers for IoT hardening...${NC}"
  apt-get purge -y gcc g++ make
  echo -e "${GREEN}[✔] Compilers removed.${NC}"
}

# 7. Lock Kernel Modules (IoT)
lock_kernel_modules() {
  echo -e "${GREEN}[+] Locking kernel modules...${NC}"
  echo "install usb-storage /bin/false" >> /etc/modprobe.d/disable-usb.conf
  echo -e "${GREEN}[✔] USB storage module blocked.${NC}"
}

# === PROFILES ===

server_profile() {
  echo -e "${GREEN}[+] Running SERVER hardening profile...${NC}"
  disable_unused_services
  setup_firewall
  enforce_password_policies
  enable_audit_logging
  disable_root_ssh
  echo -e "${GREEN}[✔] Server hardening complete.${NC}"
}

iot_profile() {
  echo -e "${GREEN}[+] Running IoT hardening profile...${NC}"
  disable_compilers
  setup_firewall
  lock_kernel_modules
  echo -e "${GREEN}[✔] IoT hardening complete.${NC}"
}

# === MAIN ARGUMENT HANDLER ===

case "$1" in
  --firewall-only)
    setup_firewall
    ;;
  --server)
    server_profile
    ;;
  --iot)
    iot_profile
    ;;
  --help|-h)
    echo -e "${GREEN}Usage:${NC} $0 [--firewall-only | --server | --iot]"
    ;;
  *)
    echo -e "${RED}[!] Invalid option.${NC} Use --help to see available flags."
    exit 1
    ;;
esac
