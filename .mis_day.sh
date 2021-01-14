file_path=/usr/local/openresty/nginx/logs

last_date="`date -d yesterday +%Y-%m-%d`"
new_last_date="`date -d yesterday +%Y%m%d`"

#########################################################

gift_send() {
	gift_file=$file_path/gift_$last_date.log
	gift_new_file=$file_path/gift_$new_last_date.log
	if [ -f $gift_file ]; then
	    while read line; do
        	if [[ "$line" != *"error_buy"* ]]; then
	            head=`echo $line | awk '{print $1" "$2}'`
        	    time=${head:1:-1}
	            time=`date -d "$time" +%s`
        	    tail=${line#*] }
	            echo $time'|'$tail >> $gift_new_file
        	fi
	    done < $gift_file
	    scp $gift_new_file root@10.135.141.133:/data/login_temp/miniw
	    rm -f $gift_new_file
	fi
}

#########################################################

baoku_send() {
	baoku_file=$file_path/baoku_$last_date.log
	baoku_new_file=$file_path/baoku_$new_last_date.log
	if [ -f $baoku_file ]; then
	    while read line; do
        	if [[ "$line" == *"purchase"* ]]; then
	            head=`echo $line | awk '{print $1" "$2}'`
        	    time=${head:1:-1}
	            time=`date -d "$time" +%s`
        	    tail=${line#*] }
	            echo $time'|'$tail >> $baoku_new_file
        	fi
	    done < $baoku_file
	    scp $baoku_new_file root@10.135.141.133:/data/login_temp/miniw
	    rm -f $baoku_new_file
	fi
}

#########################################################

file_send() {
    file=$file_path/$1_$last_date.log
    new_file_name=$1_$new_last_date.log
    if [ -f $file ]; then
        scp $file root@10.135.141.133:/data/login_temp/miniw/$new_file_name
    fi
}

file_loop() {
    while [ `ls $file_path/$1_*.log | wc -l` -gt $2 ]; do
        rm -f `ls $file_path/$1_*.log | sort -V | head -n 1`
    done
}


file_send back

gift_send
baoku_send

file_loop gift 60
file_loop back 60
file_loop baoku 60
file_loop mis_qps 1
file_loop autoCleanDB 5
