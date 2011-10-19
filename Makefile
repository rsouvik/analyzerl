ERLC=/usr/bin/erlc
#ERLC=/usr/bin/erl
#ERLCFLAGS=-make
ERLCFLAGS=-o
SRCDIR=.
BEAMDIR=./ebin

all: 
	@ mkdir -p $(BEAMDIR) ;
	#@ $(ERLC) $(ERLCFLAGS) ;
	@ $(ERLC) $(ERLCFLAGS) $(BEAMDIR) $(SRCDIR)/*.erl ;
clean: 
	@ rm -rf $(BEAMDIR) ;
	@ rm -rf erl_crush.dump
