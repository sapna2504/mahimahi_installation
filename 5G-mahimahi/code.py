import numpy as np
import sys

def convert_to_mahimahi(input_file, duration_ms=180000):
    # Parse input data
    times = []
    throughputs = []
    
    # Read the input file
    try:
        with open(input_file, 'r') as f:
            for line in f:
                if line.strip():  # Skip empty lines
                    t, tp = map(float, line.split())
                    times.append(t)
                    throughputs.append(tp)
    except FileNotFoundError:
        print(f"Error: Input file '{input_file}' not found.")
        sys.exit(1)
    except ValueError as e:
        print(f"Error: Invalid data format in input file. Each line should contain two numbers.")
        sys.exit(1)
    
    # Convert throughput (Mbps) to packets per millisecond
    # Assuming 1500 byte packets: (Mbps * 1000000) / (1500 * 8 * 1000) = packets/ms
    packet_rates = [tp * 1000000 / (1500 * 8 * 1000) for tp in throughputs]
    
    # Generate timestamps for packets
    mahimahi_timestamps = []
    current_time = 0
    
    while current_time < duration_ms:
        # Find the applicable throughput based on current time (in seconds)
        current_second = current_time / 1000
        idx = 0
        for i, t in enumerate(times):
            if t > current_second:
                break
            idx = i
            
        # Calculate inter-packet delay in milliseconds
        if packet_rates[idx] > 0:
            inter_packet_delay = 1 / packet_rates[idx]
            
            # Add timestamp if it's within our duration
            if current_time < duration_ms:
                mahimahi_timestamps.append(int(current_time))
            
            # Increment time
            current_time += inter_packet_delay
        else:
            current_time += 1  # Move forward 1ms if throughput is 0

    # Sort timestamps (should already be sorted, but just to be safe)
    mahimahi_timestamps.sort()
    
    return mahimahi_timestamps

def main():
    
    input_file = "cooked/5g_trace_105_driving.txt"
    output_file = "mahimahi/5g_trace_105_driving.txt"
    
    # Convert to Mahimahi format
    timestamps = convert_to_mahimahi(input_file)
    
    # Save to output file
    try:
        with open(output_file, 'w') as f:
            for ts in timestamps:
                f.write(f"{ts}\n")
        print(f"Successfully converted trace to {output_file}")
    except IOError:
        print(f"Error: Unable to write to output file '{output_file}'")
        sys.exit(1)

if __name__ == "__main__":
    main()