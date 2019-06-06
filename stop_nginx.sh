if [ `ps aux | grep nginx | wc -l` -lt 2 ]; then
    echo -e "\033[33mnginx isn't running.\033[0m"
    exit
fi

echo "stopping nginx..."

nginx -s stop

if [ $? != 0 ]; then
    echo -e "\033[31mstop nginx failed.\033[0m"
    exit
else
    echo -e "\033[32mok\033[0m"
fi

echo "stopping watch dog..."

function check_watchdog() {
    return `ps aux | grep cpu_watchdog.sh | grep -v grep | awk '{print$2}' | wc -l`
}

check_watchdog
if [ $? != 0 ]; then
    kill `ps aux | grep cpu_watchdog.sh | grep -v grep | awk '{print$2}'`
    check_watchdog
    if [ $? != 0 ]; then
        echo -e "\033[31mstop watch dog failed.\033[0m"
        exit
    fi
fi

echo -e "\033[32mok\033[0m"
