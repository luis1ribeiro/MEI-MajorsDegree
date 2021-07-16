import pyotp
import keyring
import json
import qrcode
import os
import pwd
import sys
import subprocess
from cryptography.fernet import Fernet
from validate_email import validate_email

import user
import safe
import mailer

INIT_USERS = "users.txt"


def getQRcode(user, key):
    url = pyotp.totp.TOTP(key).provisioning_uri(name=user, issuer_name='Secure Filesystem Authentication')
    qr = qrcode.QRCode(version=1, error_correction=qrcode.constants.ERROR_CORRECT_L, box_size=10, border=2)
    qr.add_data(url)
    qr.make(fit=True)
    return qr.make_image(fill_color="black", back_color="white")


def dataEncrypt(users_info):
    fernet_key = keyring.get_password("safe_filesystem", "nothingtosee")

    if fernet_key == None:
        fernet_key = safe.generateFernetKey()
        
    fernet = Fernet(fernet_key)

    encrypted = fernet.encrypt(str.encode(json.dumps(users_info)))

    subprocess.call(["sudo", "python3", "-c", "f=open('{}','wb');f.write({});f.close()".format(safe.DATA_PATH, encrypted)])


def register():
    if len(sys.argv) != 2:
        print("Invalid input.\n Usage: python3 init.py <users_file.txt>")
        return

    elif not os.path.isfile(os.path.abspath(sys.argv[1])):
        print("Invalid input file!")
        return

    users_info = safe.dataDecrypt()

    users_file = open(os.path.abspath(sys.argv[1]), 'r')
    users = users_file.readlines()

    for row in users:
        reset_user = False
        username, email = row.split()
        try:
            uid = pwd.getpwnam(username).pw_uid

            if not validate_email(email):
                print("Invalid email for user '{}': {}. Skipping...".format(username, email))
            
            elif (str(uid) in users_info):
                print("User '{}' already registered, generating new key. The old one will not work anymore.".format(username))
                reset_user = True

            user_symmetric_key = pyotp.random_base32(24)
            mailer.sendQRcode(email, getQRcode("{}@{}".format(username, user.get_system()), user_symmetric_key), username, user.get_system(), reset_user)
            users_info[uid] = user_symmetric_key


        except KeyError:
            print("User {} is not registered in this system! Skipping..".format(username))

    dataEncrypt(users_info)


if __name__ == "__main__":
    register()