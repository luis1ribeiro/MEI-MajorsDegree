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



def sendQRcode(to, qrcode, user, system, reset):
    emailUser = keyring.get_password("safe_filesystem", "whereisit")
    emailPasswd = keyring.get_password("safe_filesystem", "idontknow")

    if (emailPasswd == None) or (emailPasswd == None):
        setEmailAccount()

        emailUser = keyring.get_password("safe_filesystem", "whereisit")
        emailPasswd = keyring.get_password("safe_filesystem", "idontknow")

    # Create the root message and fill in the from, to, and subject headers
    msgRoot = MIMEMultipart('related')
    msgRoot['Subject'] = 'Secure Filesystem Authentication'
    msgRoot['From'] = "Secure Filesystem Manager"
    msgRoot['To'] = to

    # We reference the image in the IMG SRC attribute by the ID we give it below
    newUserText = MIMEText('Greetings from <b>Secure Filesystem Manager</b>! <br><br>You, <b>{0}@{1}</b>, are one of the allowed users to access filesystems mounted by me!<br><br><img src="cid:image1"><br><br>You can scan this QR Code in Google Authenticator or any other Multi-Factor Authentication (MFA) compatible software. This will give you a One Time Password (OTP) every 30 seconds that grants you access to any file you wish to open in the filesystem, as long as you are using your user, {0}.<br><br> Feel free to delete this e-mail once you already scanned the QR Code.'.format(user, system), 'html')
    resetUserText = MIMEText('Greetings from <b>Secure Filesystem Manager</b>! <br><br>By admin request, the authentication data regarding your user, <b>{0}@{1}</b>, has been reset, and therefore, your old scanned QR Code will not work anymore. Please scan this one to update your authentication method.<br><br><img src="cid:image1"><br><br>Google Authenticator will replace your current data, as this key is associated with the same user ({0}@{1}), so you don\'t need to delete the old one yourself.<br><br> Once again, feel free to delete this e-mail once you already scanned the QR Code.'.format(user, system), 'html')
    if reset:
        msgRoot.attach(resetUserText)
    else:
        msgRoot.attach(newUserText)

    # This example assumes the image is in the current directory
    buf = io.BytesIO()
    qrcode.save(buf)
    image_stream = buf.getvalue()
    msgImage = MIMEImage(image_stream)

    # Define the image's ID as referenced above
    msgImage.add_header('Content-ID', '<image1>')
    msgRoot.attach(msgImage)

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


if __name__ == "__main__":
    setEmailAccount()