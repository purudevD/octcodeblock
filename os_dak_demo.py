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

email = "received an email from kumarimeena@amazon.com"
pattern = re.compile(r'([a-z0-9]+)@[a-z]+\.com'
matches = pattern.finditer(email)
for match in matches:
    print(match)

for i in range(10):
    print(i)

try:
    div_zero = (100/0)
except ZeroDivisionError as zero_div:
    print(zero_div)
print('This is the print statement in the issuemerge branch')
