#!/usr/bin/env python

import socket
import sys

if(len(sys.argv) != 3):
    print("expected 2 arguments")
    sys.exit(-1)

TCP_IP = sys.argv[1]
TCP_PORT = int(sys.argv[2])
BUFFER_SIZE = 1024
MESSAGE = """PUT /characteristics HTTP/1.1\r\nContent-Length: 121\r\n\r\n{
    "characteristics": [
        {
            "aid": 1,
            "iid": 8,
            "ev": true
        }
    ]
}
""".encode()

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((TCP_IP, TCP_PORT))
s.send(MESSAGE)
while 1:
    data = s.recv(BUFFER_SIZE)
    if not data: break
    print(data)
s.close()
