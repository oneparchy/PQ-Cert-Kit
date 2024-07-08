Go to pqcerts-main/certs/rsa

then run the OCSP server
/home/yacoub/Desktop/PQ-all-certificates/pqcerts-main/openssl/apps/openssl ocsp -index   /home/yacoub/Desktop/PQ-all-certificates/pqcerts-main/certs/rsa/inter/index.txt -port 8080 -rsigner ocspcert.pem -rkey ocspkey.pem -CA /home/yacoub/Desktop/PQ-all-certificates/pqcerts-main/certs/rsa/inter/cacert.pem


Then go to pqcerts-main/openssl/apps

Then run the server
sudo ./openssl s_server -accept 443 -tls1_3 -cert /home/yacoub/Desktop/PQ-all-certificates/pqcerts-main/certs/rsa/svrcert.pem -key /home/yacoub/Desktop/PQ-all-certificates/pqcerts-main/certs/rsa/svrkey.pem -CAfile /home/yacoub/Desktop/PQ-all-certificates/pqcerts-main/certs/rsa/inter/cacert.pem  -status_verbose


Then go run the client 
./openssl s_client -groups kyber512 -connect 127.0.2.1:443 -tls1_3 -CAfile /home/yacoub/Desktop/PQ-all-certificates/pqcerts-main/certs/rsa/root/cacert.pem -status 

add -groups <kex> for PQ key exchange
