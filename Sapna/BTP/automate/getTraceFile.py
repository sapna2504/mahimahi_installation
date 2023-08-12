from datetime import datetime
import sys

min_bw = int(sys.argv[1])  # Kbps or kilo bits per sec
max_bw = int(sys.argv[2])
jump_bw = 240
flow = 'inc'

filename = str(min_bw) + "-" + str(max_bw) + "-" + str(jump_bw) + "-" + flow

# filename = str(datetime.now())
# filename = filename.split(".")[0]
# filename = filename.replace(":", "")
# filename = filename.replace(" ", "-")
print(filename)

packet_size = 1500*8 # bits
bandwidths = []

if (flow == "inc"):
	for x in range(min_bw, max_bw+1, jump_bw):
		bandwidths += [x]
	for x in range(max_bw - jump_bw, min_bw + jump_bw, -1*jump_bw):
		bandwidths += [x]

elif (flow == "dec"):
	for x in range(max_bw, min_bw, -1*jump_bw):
		bandwidths += [x]
	for x in range(min_bw, max_bw, jump_bw):
		bandwidths += [x]

print(bandwidths)

time_stamps = []
time = 0
limit = 240000 # in ms

cur_time = time
for bw in bandwidths:
	time_interval = packet_size/bw;
	while cur_time < time+limit:
		time_stamps += [str(int(cur_time)) + "\n"]
		cur_time += time_interval

	time = cur_time

with open(filename + ".com-", "w") as trace:
	trace.writelines(time_stamps)
