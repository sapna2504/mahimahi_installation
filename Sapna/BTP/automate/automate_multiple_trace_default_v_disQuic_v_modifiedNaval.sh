#!/usr/bin/env bash

set -x

if [ $# -lt 4 ]
then
    echo use $0 "<tracefile> <video_id_file> <day_timing> <loop_required> <browser>"
    exit 1
fi

tracefileFolder=$1; shift
video_id_file=$1; shift
day_timing=$1;shift
loop_required=$1;shift
chromium_flags=$1;shift

cat $video_id_file


exeFile=$(mktemp)

function runScript() 
{
    exeFile=$1; shift
    vid=$1; shift
    disQuic=$1; shift
    timing=$1; shift
    protocol=$1; shift
    browser=$1;shift

    cat > $exeFile << EOF
    #!/usr/bin/env bash

    set -x

    export CHROME_LOG_FILE=$udir/chrome_debug.log
    mkdir -p $udir
    # export SSLKEYLOGFILE=$udir/chrome_sslkeylog.log
    # ~/Desktop/NK/code/chromium/src/out/${browser}/chrome --user-data-dir=$udir "https://www.youtube.com/embed/$vid?rel=0&autoplay=1" --load-extension=~/Sapna/BTP/DASH/adblock,~/Sapna/BTP/DASH/NetworkLogExtension $disQuic --no-proxy-server --autoplay-policy=no-user-gesture-required --no-first-run --enable-logging -log-level=0 --start-maximized --no-default-browser-check --log-net-log=netlogs/chrome_debug_${vid}_"${log_type}"_"${protocol}"_${timing}_${browser}.json --net-log-capture-mode=Everything
    ~/chromium/src/out/${browser}/chrome --user-data-dir=$udir "https://www.youtube.com/embed/$vid?rel=0&autoplay=1" --load-extension=~/Sapna/BTP/DASH/NetworkLogExtension $disQuic --no-proxy-server --autoplay-policy=no-user-gesture-required --no-first-run --enable-logging -log-level=0 --start-maximized --no-default-browser-check $chromium_flags

    cpid=\$!
    kill -INT cpid
EOF
}

chmod +x $exeFile

for tracefile in $tracefileFolder
do
	log_type="$(cut -d'.' -f1 <<<"$(cut -d'/' -f2 <<<"$tracefile")")"

	for vid in `cat $video_id_file`
	do
	    currenttime=$(date +%H:%M)
	    flag=0
	    timing=${day_timing}

	    if [[ "$day_timing" == "morning" ]]; then
	        while :
	        do
	            if [[ "$currenttime" > "08:00" ]] && [[ "$currenttime" < "16:00" ]]; then
	                flag=1
	                break
	            fi
	            
	            if [[ "$loop_required" == "false" ]]; then
	                break
	            fi

	            currenttime=$(date +%H:%M)
	        done

	        echo $currenttime
	    fi

	    if [[ "$day_timing" == "afternoon" ]]; then
	        while :
	        do
	            if [[ "$currenttime" > "16:00" ]] && [[ "$currenttime" < "23:59" ]]; then
	                flag=1
	                break
	            fi

	            if [[ "$loop_required" == "false" ]]; then
	                break
	            fi

	            currenttime=$(date +%H:%M)
	        done
	        echo $currenttime
	    fi

	    if [[ "$day_timing" == "evening" ]]; then
	        while :
	        do
	            if [[ "$currenttime" > "00:00" ]] && [[ "$currenttime" < "08:00" ]]; then
	                flag=1
	                break
	            fi

	            if [[ "$loop_required" == "false" ]]; then
	                break
	            fi

	            currenttime=$(date +%H:%M)
	        done
	        echo $currenttime
	    fi

	    if [[ "$day_timing" == "lowbw" ]] || [[ "$day_timing" == "highbw" ]]; then
	        flag=1
	    fi

	    if [[ "$day_timing" == "slot" ]]; then
	        flag=1
	        timing=${day_timing}-${loop_required}
	    fi


	    if [[ "$flag" == "1" ]]; then
	        echo $vid

	        build="Modified"
	        
	        udir=$(mktemp -d)
	        runScript $exeFile $vid " " $timing "quic" "Modified"
	        chmod +x $exeFile

	        sudo bash tcpdump_start.sh pcaps/${vid}_"${log_type}"_${build}_${timing}
	        
	        mm-link $tracefile $tracefile $exeFile
	        # $exeFile

	        sudo bash tcpdump_stop.sh


	        cp ${udir}/chrome_debug.log logs/chrome_debug_${vid}_"${log_type}"_${build}_${timing}.log
	        cp logs/chrome_debug_${vid}_"${log_type}"_${build}_${timing}.log logs-collected/chrome_debug_${vid}_"${log_type}"_${build}_${timing}.log

	        # cp ${udir}/chrome_sslkeylog.log sslkeylogs/chrome_debug_${vid}_"${log_type}"_quic_${timing}_Modified.log
	  
	        rm -rf $udir
	        rm $exeFile
	        echo $vid + " " + $build + " complete"
	        sleep 10
	    fi

	    if [[ "$flag" == "1" ]]; then
	        echo $vid

	        build="Default"
	        
	        udir=$(mktemp -d)
	        runScript $exeFile $vid " " $timing "quic" "Default"
	        chmod +x $exeFile

	        sudo bash tcpdump_start.sh pcaps/${vid}_"${log_type}"_${build}_${timing}
	        
	        mm-link $tracefile $tracefile $exeFile
	        # $exeFile

	        sudo bash tcpdump_stop.sh


	        cp ${udir}/chrome_debug.log logs/chrome_debug_${vid}_"${log_type}"_${build}_${timing}.log
	        cp logs/chrome_debug_${vid}_"${log_type}"_${build}_${timing}.log logs-collected/chrome_debug_${vid}_"${log_type}"_${build}_${timing}.log

	        # cp ${udir}/chrome_sslkeylog.log sslkeylogs/chrome_debug_${vid}_"${log_type}"_quic_${timing}_Modified.log
	  
	        rm -rf $udir
	        rm $exeFile
	        echo $vid + " " + $build + " complete"
	        sleep 10
	    fi

	    if [[ "$flag" == "1" ]]; then
	        echo $vid

	        build="DefaultDisQuic"
	        
	        udir=$(mktemp -d)
	        runScript $exeFile $vid " --disable-quic " $timing "quic" "Default"
	        chmod +x $exeFile

	        sudo bash tcpdump_start.sh pcaps/${vid}_"${log_type}"_${build}_${timing}
	        
	        mm-link $tracefile $tracefile $exeFile
	        # $exeFile

	        sudo bash tcpdump_stop.sh


	        cp ${udir}/chrome_debug.log logs/chrome_debug_${vid}_"${log_type}"_${build}_${timing}.log
	        cp logs/chrome_debug_${vid}_"${log_type}"_${build}_${timing}.log logs-collected/chrome_debug_${vid}_"${log_type}"_${build}_${timing}.log

	        # cp ${udir}/chrome_sslkeylog.log sslkeylogs/chrome_debug_${vid}_"${log_type}"_quic_${timing}_Modified.log
	  
	        rm -rf $udir
	        rm $exeFile
	        echo $vid + " " + $build + " complete"
	        sleep 10
	    fi


	    # if [[ "$flag" == "1" ]]; then
	    #     udir=$(mktemp -d)
	    #     runScript $tcpExeFile $vid "--disable-quic" $timing "tcp" "Original"
	    #     chmod +x $tcpExeFile

	    #     sudo bash tcpdump_start.sh pcaps/${vid}_"${log_type}"_tcp_${timing}_Original      
	    #     mm-link $tracefile $tracefile $tcpExeFile
	    #     # $tcpExeFile

	    #     sudo bash tcpdump_stop.sh


	    #     cp ${udir}/chrome_debug.log logs/chrome_debug_${vid}_"${log_type}"_tcp_${timing}_Original.log
	    #     cp logs/chrome_debug_${vid}_"${log_type}"_tcp_${timing}_Original.log logs-collected/chrome_debug_${vid}_"${log_type}"_tcp_${timing}_Original.log
	        
	    #     # cp ${udir}/chrome_sslkeylog.log sslkeylogs/chrome_debug_${vid}_"${log_type}"_tcp_${timing}_Original.log

	    #     rm -rf $udir
	    #     rm $tcpExeFile
	    #     echo $vid + "tcp complete"

	    #     # sed '1d' $video_id_file > temp
	    #     # rm $video_id_file
	    #     # cp temp $video_id_file
	    #     # rm temp

	    #     sleep 30
	    # fi
	    
	    # if [[ "$flag" == "1" ]]; then
	    #     udir=$(mktemp -d)
	    #     runScript $tcpExeFile $vid "--disable-quic" $timing "tcp" "Modified"
	    #     chmod +x $tcpExeFile

	    #     sudo bash tcpdump_start.sh pcaps/${vid}_"${log_type}"_tcp_${timing}_Modified      
	    #     mm-link $tracefile $tracefile $tcpExeFile
	    #     # $tcpExeFile

	    #     sudo bash tcpdump_stop.sh


	    #     cp ${udir}/chrome_debug.log logs/chrome_debug_${vid}_"${log_type}"_tcp_${timing}_Modified.log
	    #     cp logs/chrome_debug_${vid}_"${log_type}"_tcp_${timing}_Modified.log logs-collected/chrome_debug_${vid}_"${log_type}"_tcp_${timing}_Modified.log
	        
	    #     cp ${udir}/chrome_sslkeylog.log sslkeylogs/chrome_debug_${vid}_"${log_type}"_tcp_${timing}_Modified.log

	    #     rm -rf $udir
	    #     rm $tcpExeFile
	    #     echo $vid + "tcp complete"

	    #     # sed '1d' $video_id_file > temp
	    #     # rm $video_id_file
	    #     # cp temp $video_id_file
	    #     # rm temp

	    #     sleep 30
	    # fi
	done

	#--log-net-log=/home/nsl5/Sapna/BTP/automate/net-export/$vid-$protocol-$timing.json
done
