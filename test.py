#!/usr/bin/env python

import socket


TCP_IP = '127.0.0.1'
TCP_PORT = 8000
BUFFER_SIZE = 1024
MESSAGE = """PUT /characteristics HTTP/1.1

{
    "characteristics": [
        {
            "aid": 1,
            "iid": 8,
            "ev": true
        }
    ]
}
"""

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((TCP_IP, TCP_PORT))
s.send(MESSAGE)
while 1:
    data = s.recv(BUFFER_SIZE)
    if not data: break
    print(data)
s.close()
