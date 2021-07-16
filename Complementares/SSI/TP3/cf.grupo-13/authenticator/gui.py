from tkinter import Tk, Label, StringVar, Button, Entry
import functools
import user


def tryKey(tkWindow, user, input_key):
	if user.hasRetries():
		user.attempt(input_key.get())
		input_key.set("")
		
		if user.authorized():
			tkWindow.destroy()

		else:
			tkWindow.title("{} tries left".format(user.tries+1))

	else:
		tkWindow.destroy()


def promptVerification(user):
	tkWindow = Tk()
	tkWindow.configure(bg='#999999')
	tkWindow.geometry('265x90')
	tkWindow.title('Filesystem Auth')

	# Key input
	password = StringVar()
	Entry(tkWindow, textvariable=password, width=6, bd=0, font="Ubuntu 40", bg="#838383", fg="#333333").place(x=10 ,y=10)

	validateKey = functools.partial(tryKey, tkWindow=tkWindow, user=user, input_key=password)

	# Submit button
	Button(tkWindow, text="»", command=validateKey, bd=0, width=1, font="Ubuntu 35", bg="#dd4814", fg="#ffffff").place(x=200, y=10)

	tkWindow.mainloop()