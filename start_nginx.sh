if [ `ps aux | grep nginx | wc -l` -gt 2 ]; then
    echo -e "\033[33mnginx has been running.\033[0m"
    exit
fi

echo "testing nginx..."

nginx -t

if [ $? != 0 ]; then
    echo -e "\033[31mtest nginx failed\033[0m"
    exit
fi

echo "starting nginx..."

nginx

if [ $? != 0 ]; then
    echo -e "\033[31mstart nginx failed\033[0m"
    exit
else
    echo -e "\033[32mok\033[0m"
fi

echo "starting cpu watch dog..."

function check_watchdog() {
    return `ps aux | grep cpu_watchdog.sh | grep -v grep | awk '{print$2}' | wc -l`
}

check_watchdog
if [ $? == 0 ]; then
    nohup ./.cpu_watchdog.sh > /dev/null 2>&1 &
fi

check_watchdog
if [ $? == 0 ]; then
    echo -e "\033[31mstart watch dog failed.\033[0m"
    exit
else
    echo -e "\033[32mok\033[0m"
fi
