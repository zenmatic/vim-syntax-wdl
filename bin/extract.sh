#!/bin/bash

# extract all the examples from the spec
wget https://raw.githubusercontent.com/openwdl/wdl/main/versions/1.0/SPEC.md
perl -n -e '
	if (/^```wdl/) {
		$str = ""
	} elsif (/^```$/) {
		print $str,"\n"
	} else {
		$str .= $_
	}
' <SPEC.md >test.wdl
