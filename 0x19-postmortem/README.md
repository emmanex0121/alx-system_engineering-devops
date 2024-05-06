# My First Postmortem
Emmanuel Nwachukwu

## Outage Summary
- Access to web server 1 could not be established and as such resources like database data amongst others could not be retrieved. 

## Timeline
- Issue detected on the morning of day 2 of the web server 2 setup project.
- Tried unsuccessfully to access web server 1 and its resources.
- Tried to reboot from the ALX server provision section of our intranet after it was assumed that the ssh port has been blocked in the hopes that a reboot would unblock it to no avail.
- It was eventually determined a new server to replace that one was the only solution since we have no access to physical machine hosting the server. 

## Root cause and resolution
This happened for the whole of two days. It was during one of my projects with alx where we needed to setup our own web stack. We already setup a web server 1 and stacked it behind a load balancer 1 fully configured as well. We were at the point of setting up another web server 2 behind the load balancer and I had just finished configuring it, but for some reason I needed to use flask to test out some programs on the already setup web server 1 but in the midst of debugging and the installation of the python flask i had turned of my ssh port 22 and that was were my woe started.

I wasn't aware of this development and did not check my open firewall allowed ports before retiring for the night and logging out of the server. Woke up the next morning still oblivious till I tried to send a file using scp to the server which failed. Then I tried to curl the server to get a response which also failed.

Did some research concerning why my server won't connect based on the error it was providing and started trying to debug using several connection processes, all of which failed. Then I decided to explore the ssh port debugging method but that also failed. I needed to get access to the remote server to re-enable it which is impossible since we have no access to the physical machines.

“ There was no resolving this…”

Eventually decided that there was no option other than requesting for and setting up a new remote server to be setup for my web server.
Got a replacement server from alx and had to re configure and setup everything from scratch to be like the previous disconnected web server.
- Installed the nginx web server.
- Configured the server.
- Set up the root endpoint of my web server (/).
- Setup the ufw firewall and ensured that the ssh port is always open.
- Restored the MySQL database using the copy dumped from the web server 2 that was literally a clone of the previous web server 1.
- Updated the ip address of the web server on the load balancer to correctly redirect incoming requests to this new server and not the old one.

## Corrective and preventive measures
- **Preventive Measures**
	- Always ensure that your ssh port is always open
	- Always ensure that ssh port of the server is never in use by another process
	- Check that the ssh port is not blocked out of incoming transmission by firewall.
	- Always check that there’s no hindrance to your server’s ssh port before logging off.

- **Corrective Measures**
	- The only corrective measure is to reach out to the admin to help restore ssh connection on the server
	- However in this case, the only corrective measure is to prevent that port from being unreachable, else a new web server will need to be configured. 


### Emmanuel Nwachuku - [<emmax0121@gmail.com>] [Github](https://github.com/emmanex0121) / [Twitter](https://twitter.com/PHXKHEED)
