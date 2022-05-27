# Creative Commons Attribution 4.0 International License
# https://creativecommons.org/licenses/by/4.0/

mytag=miogatto


help:
	@echo "make help"
	@echo "      this message"
	@echo "==== Targets outside container ===="
	@echo "make docker"
	@echo "         build and run"

git_miogatto:
	if [ -d "MioGatto" ]; then \
		cd MioGatto && git pull; \
	else \
		git clone https://github.com/wtsnjp/MioGatto.git; \
	fi

git_latexml:
	if [ -d "LaTeXML" ]; then \
		cd LaTeXML && git pull; \
	else \
		git clone https://github.com/brucemiller/LaTeXML.git; \
	fi

docker: docker_build docker_live

docker_build:
	docker build -t $(mytag) .

docker_live:
	docker run -it -v `pwd`:/scratch --rm $(mytag) /bin/bash

