#!/bin/bash

BAT_STATE=`cat /sys/class/power_supply/BAT0/status`
# AC_STATE=cat /sys/class/power_supply/AC/online
WARN_LEVEL=${WARN_LEVEL:-20}

STATE=1
SLEEP_TIME=10
HIBERNATE_BAT_PCT=5

update_cap () {
    BAT_CAP=`cat /sys/class/power_supply/BAT0/capacity`
    echo $BAT_CAP
}

toggle_power_led () {
    STATE=$(( ! $STATE ))
    echo $STATE > /sys/class/leds/tpacpi::power/brightness
}

update_cap

id

echo $WARN_LEVEL

while [[ true ]]; do
    update_cap

    if [[ ${BAT_CAP} -le ${HIBERNATE_BAT_PCT} ]]; then
        pm-hibernate
    fi

    if [[ $BAT_STATE -eq 'Discharging' && $BAT_CAP -le ${WARN_LEVEL} ]]; then
        SLEEP_TIME_WARN=$(echo "scale=2; ($BAT_CAP / 20)" | bc)
        COUNT=`echo "(${SLEEP_TIME} / ${SLEEP_TIME_WARN})" | bc`

        I=0
        while [[ ${I} -lt ${COUNT} ]]; do
            (( I++ ))
            toggle_power_led
            sleep ${SLEEP_TIME_WARN}
        done
        echo done
    else
        sleep 10
    fi

done
