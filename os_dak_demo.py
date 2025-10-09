print("Asutosh is a good student!!!")
# python os_dak_demo.py
import os
import re
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
email = "received an email from kumarimeena@amazon.com"
pattern = re.compile(r'([a-z0-9]+)@[a-z]+\.com'
matches = pattern.finditer(email)
for match in matches:
    print(match)
