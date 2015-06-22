vm/vagrant up;

for s in `seq 1 4`; do
	server=server$s;
	Rscript simulate.R 100000 serverlogs.foo > /dev/null 
	Rscript simulate.R 10000  serverlogs.bar > /dev/null
	ssh -F vm/ssh-config server$s "mkdir -p data" 
	scp -F vm/ssh-config serverlogs.* server$s:data/
done;
