----
Follow the setps below to generate the certificates and use opensslCRL.cnf
OR 
Use CRL file to run CRL experiments
----




----
RSA
----

- Go to /Path-to-Dirctory/openssl/apps

- run 

./openssl genrsa -out /Path-to-Dirctory/PQ-CRL/CRL/private/cakey.pem 4096

./openssl req -new -x509 -days 3650 -config openssl.cnf -key /Path-to-Dirctory/PQ-CRL/CRL/private/cakey.pem -out /Path-to-Dirctory/PQ-CRL/CRL/certs/cacert.pem

./openssl x509 -noout -text -in /Path-to-Dirctory/PQ-CRL/CRL/certs/cacert.pem

- Go to Path-to-Dirctory/PQ-CRL/CRL/certs

- run 

/Path-to-Dirctory/openssl/apps/openssl genrsa -out server.key.pem 4096

/Path-to-Dirctory/openssl/apps/openssl req -new -key server.key.pem -out server-1.csr -config /Path-to-Dirctory/openssl/apps/openssl.cnf

gedit ext_template.cnf

- add this to the file 

basicConstraints = CA:FALSE
nsCertType = client, email
nsComment = "OpenSSL Generated Client Certificate"
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
keyUsage = critical, nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, serverAuth


/Path-to-Dirctory/openssl/apps/openssl ca -config /Path-to-Dirctory/openssl/apps/openssl.cnf -notext -batch -in server-1.csr -out server-1.crt -extfile ext_template.cnf


------
ECDSA
------

- Go to Path-to-Dirctory/openssl/apps

- run 

./openssl ecparam -name prime256v1 -genkey -out /Path-to-Dirctory/PQ-CRL/CRL/private/ecdsacakey.pem

./openssl req -x509 -days 3650 -config openssl.cnf -key /Path-to-Dirctory/PQ-CRL/CRL/private/ecdsacakey.pem -out /Path-to-Dirctory/PQ-CRL/CRL/certs/ecdsacacert.pem -sha256 -batch


./openssl x509 -noout -text -in /Path-to-Dirctory/PQ-CRL/CRL/certs/ecdsacacert.pem


- Go to Path-to-Dirctory/PQ-CRL/CRL/certs

- run 

/Path-to-Dirctory/openssl/apps/openssl ecparam -name prime256v1 -genkey -out ecdsasvrkey.pem

/Path-to-Dirctory/openssl/apps/openssl req -new -key ecdsasvrkey.pem -out ecdsaserver-1.csr -config /Path-to-Dirctory/openssl/apps/openssl.cnf -sha256 -batch

/Path-to-Dirctory/openssl/apps/openssl ca -config /Path-to-Dirctory/openssl/apps/openssl.cnf -notext -batch -in ecdsaserver-1.csr -out ecdsaserver-1.crt -extfile ext_template.cnf


------
EDDSA
------

- Go to Path-to-Dirctory/openssl/apps

- run 

./openssl genpkey -algorithm ED25519 -out /Path-to-Dirctory/PQ-CRL/CRL/private/eddsacakey.pem

./openssl req -x509 -config openssl.cnf -key /Path-to-Dirctory/PQ-CRL/CRL/private/eddsacakey.pem  -sha256 -out /Path-to-Dirctory/PQ-CRL/CRL/certs/eddsacacert.pem -days 3650 -batch

./openssl x509 -noout -text -in /Path-to-Dirctory/PQ-CRL/CRL/certs/eddsacacert.pem


- Go to Path-to-Dirctory/PQ-CRL/CRL/certs

- run 

/Path-to-Dirctory/openssl/apps/openssl genpkey -algorithm ED25519 -out eddsasvrkey.pem

/Path-to-Dirctory/openssl/apps/openssl req -new -key eddsasvrkey.pem -out eddsaserver-1.csr -config /Path-to-Dirctory/openssl/apps/openssl.cnf -sha256 -batch

/Path-to-Dirctory/openssl/apps/openssl ca -config /Path-to-Dirctory/openssl/apps/openssl.cnf -notext -batch -in eddsaserver-1.csr -out eddsaserver-1.crt -extfile ext_template.cnf


---------
Falcon512 
---------

- Go to Path-to-Dirctory/openssl/apps

- run 

./openssl req -x509 -config openssl.cnf -newkey falcon512 -sha256  -out /Path-to-Dirctory/PQ-CRL/CRL/certs/falcon512cacert.pem  -keyout /Path-to-Dirctory/PQ-CRL/CRL/private/falcon512cakey.pem  -days 3650 -batch

./openssl x509 -noout -text -in /Path-to-Dirctory/PQ-CRL/CRL/certs/falcon512cacert.pem


- Go to Path-to-Dirctory/PQ-CRL/CRL/certs

- run 

/Path-to-Dirctory/openssl/apps/openssl req -new -config /Path-to-Dirctory/openssl/apps/openssl.cnf -newkey falcon512 -sha256  -out falcon512svrcert.csr  -keyout falcon512svrkey.pem -batch

/Path-to-Dirctory/openssl/apps/openssl ca -config /Path-to-Dirctory/openssl/apps/openssl.cnf -notext -batch -in falcon512svrcert.csr -out falcon512server-1.crt -extfile ext_template.cnf



---------
Falcon1024 
---------

- Go to Path-to-Dirctory/openssl/apps

- run 

./openssl req -x509 -config openssl.cnf -newkey falcon1024 -sha256 -out /Path-to-Dirctory/PQ-CRL/CRL/certs/falcon1024cacert.pem  -keyout /Path-to-Dirctory/PQ-CRL/CRL/private/falcon1024cakey.pem  -days 3650 -batch

./openssl x509 -noout -text -in /Path-to-Dirctory/PQ-CRL/CRL/certs/falcon1024cacert.pem


- Go to Path-to-Dirctory/PQ-CRL/CRL/certs

- run 

/Path-to-Dirctory/openssl/apps/openssl req -new -config /Path-to-Dirctory/openssl/apps/openssl.cnf -newkey falcon1024 -sha256  -out falcon1024svrcert.csr  -keyout falcon1024svrkey.pem -batch

/Path-to-Dirctory/openssl/apps/openssl ca -config /Path-to-Dirctory/openssl/apps/openssl.cnf -notext -batch -in falcon1024svrcert.csr -out falcon1024server-1.crt -extfile ext_template.cnf



---------
Dilithium2 
---------

- Go to Path-to-Dirctory/openssl/apps

- run 

./openssl req -x509 -config openssl.cnf -newkey dilithium2 -sha256 -out /Path-to-Dirctory/PQ-CRL/CRL/certs/dil2cacert.pem  -keyout /Path-to-Dirctory/PQ-CRL/CRL/private/dil2cakey.pem  -days 3650 -batch

./openssl x509 -noout -text -in /Path-to-Dirctory/PQ-CRL/CRL/certs/dil2cacert.pem


- Go to Path-to-Dirctory/PQ-CRL/CRL/certs

- run 

/Path-to-Dirctory/openssl/apps/openssl req -new -config /Path-to-Dirctory/openssl/apps/openssl.cnf -newkey dilithium2 -sha256  -out dil2svrcert.csr  -keyout dil2svrkey.pem -batch

/Path-to-Dirctory/openssl/apps/openssl ca -config /Path-to-Dirctory/openssl/apps/openssl.cnf -notext -batch -in dil2svrcert.csr -out dil2server-1.crt -extfile ext_template.cnf




---------
Dilithium3 
---------

- Go to Path-to-Dirctory/openssl/apps

- run 

./openssl req -x509 -config openssl.cnf -newkey dilithium3 -sha256 -out /Path-to-Dirctory/PQ-CRL/CRL/certs/dil3cacert.pem  -keyout /Path-to-Dirctory/PQ-CRL/CRL/private/dil3cakey.pem  -days 3650 -batch

./openssl x509 -noout -text -in /Path-to-Dirctory/PQ-CRL/CRL/certs/dil3cacert.pem


- Go to Path-to-Dirctory/PQ-CRL/CRL/certs

- run 

/Path-to-Dirctory/openssl/apps/openssl req -new -config /Path-to-Dirctory/openssl/apps/openssl.cnf -newkey dilithium3 -sha256  -out dil3svrcert.csr  -keyout dil3svrkey.pem -batch

/Path-to-Dirctory/openssl/apps/openssl ca -config /Path-to-Dirctory/openssl/apps/openssl.cnf -notext -batch -in dil3svrcert.csr -out dil3server-1.crt -extfile ext_template.cnf




---------
Dilithium5 
---------

- Go to Path-to-Dirctory/openssl/apps

- run 

./openssl req -x509 -config openssl.cnf -newkey dilithium5 -sha256 -out /Path-to-Dirctory/PQ-CRL/CRL/certs/dil5cacert.pem  -keyout /Path-to-Dirctory/PQ-CRL/CRL/private/dil5cakey.pem  -days 3650 -batch

./openssl x509 -noout -text -in /Path-to-Dirctory/PQ-CRL/CRL/certs/dil5cacert.pem


- Go to Path-to-Dirctory/PQ-CRL/CRL/certs

- run 

/Path-to-Dirctory/openssl/apps/openssl req -new -config /Path-to-Dirctory/openssl/apps/openssl.cnf -newkey dilithium5 -sha256  -out dil5svrcert.csr  -keyout dil5svrkey.pem -batch

/Path-to-Dirctory/openssl/apps/openssl ca -config /Path-to-Dirctory/openssl/apps/openssl.cnf -notext -batch -in dil5svrcert.csr -out dil5server-1.crt -extfile ext_template.cnf




-----------------------
sphincsharaka128fsimple
-----------------------

- Go to Path-to-Dirctory/openssl/apps

- run 

./openssl req -x509 -config openssl.cnf -newkey sphincsharaka128fsimple -sha256 -out /Path-to-Dirctory/PQ-CRL/CRL/certs/sphincsharakacacert.pem  -keyout /Path-to-Dirctory/PQ-CRL/CRL/private/sphincsharakacakey.pem  -days 3650 -batch

./openssl x509 -noout -text -in /Path-to-Dirctory/PQ-CRL/CRL/certs/sphincsharakacacert.pem


- Go to Path-to-Dirctory/PQ-CRL/CRL/certs

- run 

/Path-to-Dirctory/openssl/apps/openssl req -new -config /Path-to-Dirctory/openssl/apps/openssl.cnf -newkey sphincsharaka128fsimple -sha256  -out sphincsharakasvrcert.csr  -keyout sphincsharakasvrkey.pem -batch

/Path-to-Dirctory/openssl/apps/openssl ca -config /Path-to-Dirctory/openssl/apps/openssl.cnf -notext -batch -in sphincsharakasvrcert.csr -out sphincsharakaserver-1.crt -extfile ext_template.cnf






-----------------------
sphincssha256128ssimple
-----------------------

- Go to Path-to-Dirctory/openssl/apps

- run 

./openssl req -x509 -config openssl.cnf -newkey sphincssha256128ssimple -sha256 -out /Path-to-Dirctory/PQ-CRL/CRL/certs/sphincshacacert.pem  -keyout /Path-to-Dirctory/PQ-CRL/CRL/private/sphincshacakey.pem  -days 3650 -batch

./openssl x509 -noout -text -in /Path-to-Dirctory/PQ-CRL/CRL/certs/sphincshacacert.pem


- Go to Path-to-Dirctory/PQ-CRL/CRL/certs

- run 

/Path-to-Dirctory/openssl/apps/openssl req -new -config /Path-to-Dirctory/openssl/apps/openssl.cnf -newkey sphincssha256128ssimple -sha256  -out sphincshasvrcert.csr  -keyout sphincshasvrkey.pem -batch

/Path-to-Dirctory/openssl/apps/openssl ca -config /Path-to-Dirctory/openssl/apps/openssl.cnf -notext -batch -in sphincshasvrcert.csr -out sphincshaserver-1.crt -extfile ext_template.cnf




-----------------------
sphincsshake256128fsimple
-----------------------

- Go to Path-to-Dirctory/openssl/apps

- run 

./openssl req -x509 -config openssl.cnf -newkey sphincsshake256128fsimple -sha256 -out /Path-to-Dirctory/PQ-CRL/CRL/certs/sphincshakecacert.pem  -keyout /Path-to-Dirctory/PQ-CRL/CRL/private/sphincshakecakey.pem  -days 3650 -batch

./openssl x509 -noout -text -in /Path-to-Dirctory/PQ-CRL/CRL/certs/sphincshakecacert.pem


- Go to Path-to-Dirctory/PQ-CRL/CRL/certs

- run 

/Path-to-Dirctory/openssl/apps/openssl req -new -config /Path-to-Dirctory/openssl/apps/openssl.cnf -newkey sphincsshake256128fsimple -sha256  -out sphincshakesvrcert.csr  -keyout sphincshakesvrkey.pem -batch

/Path-to-Dirctory/openssl/apps/openssl ca -config /Path-to-Dirctory/openssl/apps/openssl.cnf -notext -batch -in sphincshakesvrcert.csr -out sphincshakeserver-1.crt -extfile ext_template.cnf












