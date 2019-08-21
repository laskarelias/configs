function read_vol {
    vol=$(amixer -M sget Master | awk -F "[][]" '{print $2}' | grep -o '[0-9]\+')
}

function read_bat {
    bat=$(cat /sys/class/power_supply/BAT0/capacity)
}

function read_pow {
    pow=$(cat /sys/class/power_supply/BAT0/status)
    if [[ $pow == "Discharging" ]]; then
	pow="-"
    elif [[ $pow == "Charging" ]]; then
	pow="+"
    elif [[ $pow == "Full" ]]; then
	pow="="
    fi
}

function read_wifi {
#    wifi=$(nmcli device wifi | awk '/\*/ {if (NR!=1) { print $6 }}')
    wifi=$(awk 'NR==3 {print int($3*(10/7))}''' /proc/net/wireless)
    if [[ $wifi == "" ]]; then
	wifi="x"
    fi
}

function read_time {
    time=$(date +"%a%d %H%M")
}

while [ 1 ]
do
    read_vol
    read_bat
    read_pow
    read_wifi
    read_time	
    xsetroot -name "♫$vol $bat$pow ⊿$wifi $time"
    sleep 0.1
done
