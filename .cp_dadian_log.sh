file_path=/usr/local/openresty/nginx/logs

last_date="`date -d yesterday +%Y-%m-%d`"
new_last_date="`date -d yesterday +%Y%m%d`"

file_name=$file_path/gift_$last_date.log
new_file_name=$file_path/gift_$new_last_date.log

if [ -f $file_name ]; then
    while read line; do
        if [[ "$line" != *"error_buy"* ]]; then
            head=`echo $line | awk '{print $1" "$2}'`
            time=${head:1:-1}
            time=`date -d "$time" +%s`
            tail=${line#*] }
            echo $time'|'$tail >> $new_file_name
        fi
    done < $file_name

    scp -P 37325 $new_file_name root@198.11.178.73:/data/login_temp/miniw
    rm -f $new_file_name

    while [ `ls $file_path/gift_*.log | wc -l` -gt 10 ]; do
        rm -f `ls $file_path/gift_*.log | sort -V | head -n 1`
    done
fi