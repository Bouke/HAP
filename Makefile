build:
	swift build -Xlinker -lssl -Xlinker -lcrypto -Xcc -I/usr/local/Cellar/openssl/1.0.2h_1/include
