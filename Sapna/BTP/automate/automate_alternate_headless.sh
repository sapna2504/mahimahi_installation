#!/usr/bin/env bash

set -x
set -e
if [ $# -lt 4 ]
then
    echo use $0 "<tracefile> <video_id_file> <day_timing> <loop_required> <browser>"
    exit 1
fi

tracefile=$1; shift
video_id_file=$1; shift
day_timing=$1;shift
loop_required=$1;shift

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
    headless=$1;shift

    cat > $exeFile << EOF
    #!/usr/bin/env bash

    set -x

    export CHROME_LOG_FILE=$udir/chrome_debug.log
    # export SSLKEYLOGFILE=$udir/chrome_sslkeylog.log
    # ~/Desktop/NK/code/chromium/src/out/${browser}/chrome --user-data-dir=$udir "https://www.youtube.com/embed/$vid?rel=0&autoplay=1" --load-extension=~/Sapna/BTP/DASH/adblock,~/Sapna/BTP/DASH/NetworkLogExtension $disQuic --no-proxy-server --autoplay-policy=no-user-gesture-required --no-first-run --enable-logging -log-level=0 --start-maximized --no-default-browser-check --log-net-log=netlogs/chrome_debug_${vid}_"${log_type}"_"${protocol}"_${timing}_${browser}.json --net-log-capture-mode=Everything
    /home/vagrant/chromium/src/out/Default/chrome --user-data-dir=$udir "https://www.youtube.com/embed/$vid?rel=0&autoplay=1" $disQuic --load-extension=/home/vagrant/Sapna/BTP/DASH/NetworkLogExtension --no-proxy-server --autoplay-policy=no-user-gesture-required --no-first-run --enable-logging -log-level=0 --start-maximized --no-default-browser-check $headless || echo "CHROME ERROR"

    cpid=\$!
    kill -INT cpid  || echo "CHROME ERROR"
EOF
}

chmod +x $tcpExeFile $quicExeFile


log_type="$(cut -d'.' -f1 <<<"$(cut -d'/' -f2 <<<"$tracefile")")"

for vid in `cat $video_id_file`
do
    currenttime=$(date +%H:%M)
    flag=1
    timing=${day_timing}-${loop_required}
    #timing=${day_timing}


    if [[ "$flag" == "1" ]]; then
        echo $vid
        
        udir=$(mktemp -d)
        runScript $quicExeFile $vid " " $timing "quic" "Original" " "
        chmod +x $quicExeFile

        sudo bash tcpdump_start.sh pcaps/${vid}_"${log_type}"_headless_${timing}
        
        mm-link $tracefile $tracefile $quicExeFile
        # $quicExeFile

        sudo bash tcpdump_stop.sh


        cp ${udir}/chrome_debug.log logs/chrome_debug_${vid}_"${log_type}"_headless_${timing}.log
        cp logs/chrome_debug_${vid}_"${log_type}"_headless_${timing}.log logs-collected/chrome_debug_${vid}_"${log_type}"_headless_${timing}.log

        # cp ${udir}/chrome_sslkeylog.log sslkeylogs/chrome_debug_${vid}_"${log_type}"_quic_${timing}_Original.log
  
        rm -rf $udir
        rm $quicExeFile
        echo $vid + "headless complete"
        sleep 10
    fi

    if [[ "$flag" == "1" ]]; then
        echo $vid
        
        udir=$(mktemp -d)
        runScript $quicExeFile $vid " --disable-quic " $timing "quic" "Original" " "
        chmod +x $quicExeFile

        sudo bash tcpdump_start.sh pcaps/${vid}_"${log_type}"_head_${timing}
        
        mm-link $tracefile $tracefile $quicExeFile
        # $quicExeFile

        sudo bash tcpdump_stop.sh


        cp ${udir}/chrome_debug.log logs/chrome_debug_${vid}_"${log_type}"_head_${timing}.log
        cp logs/chrome_debug_${vid}_"${log_type}"_head_${timing}.log logs-collected/chrome_debug_${vid}_"${log_type}"_head_${timing}.log

        # cp ${udir}/chrome_sslkeylog.log sslkeylogs/chrome_debug_${vid}_"${log_type}"_quic_${timing}_Modified.log
  
        rm -rf $udir
        rm $quicExeFile
        echo $vid + "head complete"
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
