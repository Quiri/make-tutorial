cd vm; vagrant up; vagrant ssh-config > ssh-config; cd ..;

for s in `seq 1 4`; do
	server=server$s;
	Rscript simulate.R -n 90000 -v 10000 serverlogs.foo > /dev/null 
	Rscript simulate.R -n 20000 -v 10000 serverlogs.bar > /dev/null
	ssh -F vm/ssh-config server$s "mkdir -p data" 
	scp -F vm/ssh-config serverlogs.* server$s:data/
done;

ln -f vm/ssh-config tutorial/ssh-config

sudo -u postgres createdb datakraken
