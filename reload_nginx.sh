if [ `ps aux | grep nginx | wc -l` -lt 2 ]; then
    echo -e "\033[33mnginx isn't running.\033[0m"
    exit
fi

echo "reloading..."

nginx -s reload

if [ $? == 0 ]; then
    echo -e "\033[32mok\033[0m"
fi
