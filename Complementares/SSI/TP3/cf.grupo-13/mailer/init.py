import keyring
import json
import os
import pwd
import sys
import subprocess
from cryptography.fernet import Fernet
from validate_email import validate_email

import safe


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
        username, email = row.split()
        try:
            uid = pwd.getpwnam(username).pw_uid

            if uid in users_info:
                continue

            if not validate_email(email):
                print("Invalid email for user {}: {}. Skipping...".format(username, email))
                continue

            users_info[uid] = email

        except KeyError:
            print("User {} is not registered in this system! Skipping..".format(username))

    dataEncrypt(users_info)


if __name__ == "__main__":
    register()