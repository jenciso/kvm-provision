provision:
	./new-vm.sh -m 2048 -c 2 -i 192.168.122.11 ubuntu1
	./add-disk.sh -d vdb -s 60G ubuntu1
 
destroy:
	./del-vm.sh ubuntu1
