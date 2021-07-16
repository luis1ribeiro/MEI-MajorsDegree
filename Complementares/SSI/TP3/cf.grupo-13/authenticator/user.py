import secrets
import pyotp
import os
import shutil
import getpass
import pwd


class User:
	def __init__(self, key):
		self.auth = False
		self.tries = 2
		self.key = key

	def attempt(self, user_input):
		if self.hasRetries():
			if secrets.compare_digest(self.key.now(), user_input):
				self.auth = True
			
			else:
				self.tries -= 1

	def authorized(self):
		return self.auth

	def hasRetries(self):
		return self.tries > 0


def get_system():
	return os.uname()[1]