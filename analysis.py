#!/usr/bin/env python3
"""
Uses PYSHARK to calculate TCP session durations from a packet capture. 
Calculation is from initial SYN to the packet preceding session teardown.
Intended use is with openssl s_client to calculate TLS handshake duration
"""
import pyshark
import os

#-------------------------------------- VARS ----------------------------------------------
# Populate RESULTSDIR with the path to the folder containing your pcap file(s).
# These files should only contain complete TCP sessions between the client & server.
RESULTSDIR = "./results"

# Change SVR to your server IP address.
SVR="x.x.x.x"

# TLS inspection
KEYLOG = None		# Path to keylog file

#==========================================================================================

KEYLOG = KEYLOG or os.getenv("SSLKEYLOGFILE")
opts = { "-o" : f"tls.keylog_file:{KEYLOG}" } if KEYLOG else None


FILES = [f for f in os.listdir(RESULTSDIR)]
for FILE in FILES:
	cap = pyshark.FileCapture(input_file=f"{RESULTSDIR}/{FILE}", custom_parameters=opts)
	times = {}
	dirty = set();

	for p in cap:	
		if not hasattr(p,"tcp"): continue;		# Ignore non-tcp traffic

		# Mark streams with retransmissions for exclusion
		if hasattr(p.tcp,"analysis") and (hasattr(p.tcp.analysis,"retransmission") or hasattr(p.tcp.analysis,"fast_retransmission") or hasattr(p.tcp.analysis,"duplicate_ack")):
			if p.tcp.stream not in times.keys():            # It's fine if the retransmit happened after the part of the connection that we're analyzing
				dirty.add(p.tcp.stream)

		# Base calculations on time information from the FINACK from the client to the server
		# OpenSSL will setup the connection and close it immediately if no terminal attached and no input provided.
		# Time of packet just prior to FINACK - Time of session initiation = Connection setup time
		if all([p.ip.dst==SVR, p.tcp.flags_fin=='1', p.tcp.flags_ack=='1']):
#			print(p.tcp.time_relative, p.tcp.time_delta)
			sess_start_ms = float(p.tcp.time_relative) * 1000
			shake_end_ms_rel = float(p.tcp.time_delta) * 1000
			duration_ms = sess_start_ms - shake_end_ms_rel
			times[p.tcp.stream] = duration_ms

	cap.close()
	print("------------------------------")
	print("File: ",FILE)
	print("Number of streams: ", len(times))
	print(f"{len(dirty)} streams identified with retransmissions")
	tot_all = sum(times.values())
	avg_all = tot_all / len(times)
	tot_clean = sum([t for s,t in times.items() if s not in dirty])
	avg_clean = tot_clean / (len(times) - len(dirty))
	print("Avg connection setup time (all streams): ", round(avg_all,2), "ms")
	print("Avg connection setup time (clean streams): ", round(avg_clean,2), "ms")
	print("------------------------------")
