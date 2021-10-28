#!/bin/sh

#
#    CFNS - Rijkswaterstaat CIV, Delft © 2021 - 2022 <cfns@rws.nl>
#
#    Copyright 2021 - 2022 Bastiaan Teeuwen <bastiaan@mkcl.nl>
#
#    This file is part of dabalarm
#
#    dabalarm is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    dabalarm is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with dabalarm.  If not, see <https://www.gnu.org/licenses/>.
#

mkdir -p build/
mkdir -p bin/

rootdir=$(dirname "$0")

function fail {
	echo "Compilation has failed, please try compiling manually"
	exit 1
}

function dabmux {
	dir="$rootdir/build/odr-dabmux"
	mkdir -p "$dir" && cd "$dir"
	git clone https://github.com/Opendigitalradio/ODR-DabMux.git .

	./bootstrap.sh && \
		./configure \
			--prefix="$dir/_prefix" \
			--bindir="$rootdir/bin" && \
		make -j$(nproc) install || fail

	echo "ODR-DabMux is installed"
}

function dabmod {
	dir="$rootdir/build/odr-dabmod"
	mkdir -p "$dir" && cd "$dir"
	git clone https://github.com/Opendigitalradio/ODR-DabMod.git .

	./bootstrap.sh && \
		./configure \
			--prefix="$dir/_prefix" \
			--bindir="$rootdir/bin" \
			--disable-output-uhd && \
		make -j$(nproc) install || fail

	echo "ODR-DabMod is installed"
}

function audioenc {
	dir="$rootdir/build/odr-audioenc"
	mkdir -p "$dir" && cd "$dir"
	git clone https://github.com/Opendigitalradio/ODR-AudioEnc.git .

	echo NYI
	#echo "ODR-AudioEnc is installed"
}

function padenc {
	dir="$rootdir/build/odr-padenc"
	mkdir -p "$dir" && cd "$dir"
	git clone https://github.com/Opendigitalradio/ODR-PadEnc.git .

	echo NYI
	#echo "ODR-PadEnc is installed"
}

function dablin {
	dir="$rootdir/build/dablin"
	mkdir -p "$dir" && cd "$dir"
	git clone https://github.com/Opendigitalradio/dablin.git .

	echo NYI
}

function welleio {
	dir="$rootdir/build/welle-io"
	mkdir -p "$dir" && cd "$dir"
	git clone https://github.com/Opendigitalradio/ODR-DabMux.git .

	echo NYI
}

function all {
	dabmux
	dabmod
	audioenc
	padenc
	dablin
	welleio
}

all
cd "$rootdir"
