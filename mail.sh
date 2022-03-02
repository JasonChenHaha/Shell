i=0
uin=0
title=''
body=''
cat $1 | while read line; do
    j=$(($i%3))
    if [ $j -eq 0 ]; then
        uin=$line
    elif [ $j -eq 1 ]; then
        title=`(echo $line | tr -d '\n' | xxd -plain | sed 's/\(..\)/%\1/g')`
    else
        body=`(echo $line | tr -d '\n' | xxd -plain | sed 's/\(..\)/%\1/g')`
        body2=`(echo $body)`
        body2=${body2//' '/'%20'}
        url='http://123.207.245.244:8080/miniw/mail?cmd=send_mail_to_player&end_time=1647964800&uin='$uin'&title='$title'&body='$body2
        msg=$(curl -s $url)
        if [[ $msg == *'result":0'* ]]; then
            echo $uin >> ./ok.log
        else
            echo $uin >> ./failed.log
        fi
    fi
    i=$((i+1))
done
