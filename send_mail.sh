i=0
uin=0
title=''
body=''
cat ./abc.csv | while read line; do
    j=$(($i%3))
    if [ $j -eq 0 ]; then
        uin=$line
    elif [ $j -eq 1 ]; then
        title=$line
    else
        body=$line
        msg=$(curl -s '123.207.245.244:8080/miniw/mail?cmd=send_mail_to_player&end_time=1647964800&uin='$uin'&title='$title'&body='$body)
        if [ "$msg" == "{\"result\":0}" ]; then
            echo $uin >> ./ok.log
        else
            echo $uin >> ./failed.log
        fi
    fi
    i=$((i+1))
done
