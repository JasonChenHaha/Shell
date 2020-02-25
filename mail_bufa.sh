i=0
uin=0
str=''
cat ./log_bufa.log | while read line; do
    if [ $(($i%2)) -eq 0 ]; then
        uin=$line
    else
        str=$line
        msg=''
        msg=$(curl -s '123.207.245.244:8080/miniw/mail?cmd=send_mail_to_player&uin='$uin'&attach='$str'&title=道具补发&body=亲爱的冒险家，补发您家园果实道具，请尽快通过邮件附件收取&end_time=1585152000')
        if [ "$msg" == "{\"result\":0}" ]; then
            echo $uin >> ./test_ok.log
        else
            echo $uin'|'$str >> ./test_failed.log
        fi
    fi
    i=$((i+1))
    sleep 0.1
done
