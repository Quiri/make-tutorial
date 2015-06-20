for i in server1 server2 server3  server4 ; do
	cd $i;
	vagrant up;
	cd ..;
done;
