import smtplib
import io
import keyring
import getpass
from validate_email import validate_email
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.image import MIMEImage


def setEmailAccount():
    user_email = input("Please enter the mailer account: ")

    while not validate_email(user_email):
        user_email = input("That email is not valid. Try again: ")

    user_passwd = getpass.getpass("Please enter your password: ")

    keyring.set_password("safe_filesystem", "whereisit", user_email)
    keyring.set_password("safe_filesystem", "idontknow", user_passwd)



def sendCode(path, code, to):
    emailUser = keyring.get_password("safe_filesystem", "whereisit")
    emailPasswd = keyring.get_password("safe_filesystem", "idontknow")

    if (emailPasswd == None) or (emailPasswd == None):
        setEmailAccount()

        emailUser = keyring.get_password("safe_filesystem", "whereisit")
        emailPasswd = keyring.get_password("safe_filesystem", "idontknow")

    # Create the root message and fill in the from, to, and subject headers
    msgRoot = MIMEMultipart('related')
    msgRoot['Subject'] = 'Secure Filesystem File Request'
    msgRoot['From'] = "Secure Filesystem Manager"
    msgRoot['To'] = to

    # We reference the image in the IMG SRC attribute by the ID we give it below
    msgText = MIMEText("Please enter the following verification code to access the requested file. You have 30 seconds or else... nothing happens, really!\n\nRequested file: {}\nVerification code: {}\r\n".format(path, code))
    msgRoot.attach(msgText)

    # creates SMTP session 
    s = smtplib.SMTP('smtp.gmail.com', 587) 
    
    # start TLS for security 
    s.starttls()

    # Authentication 
    s.login(emailUser, emailPasswd)
    
    # Send E-mail
    s.sendmail(emailUser, to, msgRoot.as_string())
    
    # Quit
    s.quit()