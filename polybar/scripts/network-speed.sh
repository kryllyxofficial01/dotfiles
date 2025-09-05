#!/usr/bin/env bash

get_active_interface() {
    ip route get 1.1.1.1 | awk '{for(i=1;i<=NF;i++) if ($i=="dev") print $(i+1); exit}'
}

get_speed() {
    local iface="$1"

    local rx_bytesa tx_bytesa rx_bytesb tx_bytesb
    rx_bytesa=$(< /sys/class/net/"$iface"/statistics/rx_bytes)
    tx_bytesa=$(< /sys/class/net/"$iface"/statistics/tx_bytes)

    sleep 1

    rx_bytesb=$(< /sys/class/net/"$iface"/statistics/rx_bytes)
    tx_bytesb=$(< /sys/class/net/"$iface"/statistics/tx_bytes)

    local rx_rate=$(( (rx_bytesb - rx_bytesa) / 1024 ))  # KB/s
    local tx_rate=$(( (tx_bytesb - tx_bytesa) / 1024 ))  # KB/s

    echo "%{F#f0c674}DOWN%{F-} ${rx_rate} KB/s %{F#f0c674}UP%{F-} ${tx_rate} KB/s"
}

main() {
    local iface
    iface=$(get_active_interface)

    if [[ -z "$iface" ]]; then
        echo "Disconnected"
        exit 1
    fi

    get_speed "$iface"
}

main
