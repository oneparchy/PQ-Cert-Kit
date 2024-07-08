- Go to
 
Path-to-Dirctory/openssl/apps

- Run the server on the Laptop

sudo ./openssl s_server -accept 443 -tls1_3 -cert /Path-to-Dirctory/PQ-No-Cert-Validation/certs/falcon512/svrcert.pem -key /Path-to-Dirctory/PQ-No-Cert-Validation/certs/falcon512/svrkey.pem -CAfile /Path-to-Dirctory/PQ-No-Cert-Validation/certs/falcon512/inter/cacert.pem  -status_verbose

- Run the client on the RPI

./openssl s_client -connect IP_ADDRESS:443 -tls1_3 -CAfile /Path-to-Dirctory/PQ-No-Cert-Validation/certs/falcon512/root/cacert.pem -status

- To run with Kyber or another PQ KEM add -groups <kex> to the client side 
