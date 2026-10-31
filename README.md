# **Lunar Kitchen for Linux**

## Information

This kitchen only currently supports debian based linux distributions and so modifications to the code may be required for other distributions.

## Prepare:

Update Dependencies:

    $ sudo apt update && sudo apt upgrade -y
    $ sudo apt install android-sdk-libsparse-utils simg2img -y

Download The Kitchen:

	$ git clone -b stable https://github.com/XhakaTK/lunar-kitchen.git
	$ cd lunar-kitchen

How To Use:

	$ ./start.sh

- This will list all of the available options within Lunar Kitchen
- It is recommended to first Create a New Project
- Then Unpack any images
- Edit the data
- Then Repack those image

