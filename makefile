SIM = genus
SCRIPTS_DIR = scripts

run:
	$(SIM) -batch -files $(SCRIPTS_DIR)/run_sim.tcl

clean:
	rm -rf *.log *.cmd *.shm *.vcd *.key *.dsn *.trn *.out waves.shm