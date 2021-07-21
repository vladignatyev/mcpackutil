#!/usr/bin/env just --justfile

alias h := usage
alias help := usage
alias i := readme
alias info := readme
alias l := license
alias bl := build-lib
alias be := build-exe

export PYTHONOPTIMIZE := "1"

download := './downloads'

dist := './dist'
build := './build'
spec := './'
script := 'cli'

name := 'mcpackutil'
version := '1.0.1'

icon_sizes_win := '256'
icon_sizes_mac := '16 32 48 128 256 512'
icon_temp_name := 'Bucket_of_Axolotl_%28pre-release%29.png'
icon_url := 'https://static.wikia.nocookie.net/minecraft_gamepedia/images/c/c2/' + icon_temp_name + '/revision/latest'
icon_name := 'favicon'
icon_destination := download + "/icon/" + icon_temp_name
icon_final := dist + "/icon/"+ icon_name

split := if os() == "windows" { ';' } else { ':' }

# shows the command list
default:
	@just --list --unsorted

clean:
    rm -rfv ./dist/*

_requirements:
	pip install -r requirements.txt

# shows how to use phantom
usage:
	@src/cli.py -h

# shows the readme file
readme:
	@cat README.md

# shows the license file
license:
	@cat LICENSE

# count non-empty lines of code
sloc:
	@cat src/*.py | sed '/^\s*$/d' | wc -l

# makes the temporary directory
_make_temp_dir:
	-mkdir -p {{ build }}/icon
	-mkdir -p {{ dist }}/icon
	-mkdir -p {{ download }}/icon

# downloads the icon then runs _gen_icons
_download_icon: _make_temp_dir
	curl {{ icon_url }} -o {{ icon_destination }}

# resizes a given image
_resize_icon size="256":
	#!/usr/bin/env bash
	set -euo pipefail

	if [ {{ os() }} = "macos" ]; then
		brew install imagemagick
	fi

	if [ {{ os() }} != "windows" ]; then
		convert "{{ icon_destination }}" \
		            -filter point \
					-resize "{{ size }}x{{ size }}" \
					-background none \
					-gravity center \
					-extent "{{ size }}x{{ size }}" \
					"{{ build }}/icon/{{ size }}.png"
	else
		magick convert "{{ icon_destination }}" \
		            -filter point \
					-resize "{{ size }}x{{ size }}" \
					-background none \
					-gravity center \
					-extent "{{ size }}x{{ size }}" \
					"{{ build }}/icon/{{ size }}.png"
	fi

# generates scaled versions of the icon
_gen_icons: _download_icon
	#!/usr/bin/env bash
	set -euo pipefail

	if [ {{ os() }} = "windows" ]; then
		for size in {{ icon_sizes_win }}; do just _resize_icon $size; done
	elif [ {{ os() }} = "macos" ]; then
		for size in {{ icon_sizes_mac }}; do just _resize_icon $size; done
	fi

# makes a windows icon file out of the icon images
_make_ico: _gen_icons
	#!/usr/bin/env bash
	set -euo pipefail

	if [ {{ os() }} != "windows" ]; then
		convert "$(ls {{ build }}/icon/*.png)" "{{ dist }}/icon/{{ icon_name }}.ico"
	else
		magick convert "$(ls {{ build }}/icon/*.png)" "{{ dist }}/icon/{{ icon_name }}.ico"
	fi

_make_icns: _gen_icons
	#!/usr/bin/env bash
	set -euo pipefail

	# This package is also available on Linux but we'll never use this script on it
	if [ {{ os() }} = "macos" ]; then
		brew install libicns
	fi

	png2icns {{ dist }}/icon/{{ icon_name }}.icns $(ls {{ build }}/icon/*.png | awk '$0 !~ "/64"')

# builds the library using the setup file
build-lib: _requirements clean
    python3 setup.py sdist bdist_wheel

install-lib: build-lib
    pip install -e ./

test: install-lib
    packutil extract version
    packutil extract asset

upload: build-lib
    twine upload dist/*

# runs the pyinstaller build
build-exe label=(name) type='file' level='INFO' debug='' upx='true': _requirements
	#!/usr/bin/env bash
	set -euo pipefail
	echo "Starting build for {{ os() }} ({{ arch() }})"

	# Make the icons for the OS we're on
	if [ {{ os() }} = "windows" ]; then
		just _make_ico;
	elif [ {{ os() }} = "macos" ]; then
		just _make_icns;
	fi

	if [ {{ os() }} = "windows" ]; then
		data="--add-data {{ icon_final }}.ico;."
		strip="--strip"
		icon="--icon {{ icon_final }}.ico"
	elif [ {{ os() }} = "macos" ]; then
		data="--add-data {{ icon_final }}.icns:."
		strip=""
		icon="--icon {{ icon_final }}.icns"
	else
		data=""
		strip=""
		icon=""
	fi

	if [ {{ debug }} != "" ]; then debug="--debug {{ debug }}"; else debug=""; fi

	pyinstaller \
		`# general options` \
		--distpath {{ dist }} \
		--workpath {{ build }} \
		--clean \
		--log-level {{ level }} \
		`# what to generate` \
		{{ if type == 'dir' { '-D' } else { '-F' } }} \
		--specpath {{ spec }} \
		--name {{ label }} \
		`# what to bundle` \
		$data \
		`# how to generate` \
		$debug \
		$strip \
		{{ if upx != 'true' { '--noupx' } else { '' } }} \
		--console \
		$icon \
		`# script to run` \
		./{{ name }}/{{ script }}.py
	echo 'Finished building'

@build label=(name): build-lib build-exe
    echo
