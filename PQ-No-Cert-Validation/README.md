Go to
 
pqcerts-main/openssl/apps


Run the server 
sudo ./openssl s_server -accept 443 -tls1_3 -cert /home/yacoub/Desktop/PQ-certificates-no-OCSP/pqcerts-main/certs/rsa/svrcert.pem -key /home/yacoub/Desktop/PQ-certificates-no-OCSP/pqcerts-main/certs/rsa/svrkey.pem -CAfile /home/yacoub/Desktop/PQ-certificates-no-OCSP/pqcerts-main/certs/rsa/inter/cacert.pem  -status_verbose

Then run the client 

./openssl s_client -connect 127.0.0.1:443 -tls1_3 -CAfile /home/yacoub/Desktop/PQ-certificates-no-OCSP/pqcerts-main/certs/rsa/root/cacert.pem -status

to run with Kyber or another key exchange add -groups <kex> to the client side 
