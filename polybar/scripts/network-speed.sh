#!/usr/bin/env bash

conversion_factor=1024

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

    local rx_rate=$(( rx_bytesb - rx_bytesa )) # bytes/s
    local tx_rate=$(( tx_bytesb - tx_bytesa )) # bytes/s

    local rx_rate_unit="bytes/s"
    local tx_rate_unit="bytes/s"

    if (( rx_rate > conversion_factor )); then
        (( rx_rate /= conversion_factor ))
        rx_rate_unit="kb/s"
    fi

    if (( rx_rate > conversion_factor )); then
        (( rx_rate /= conversion_factor ))
        rx_rate_unit="mb/s"
    fi

    if (( tx_rate > conversion_factor )); then
        (( tx_rate /= conversion_factor ))
        tx_rate_unit="kb/s"
    fi

    if (( tx_rate > conversion_factor )); then
        (( tx_rate /= conversion_factor ))
        tx_rate_unit="mb/s"
    fi

    echo "%{F#f0c674}DOWN%{F-} ${rx_rate} ${rx_rate_unit} %{F#f0c674}UP%{F-} ${tx_rate} ${tx_rate_unit}"
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
