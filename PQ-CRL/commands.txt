----
RSA
----

Go to Desktop/PQ-CRL/openssl/apps

Then run 

./openssl genrsa -out /home/yacoub/Desktop/PQ-CRL/tls/private/cakey.pem 4096

./openssl req -new -x509 -days 3650 -config openssl.cnf -key /home/yacoub/Desktop/PQ-CRL/tls/private/cakey.pem -out /home/yacoub/Desktop/PQ-CRL/tls/certs/cacert.pem

./openssl x509 -noout -text -in /home/yacoub/Desktop/PQ-CRL/tls/certs/cacert.pem



Then you go to Desktop/PQ-CRL/tls/certs

Then run 

/home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl genrsa -out server.key.pem 4096

/home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl req -new -key server.key.pem -out server-1.csr -config /home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl.cnf

gedit ext_template.cnf

and paste this 

basicConstraints = CA:FALSE
nsCertType = client, email
nsComment = "OpenSSL Generated Client Certificate"
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
keyUsage = critical, nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, serverAuth


/home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl ca -config /home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl.cnf -notext -batch -in server-1.csr -out server-1.crt -extfile ext_template.cnf


------
ECDSA
------

Go to Desktop/PQ-CRL/openssl/apps

Then run 

./openssl ecparam -name prime256v1 -genkey -out /home/yacoub/Desktop/PQ-CRL/tls/private/ecdsacakey.pem

./openssl req -x509 -days 3650 -config openssl.cnf -key /home/yacoub/Desktop/PQ-CRL/tls/private/ecdsacakey.pem -out /home/yacoub/Desktop/PQ-CRL/tls/certs/ecdsacacert.pem -sha256 -batch


./openssl x509 -noout -text -in /home/yacoub/Desktop/PQ-CRL/tls/certs/ecdsacacert.pem


Then you go to Desktop/PQ-CRL/tls/certs

Then run 

/home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl ecparam -name prime256v1 -genkey -out ecdsasvrkey.pem

/home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl req -new -key ecdsasvrkey.pem -out ecdsaserver-1.csr -config /home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl.cnf -sha256 -batch

/home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl ca -config /home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl.cnf -notext -batch -in ecdsaserver-1.csr -out ecdsaserver-1.crt -extfile ext_template.cnf


------
EDDSA
------

Go to Desktop/PQ-CRL/openssl/apps

Then run 

./openssl genpkey -algorithm ED25519 -out /home/yacoub/Desktop/PQ-CRL/tls/private/eddsacakey.pem

./openssl req -x509 -config openssl.cnf -key /home/yacoub/Desktop/PQ-CRL/tls/private/eddsacakey.pem  -sha256 -out /home/yacoub/Desktop/PQ-CRL/tls/certs/eddsacacert.pem -days 3650 -batch

./openssl x509 -noout -text -in /home/yacoub/Desktop/PQ-CRL/tls/certs/eddsacacert.pem


Then you go to Desktop/PQ-CRL/tls/certs

Then run 

/home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl genpkey -algorithm ED25519 -out eddsasvrkey.pem

/home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl req -new -key eddsasvrkey.pem -out eddsaserver-1.csr -config /home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl.cnf -sha256 -batch

/home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl ca -config /home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl.cnf -notext -batch -in eddsaserver-1.csr -out eddsaserver-1.crt -extfile ext_template.cnf


---------
Falcon512 
---------

Go to Desktop/PQ-CRL/openssl/apps

Then run 

./openssl req -x509 -config openssl.cnf -newkey falcon512 -sha256  -out /home/yacoub/Desktop/PQ-CRL/tls/certs/falcon512cacert.pem  -keyout /home/yacoub/Desktop/PQ-CRL/tls/private/falcon512cakey.pem  -days 3650 -batch

./openssl x509 -noout -text -in /home/yacoub/Desktop/PQ-CRL/tls/certs/falcon512cacert.pem

Then you go to Desktop/PQ-CRL/tls/certs

Then run 

/home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl req -new -config /home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl.cnf -newkey falcon512 -sha256  -out falcon512svrcert.csr  -keyout falcon512svrkey.pem -batch


/home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl ca -config /home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl.cnf -notext -batch -in falcon512svrcert.csr -out falcon512server-1.crt -extfile ext_template.cnf



---------
Falcon1024 
---------

Go to Desktop/PQ-CRL/openssl/apps

Then run 

./openssl req -x509 -config openssl.cnf -newkey falcon1024 -sha256 -out /home/yacoub/Desktop/PQ-CRL/tls/certs/falcon1024cacert.pem  -keyout /home/yacoub/Desktop/PQ-CRL/tls/private/falcon1024cakey.pem  -days 3650 -batch

./openssl x509 -noout -text -in /home/yacoub/Desktop/PQ-CRL/tls/certs/falcon1024cacert.pem


Then you go to Desktop/PQ-CRL/tls/certs

Then run 


/home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl req -new -config /home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl.cnf -newkey falcon1024 -sha256  -out falcon1024svrcert.csr  -keyout falcon1024svrkey.pem -batch

/home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl ca -config /home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl.cnf -notext -batch -in falcon1024svrcert.csr -out falcon1024server-1.crt -extfile ext_template.cnf



---------
Dilithium2 
---------

Go to Desktop/PQ-CRL/openssl/apps

Then run 

./openssl req -x509 -config openssl.cnf -newkey dilithium2 -sha256 -out /home/yacoub/Desktop/PQ-CRL/tls/certs/dil2cacert.pem  -keyout /home/yacoub/Desktop/PQ-CRL/tls/private/dil2cakey.pem  -days 3650 -batch

./openssl x509 -noout -text -in /home/yacoub/Desktop/PQ-CRL/tls/certs/dil2cacert.pem


Then you go to Desktop/PQ-CRL/tls/certs

Then run 


/home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl req -new -config /home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl.cnf -newkey dilithium2 -sha256  -out dil2svrcert.csr  -keyout dil2svrkey.pem -batch

/home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl ca -config /home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl.cnf -notext -batch -in dil2svrcert.csr -out dil2server-1.crt -extfile ext_template.cnf




---------
Dilithium3 
---------

Go to Desktop/PQ-CRL/openssl/apps

Then run 

./openssl req -x509 -config openssl.cnf -newkey dilithium3 -sha256 -out /home/yacoub/Desktop/PQ-CRL/tls/certs/dil3cacert.pem  -keyout /home/yacoub/Desktop/PQ-CRL/tls/private/dil3cakey.pem  -days 3650 -batch

./openssl x509 -noout -text -in /home/yacoub/Desktop/PQ-CRL/tls/certs/dil3cacert.pem


Then you go to Desktop/PQ-CRL/tls/certs

Then run 


/home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl req -new -config /home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl.cnf -newkey dilithium3 -sha256  -out dil3svrcert.csr  -keyout dil3svrkey.pem -batch

/home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl ca -config /home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl.cnf -notext -batch -in dil3svrcert.csr -out dil3server-1.crt -extfile ext_template.cnf




---------
Dilithium5 
---------

Go to Desktop/PQ-CRL/openssl/apps

Then run 

./openssl req -x509 -config openssl.cnf -newkey dilithium5 -sha256 -out /home/yacoub/Desktop/PQ-CRL/tls/certs/dil5cacert.pem  -keyout /home/yacoub/Desktop/PQ-CRL/tls/private/dil5cakey.pem  -days 3650 -batch

./openssl x509 -noout -text -in /home/yacoub/Desktop/PQ-CRL/tls/certs/dil5cacert.pem


Then you go to Desktop/PQ-CRL/tls/certs

Then run 


/home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl req -new -config /home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl.cnf -newkey dilithium5 -sha256  -out dil5svrcert.csr  -keyout dil5svrkey.pem -batch

/home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl ca -config /home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl.cnf -notext -batch -in dil5svrcert.csr -out dil5server-1.crt -extfile ext_template.cnf




-----------------------
sphincsharaka128fsimple
-----------------------

Go to Desktop/PQ-CRL/openssl/apps

Then run 

./openssl req -x509 -config openssl.cnf -newkey sphincsharaka128fsimple -sha256 -out /home/yacoub/Desktop/PQ-CRL/tls/certs/sphincsharakacacert.pem  -keyout /home/yacoub/Desktop/PQ-CRL/tls/private/sphincsharakacakey.pem  -days 3650 -batch

./openssl x509 -noout -text -in /home/yacoub/Desktop/PQ-CRL/tls/certs/sphincsharakacacert.pem


Then you go to Desktop/PQ-CRL/tls/certs

Then run 


/home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl req -new -config /home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl.cnf -newkey sphincsharaka128fsimple -sha256  -out sphincsharakasvrcert.csr  -keyout sphincsharakasvrkey.pem -batch

/home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl ca -config /home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl.cnf -notext -batch -in sphincsharakasvrcert.csr -out sphincsharakaserver-1.crt -extfile ext_template.cnf






-----------------------
sphincssha256128ssimple
-----------------------

Go to Desktop/PQ-CRL/openssl/apps

Then run 

./openssl req -x509 -config openssl.cnf -newkey sphincssha256128ssimple -sha256 -out /home/yacoub/Desktop/PQ-CRL/tls/certs/sphincshacacert.pem  -keyout /home/yacoub/Desktop/PQ-CRL/tls/private/sphincshacakey.pem  -days 3650 -batch

./openssl x509 -noout -text -in /home/yacoub/Desktop/PQ-CRL/tls/certs/sphincshacacert.pem


Then you go to Desktop/PQ-CRL/tls/certs

Then run 


/home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl req -new -config /home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl.cnf -newkey sphincssha256128ssimple -sha256  -out sphincshasvrcert.csr  -keyout sphincshasvrkey.pem -batch

/home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl ca -config /home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl.cnf -notext -batch -in sphincshasvrcert.csr -out sphincshaserver-1.crt -extfile ext_template.cnf




-----------------------
sphincsshake256128fsimple
-----------------------

Go to Desktop/PQ-CRL/openssl/apps

Then run 

./openssl req -x509 -config openssl.cnf -newkey sphincsshake256128fsimple -sha256 -out /home/yacoub/Desktop/PQ-CRL/tls/certs/sphincshakecacert.pem  -keyout /home/yacoub/Desktop/PQ-CRL/tls/private/sphincshakecakey.pem  -days 3650 -batch

./openssl x509 -noout -text -in /home/yacoub/Desktop/PQ-CRL/tls/certs/sphincshakecacert.pem


Then you go to Desktop/PQ-CRL/tls/certs

Then run 


/home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl req -new -config /home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl.cnf -newkey sphincsshake256128fsimple -sha256  -out sphincshakesvrcert.csr  -keyout sphincshakesvrkey.pem -batch

/home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl ca -config /home/yacoub/Desktop/PQ-CRL/openssl/apps/openssl.cnf -notext -batch -in sphincshakesvrcert.csr -out sphincshakeserver-1.crt -extfile ext_template.cnf












