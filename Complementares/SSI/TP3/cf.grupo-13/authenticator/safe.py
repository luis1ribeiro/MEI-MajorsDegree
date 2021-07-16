#!/usr/bin/env python3

import json
import os
import keyring
import pyotp
import subprocess
from cryptography.fernet import Fernet

import gui
import user

DATA_PATH = "/etc/.secure_filesystem_keys"


def generateFernetKey():
    key = Fernet.generate_key()
    keyring.set_password("safe_filesystem", "nothingtosee", key)
    return key


def dataDecrypt():
    fernet_key = keyring.get_password("safe_filesystem", "nothingtosee")

    if fernet_key == None: 
        fernet_key = generateFernetKey()
    fernet = Fernet(fernet_key)

    user_keys = {}

    try:
        with open(DATA_PATH, 'rb') as f:
            data = f.read()  # Read the bytes of the encrypted file
    
        decrypted = fernet.decrypt(data)
        user_keys = json.loads(decrypted.decode("utf-8"))

    except FileNotFoundError:
        return user_keys

    f.close()
    return user_keys


def checkUser(uid):
    user_keys = dataDecrypt()

    if user_keys[uid] == None:
        return False

    totp = pyotp.TOTP(user_keys.get(uid))
    user_info = user.User(totp)

    gui.promptVerification(user_info)

    if user_info.authorized():
        return True

    return False