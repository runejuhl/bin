#!/bin/bash

BAT_STATE=`cat /sys/class/power_supply/BAT0/status`
# AC_STATE=cat /sys/class/power_supply/AC/online
WARN_LEVEL=${WARN_LEVEL:-20}

STATE=$(cat /sys/class/leds/tpacpi::power/brightness)
SLEEP_TIME=${SLEEP_TIME:-60}
HIBERNATE_BAT_PCT=${HIBERNATE_BAT_PCT:-2}

update_cap () {
    BAT_CAP=`cat /sys/class/power_supply/BAT0/capacity`
}

toggle_power_led () {
    STATE=$(( ! $STATE ))
    echo $STATE > /sys/class/leds/tpacpi::power/brightness
}

echo "batterywarning starting, will warn at ${WARN_LEVEL}, force hibernation at ${HIBERNATE_BAT_PCT} and sleep ${SLEEP_TIME} between checks."

while [[ true ]]; do
    update_cap

    if [[ ${BAT_CAP} -le ${HIBERNATE_BAT_PCT} ]]; then
        pm-hibernate
    fi

    if [[ "${BAT_STATE}" -eq 'Discharging' \
                && "${BAT_CAP}" -le "${WARN_LEVEL}" ]]; then
        SLEEP_TIME_WARN=$(echo "scale=2; (${BAT_CAP} / 20)" | bc)
        COUNT=$(echo "(${SLEEP_TIME} / ${SLEEP_TIME_WARN})" | bc)

        I=0
        while [[ ${I} -lt ${COUNT} ]]; do
            (( I++ ))
            toggle_power_led
            sleep ${SLEEP_TIME_WARN}
        done
    else
        sleep ${SLEEP_TIME}
    fi

done
