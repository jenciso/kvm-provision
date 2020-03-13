provision:
	./new-vm.sh -n dcbvm090lb321 -m 4096 -c 2 -i 10.64.13.207 
	./new-vm.sh -n dcbvm090lb347 -m 4096 -c 2 -i 10.64.13.217 
	./new-vm.sh -n dcbvm090lb348 -m 4096 -c 2 -i 10.64.13.218 
	./new-vm.sh -n dcbvm090lb349 -m 4096 -c 2 -i 10.64.13.219 
	./new-vm.sh -n dcbvm090lb351 -m 4096 -c 2 -i 10.64.13.221
	./new-vm.sh -n dcbvm090lb352 -m 4096 -c 2 -i 10.64.13.222
	./add-disk.sh -n dcbvm090lb347 -d vdb -s 60G
	./add-disk.sh -n dcbvm090lb348 -d vdb -s 60G
	./add-disk.sh -n dcbvm090lb349 -d vdb -s 80G
	./add-disk.sh -n dcbvm090lb347 -d vdc -s 80G
	./add-disk.sh -n dcbvm090lb348 -d vdc -s 80G
	./add-disk.sh -n dcbvm090lb349 -d vdc -s 80G

destroy:
	./del-vm.sh dcbvm090lb321
	./del-vm.sh dcbvm090lb347
	./del-vm.sh dcbvm090lb348
	./del-vm.sh dcbvm090lb349
	./del-vm.sh dcbvm090lb351
	./del-vm.sh dcbvm090lb352
