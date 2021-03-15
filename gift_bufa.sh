cat ./gift_out.log | while read line; do
        uin=${line%=*}
        data=${line#*=}
        auth=`echo -n '0#miniw_907#'$uin|md5sum|cut -d ' ' -f1`
        msg=$(curl -s -g '127.0.0.1:8079/miniw/mission?cmd=add_bufa_job&uin='$uin'&data='$data'&from=gift&time=0&auth='$auth)
        if [ "$msg" == "{\"ret\":0}" ]; then
                echo $line >> gift_ok.log
        else
                echo $line >> gift_fail.log
        fi
done
