print("Asutosh is a good student!!!")
# python os_dak_demo.py
import os
import re
# This is the issue
sentence = "Ramana is 47 years old."
pattern = re.compile(r'\d+')
print(os.getcwd())
os.chdir("C:\\Work\\Python\\Pandas\\")
print(os.getcwd())
# list the contents of the working directory
print(os.listdir())

#
#os.makedirs("OS-DEMO-1")
try:
    os.rmdir("OS-DEMO-1")
except FileNotFoundError as file_err:
    print(file_err)

print("The code will continue")
print('This is the print statement in the issuemerge branch')