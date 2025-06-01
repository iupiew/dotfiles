#!/bin/bash
# Network control popup menu
options="Enable WiFi\nDisable WiFi\nConnect VPN\nDisconnect VPN\nNetwork Settings"
chosen=$(echo -e "$options" | rofi -dmenu -p "Network")

case "$chosen" in
    "Enable WiFi") nmcli radio wifi on ;;
    "Disable WiFi") nmcli radio wifi off ;;
    "Connect VPN") nmcli connection up "YourVPNName" ;;
    "Disconnect VPN") nmcli connection down "YourVPNName" ;;
    "Network Settings") nm-connection-editor ;;
esac
