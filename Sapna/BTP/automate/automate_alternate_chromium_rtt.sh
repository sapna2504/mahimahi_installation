#!/usr/bin/env bash

set -x

if [ $# -lt 4 ]
then
    echo use $0 "<tracefile> <video_id_file> <day_timing> <loop_required> <browser>"
    exit 1
fi

tracefile=$1; shift
video_id_file=$1; shift
day_timing=$1;shift
loop_required=$1;shift
# export FITZ_ALPHA_CHAR=$1;shift
# export FITZ_THRESHOLD=$1;shift

cat $video_id_file

quicExeFile=$(mktemp)
tcpExeFile=$(mktemp)

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
    ~/chromium/src/out/${browser}/chrome --user-data-dir=$udir "https://www.youtube.com/embed/$vid?rel=0&autoplay=1" --load-extension=~/Sapna/BTP/DASH/NetworkLogExtension $disQuic --no-proxy-server --autoplay-policy=no-user-gesture-required --no-first-run --enable-logging -log-level=0 --start-maximized --no-default-browser-check
	
    cpid=\$!
    kill -INT cpid
EOF
}

chmod +x $tcpExeFile $quicExeFile


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
        
        udir=$(mktemp -d)
        runScript $quicExeFile $vid " " $timing "quic" "static"
        chmod +x $quicExeFile

        sudo bash tcpdump_start.sh pcaps/${vid}_"${log_type}"_quic_${timing}

        #mm-link $tracefile $tracefile $quicExeFile
        $quicExeFile

        sudo bash tcpdump_stop.sh


        cp ${udir}/chrome_debug.log logs/chrome_debug_${vid}_"${log_type}"_quic_${timing}.log
        cp logs/chrome_debug_${vid}_"${log_type}"_quic_${timing}.log logs-collected/chrome_debug_${vid}_"${log_type}"_quic_${timing}.log
  
        rm -rf $udir
        rm $quicExeFile
        echo $vid + "quic original complete"
        sleep 10
    fi
done

