#!/usr/bin/env python3

import json
import os
from cryptography.fernet import Fernet
from validate_email import validate_email
import keyring

DATA_PATH = "/etc/.secure_filesystem_emails"

def generateFernetKey():
    key = Fernet.generate_key()
    keyring.set_password("safe_filesystem", "nothingtosee", key)
    return key


def dataDecrypt():
    fernet_key = keyring.get_password("safe_filesystem", "nothingtosee")
    if fernet_key == None: 
        fernet_key = generateFernetKey()
    fernet = Fernet(fernet_key)

    user_emails = {}

    try:
        with open(DATA_PATH, 'rb') as f:
            data = f.read()  # Read the bytes of the encrypted file
    
        decrypted = fernet.decrypt(data)
        user_emails = json.loads(decrypted.decode("utf-8"))

    except FileNotFoundError:
        return user_emails

    f.close()
    return user_emails


def getEmail(uid):
    return dataDecrypt().get(uid)