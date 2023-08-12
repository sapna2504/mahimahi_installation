#!/usr/bin/env bash
set -x
set -e
#mkdir -p logs
#mkdir -p logs-collected
#mkdir -p pcaps
sudo sysctl -w net.ipv4.ip_forward=1

for i in {1..1}
do
	bash automate_alternate_chromium.sh dynamic-high.com- "video-groups/temp-1" "slot" $i

	# bash automate_alternate_chromium_alpha.sh dynamic-high.com- "video-groups/temp-1" "slot" $i "0.8" "200"
	# bash automate_alternate_chromium_alpha.sh dynamic-high.com- "video-groups/temp-1" "slot" $i "0.8" "400"
	# bash automate_alternate_chromium_alpha.sh dynamic-high.com- "video-groups/temp-1" "slot" $i "0.8" "600"
	# bash automate_alternate_chromium_alpha.sh dynamic-high.com- "video-groups/temp-1" "slot" $i "0.8" "800"
	# bash automate_alternate_chromium_alpha.sh dynamic-high.com- "video-groups/temp-1" "slot" $i "0.8" "1000"

	# bash automate_alternate_chromium_alpha.sh 64-256-64-inc.com- "video-groups/temp-1" "slot" $i "0.8" "200"
	# bash automate_alternate_chromium_alpha.sh 64-256-64-inc.com- "video-groups/temp-1" "slot" $i "0.8" "400"
	# bash automate_alternate_chromium_alpha.sh 64-256-64-inc.com- "video-groups/temp-1" "slot" $i "0.8" "600"
	# bash automate_alternate_chromium_alpha.sh 64-256-64-inc.com- "video-groups/temp-1" "slot" $i "0.8" "800"
	# bash automate_alternate_chromium_alpha.sh 64-256-64-inc.com- "video-groups/temp-1" "slot" $i "0.8" "1000"

	# bash automate_alternate_chromium_alpha.sh new-Pakistan_8.com- "video-groups/temp-1" "slot" $i "0.8" "200"
	# bash automate_alternate_chromium_alpha.sh new-Pakistan_8.com- "video-groups/temp-1" "slot" $i "0.8" "400"
	# bash automate_alternate_chromium_alpha.sh new-Pakistan_8.com- "video-groups/temp-1" "slot" $i "0.8" "600"
	# bash automate_alternate_chromium_alpha.sh new-Pakistan_8.com- "video-groups/temp-1" "slot" $i "0.8" "800"
	# bash automate_alternate_chromium_alpha.sh new-Pakistan_8.com- "video-groups/temp-1" "slot" $i "0.8" "1000"

	# bash automate_alternate_chromium_alpha.sh new-Pakistan_10.com- "video-groups/temp-1" "slot" $i "0.8" "200"
	# bash automate_alternate_chromium_alpha.sh new-Pakistan_10.com- "video-groups/temp-1" "slot" $i "0.8" "400"
	# bash automate_alternate_chromium_alpha.sh new-Pakistan_10.com- "video-groups/temp-1" "slot" $i "0.8" "600"
	# bash automate_alternate_chromium_alpha.sh new-Pakistan_10.com- "video-groups/temp-1" "slot" $i "0.8" "800"
	# bash automate_alternate_chromium_alpha.sh new-Pakistan_10.com- "video-groups/temp-1" "slot" $i "0.8" "1000"

	# bash automate_alternate_chromium_alpha.sh new-Pakistan_14.com- "video-groups/temp-1" "slot" $i "0.8" "200"
	# bash automate_alternate_chromium_alpha.sh new-Pakistan_14.com- "video-groups/temp-1" "slot" $i "0.8" "400"
	# bash automate_alternate_chromium_alpha.sh new-Pakistan_14.com- "video-groups/temp-1" "slot" $i "0.8" "600"
	# bash automate_alternate_chromium_alpha.sh new-Pakistan_14.com- "video-groups/temp-1" "slot" $i "0.8" "800"
	# bash automate_alternate_chromium_alpha.sh new-Pakistan_14.com- "video-groups/temp-1" "slot" $i "0.8" "1000"
done

