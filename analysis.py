#!/usr/bin/env python3
"""
Uses PYSHARK to calculate TCP session durations from a packet capture. 
Calculation is from initial SYN to the packet preceding session teardown.
Intended use is with openssl s_client to calculate TLS handshake duration
"""
import pyshark
import os

# Populate RESULTSDIR with the path to the folder containing your pcap file(s).
# These files should only contain complete TCP sessions between the client & server.
RESULTSDIR = "./results"

# Change SVR to your server IP address.
SVR="x.x.x.x"

#=========================================================================

FILES = [f for f in os.listdir(RESULTSDIR)]
for FILE in FILES:
	cap = pyshark.FileCapture(RESULTSDIR + "/" + FILE)
	times = []

	for p in cap:	
		try:
			if all([p.ip.dst==SVR, p.ip.proto=='6', p.tcp.flags_fin=='1', p.tcp.flags_ack=='1']):
#				print(p.tcp.time_relative, p.tcp.time_delta)
				sess_start_ms = float(p.tcp.time_relative) * 1000
				shake_end_ms_rel = float(p.tcp.time_delta) * 1000
				duration_ms = sess_start_ms - shake_end_ms_rel
				times.append(duration_ms)
			
		except AttributeError: continue;	#Ignore traffic that doesn't fit the profile

	cap.close()
	print("------------------------------")
	print("File: ",FILE)
	print("Number of streams: ", len(times))
	print("Average handshake duration: ", round(sum(times) / len(times) if times else 0,2), "ms")
	print("------------------------------")
