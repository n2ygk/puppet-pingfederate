#!/usr/bin/env python
import json
import sys
from OpenSSL import crypto  # $ pip install pyopenssl

with open(sys.argv[1], 'rb') as der_file:
  x509 = crypto.load_certificate(crypto.FILETYPE_PEM, der_file.read())

print(x509.get_subject().get_components())
