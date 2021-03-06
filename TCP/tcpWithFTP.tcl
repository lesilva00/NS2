# Create a ns object
set ns [new Simulator]
 
$ns color 1 Blue
$ns color 2 Red
 
# Open the Trace files
set TraceFile [open tcpWithFTP.tr w]
$ns trace-all $TraceFile
 
# Open the NAM trace file
set NamFile [open tcpWithFTP.nam w]
$ns namtrace-all $NamFile
 
# Create six nodes

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

$ns duplex-link $n0 $n1 400Kb 80ms DropTail
$ns duplex-link $n1 $n2 40Kb 80ms DropTail

#TCP N0 and N4
set tcp1 [new Agent/TCP/Newreno]
$ns attach-agent $n0 $tcp1
 
set sink1 [new Agent/TCPSink/DelAck]
$ns attach-agent $n2 $sink1
$ns connect $tcp1 $sink1
 
$tcp1 set fid_ 1
#$tcp1 set window_ 1000
#$tcp1 set packetSize_ 1000
 
#TCP N0 and N4
set ftp [new Application/FTP]
$ftp attach-agent $tcp1
#$ftp set type_ FTP
#$ftp1 set window_ 1000
 
 
$ns at 0.1 "$ftp start"
$ns at 0.2 "$ftp send 1024"
$ns at 0.3 "$ftp send 2048"
#$ns at 0.2 "$ftp send 102400"
#$ns at 0.3 "$ftp send 50000"
#$ns at 100.0 "$ftp stop"
 
proc finish {} {
	global ns TraceFile NamFile
	$ns flush-trace
	close $TraceFile
	close $NamFile
	exec nam tcpWithFTP.nam &
	exit 0
}

$ns at 1500.0 "finish"
$ns run
