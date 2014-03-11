ssh-server-manager
==================

Ever you tied up with keep in mind the messy server IP/hostname which have different user name to login and even some of them are using special port number (not standard 22) ?<br>
ssh-server manager is a bundle of scripts help to simplify those login information (IP/hostname, user, port) into short and esay-to-modify nicknames.

You'll definitely like this convenient way to login to servers and transfer files from/to them, if given tens or hundreds of servers to maintain with.

Try it out by using "ssh-server add" to add a server info, then use "ssh-to" to access it.

 - ssh-server <br>manager the login information
<pre>
Usage: ssh-server list
       ssh-server add NICK_NAME USER IP [PORT]
       ssh-server del NICK_NAME
</pre>
 - ssh-to <br>login to server by nickname
<pre>
Usage: ssh-to [options] NICK_NAME
       -u USER: specify server user
       -p PORT: specify server port
</pre>
 - ssh-copyid <br>copy user identify file to server by nickname
<pre>
Usage: ssh-copy-id-to [options] NICK_NAME
       -i FILE: specify ssh identity file
       -u USER: specify server user
       -p PORT: specify server port
</pre>
 - send-file-to <br>copy file to server by nickname
<pre>
Usage: send-file-to [options] NICK_NAME FILE1 [FILE2 ..]
       -f FOLDER: specify server folder to store files
       -u USER: specify server user
       -p PORT: specify server port
       -n : don't try remove files of same name on server before transfer
</pre>
 - receive-file-from <br>copy/move file from server by nickname
<pre>
Usage: receive-file-from [options] NICK_NAME FILE1 [FILE2 ..]
       -f FOLDER: specify local folder to receive files
       -u USER: specify server user
       -p PORT: specify server port
       -d : delete files on server after transfer finish
</pre>

These scripts was part of <a href=https://github.com/linfan/FreyrScripts>FreyrScripts</a> repository, they are pick out into separate repo because I find them really useful as a whole.<br>
You may need to check it's previous location if you are looking for more historys about them.
