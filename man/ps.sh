#!/bin/csh -f
#Postscript Version of the Manual

set out=PS

dvips -f 100        doc > $out/man100-end.ps
dvips -f 80  -t  99 doc > $out/man80-99.ps
dvips -f 60  -t  79 doc > $out/man60-79.ps
dvips -f 40  -t  59 doc > $out/man40-59.ps
dvips -f 20  -t  39 doc > $out/man20-39.ps
dvips -f  1  -t  19 doc > $out/man01-19.ps
dvips        -t   0 doc > $out/man00-01.ps

