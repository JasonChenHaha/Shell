if [ `ps aux | grep nginx | wc -l` -gt 2 ]; then
    echo -e "\033[33mnginx has been running.\033[0m"
    exit
fi

echo "testing..."

nginx -t -c /usr/local/openresty/nginx/conf/nginx_test.conf

if [ $? != 0 ]; then
    exit
fi

echo "starting..."

nginx -c /usr/local/openresty/nginx/conf/nginx_test.conf

if [ $? == 0 ]; then
    echo -e "\033[32mok\033[0m"
fi
