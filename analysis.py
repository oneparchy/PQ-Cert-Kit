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
KEYLOG = None		#Path to keylog file

#==========================================================================================

KEYLOG = KEYLOG or os.getenv(SSLKEYLOGFILE)
opts = { "-o" : f"tls.keylog_file:{KEYLOG}" } if KEYLOG else None
		

FILES = [f for f in os.listdir(RESULTSDIR)]
for FILE in FILES:
	cap = pyshark.FileCapture(input_file=f"{RESULTSDIR}/{FILE}", custom_parameters=opts)
	times = {}
	dirty = set();

	for p in cap:	
		if not hasattr(p,"tcp"): continue;		#Ignore traffic that doesn't fit the profile
			
		# Mark streams with retransmissions
		if hasattr(p.tcp,"analysis") and (hasattr(p.tcp.analysis,"retransmission") or hasattr(p.tcp.analysis,"fast_retransmission") or hasattr(p.tcp.analysis,"duplicate_ack")):
			dirty.add(p.tcp.stream) if p.tcp.stream not in times.keys()	#It's fine if the retransmit happened after the part we're trying to calculate

		#Calculate handshake duration ONLY if TLS is being decrypted
		if KEYLOG:
			if hasattr(p, "tls") and hasattr(p.tls, "handshake_type"):
				if p.tls.handshake_type == "1" and p.ip.dst == SVR:
					start = float(p.sniff_time)
				elif p.tls.handshake_type == "20" and p.ip.src == SVR:
					end = float(p.sniff_time)
					times[p.tcp.stream] = (end - start) * 1000
			else: continue;
				
		else:
			if all([p.ip.dst==SVR, p.tcp.flags_fin=='1', p.tcp.flags_ack=='1']):
#				print(p.tcp.time_relative, p.tcp.time_delta)
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
	print("Average handshake duration (all streams): ", round(avg_all,2), "ms")
	print("Average handshake duration (clean streams): ", round(avg_clean,2), "ms")
	print("------------------------------")
