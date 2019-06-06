email_addr="270219009@qq.com"

#cpu_idle_line=10

cpu_yellow_line=0.75

cpu_red_line=1

IP=`ifconfig eth0 | grep '\binet\b' | awk '{print $2}'`

CPU_NUM=`grep -c 'model name' /proc/cpuinfo`

#str=`top -b -n 1 |grep Cpu`
#str=${str#*ni,}
#cpu_idle=${str% id*}

while true; do
	Date=`date +"%Y-%m-%d %H-%M-%S"`

	str=`uptime`
	Loads=${str##*, }

	ave=$(echo "scale=2; $Loads / $CPU_NUM"|bc)

	msg="告警：CPU负载过高！！\n时间：$Date\n服务器IP：$IP\n当前负载：$Loads\n平均负载：$ave"

	if [ "`echo "${ave} >= $cpu_red_line" | bc`" -eq 1 ]; then
        	echo -e "红色$msg" \
        	| mail -s "CPU负载过高" $email_addr
	elif [ "`echo "${ave} >= $cpu_yellow_line" | bc`" -eq 1 ]; then
        	echo -e "黄色$msg" \
        	| mail -s "CPU负载过高" $email_addr
	fi

	sleep $((60*15))
done
