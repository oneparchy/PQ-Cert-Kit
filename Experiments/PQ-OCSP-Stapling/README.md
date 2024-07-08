- Go to PQ-OCSP-Stapling/certs/falcon512

- Run the OCSP server (OCSP responder can be run locally with the server or on the cloud)

/Path-to-Dirctory/openssl/apps/openssl ocsp -index  /Path-to-Dirctory/PQ-OCSP-Stapling/certs/falcon512/inter/index.txt -port 8080 -rsigner ocspcert.pem -rkey ocspkey.pem -CA /Path-to-Dirctory/PQ-OCSP-Stapling/certs/falcon512/inter/cacert.pem


- Go to Path-to-Dirctory/openssl/apps

- Run the server on the laptop

sudo ./openssl s_server -accept 443 -tls1_3 -cert /Path-to-Dirctory/PQ-OCSP-Stapling/certs/falcon512/svrcert.pem -key /Path-to-Dirctory/PQ-OCSP-Stapling/certs/falcon512/svrkey.pem -CAfile /Path-to-Dirctory/PQ-OCSP-Stapling/certs/falcon512/inter/cacert.pem  -status_verbose


- Run the client on the RPI

- Go to Path-to-Dirctory/openssl/apps

./openssl s_client -connect IP_ADDRESS:443 -tls1_3 -CAfile /Path-to-Dirctory/PQ-OCSP-Stapling/certs/falcon512/root/cacert.pem -status 

add -groups <kex> for PQ KEM

- Example: ./openssl s_client -groups kyber512 -connect IP_ADDRESS:443 -tls1_3 -CAfile /Path-to-Dirctory/PQ-OCSP-Stapling/certs/falcon512/root/cacert.pem -status 
