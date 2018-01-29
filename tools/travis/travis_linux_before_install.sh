#!/bin/bash
set -ev


if [ -z ${DOCKER+x} ]; then
	# Only on non-docker builds required

	echo "=== Installing from external package sources ===" && echo -en 'travis_fold:start:before_install.external\\r'

	if [ "$CC" = "tcc" ]; then
		mkdir tcc_install && cd tcc_install
		wget https://download.savannah.gnu.org/releases/tinycc/tcc-0.9.27.tar.bz2
		tar xvf tcc-0.9.27.tar.bz2
		cd tcc-0.9.27
		./configure
		make
		sudo make install
		cd ../..
		rm -rf tcc_install
	fi

	sudo add-apt-repository -y ppa:lttng/ppa
	sudo apt-get update -qq
	sudo apt-get install -y liburcu4 liburcu-dev
	echo -en 'travis_fold:end:script.before_install.external\\r'

	echo "=== Installing python packages ===" && echo -en 'travis_fold:start:before_install.python\\r'
	pip install --user cpp-coveralls
	pip install --user sphinx
	pip install --user sphinx_rtd_theme
	echo -en 'travis_fold:end:script.before_install.python\\r'

	echo "=== Installed versions are ===" && echo -en 'travis_fold:start:before_install.versions\\r'
	clang --version
	g++ --version
	cppcheck --version
	valgrind --version
	echo -en 'travis_fold:end:script.before_install.versions\\r'

fi
