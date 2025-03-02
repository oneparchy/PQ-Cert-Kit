#!/usr/bin/env python3
"""
Uses TSHARK to calculate TCP session durations from a packet capture. 
Calculation is from initial SYN to the packet preceding session teardown.
Intended use is with openssl s_client to calculate  TLS handshake duration
"""
import pyshark

# Populate FILEPATHS with the path(s) to your pcap file(s).
FILEPATHS = ["./capture.pcapng"]
# Change CLT to your client IP address.
CLT="192.168.146.134"

#=========================================================================

for FILE in FILEPATHS:
	cap = pyshark.FileCapture(FILE)
	times = []

	for p in cap:	
		try:
			if all([p.ip.src==CLT, p.ip.proto=='6', p.tcp.flags_fin=='1', p.tcp.flags_ack=='1']):
				sess_start_ms = float(p.tcp.time_relative) * 1000
				shake_end_ms_rel = float(p.tcp.time_delta) * 1000
				duration_ms = sess_start_ms - shake_end_ms_rel
				times.append(duration_ms)
			
		except AttributeError: continue;	#Ignore traffic that doesn't fit the profile

	cap.close()
	print("File: ",FILE)
	print("------------------------------")
	print("Number of streams: ", len(times))
	print("Average handshake duration: ", round(sum(times) / len(times) if times else 0,2), "ms")
