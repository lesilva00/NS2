# Create a ns object
set ns [new Simulator]
 
$ns color 1 Blue
$ns color 2 Red
 
# Open the Trace files
set TraceFile [open tcp.tr w]
$ns trace-all $TraceFile
 
# Open the NAM trace file
set NamFile [open tcp.nam w]
$ns namtrace-all $NamFile
 
# Create six nodes

#for {set i 0}{$i <3}{incr i} {
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
#}

$ns duplex-link $n0 $n1 10Mb 20ms DropTail
#$ns duplex-link-op $n0 $n1 orient right-down
$ns duplex-link $n1 $n2 1Mb 20ms DropTail
$ns duplex-link $n2 $n3 10Mb 20ms DropTail

 
#TCP N0 and N4
set tcp1 [new Agent/TCP/Newreno]
$ns attach-agent $n0 $tcp1
 
set sink1 [new Agent/TCPSink/DelAck]
$ns attach-agent $n3 $sink1
$ns connect $tcp1 $sink1
 
$tcp1 set fid_ 1
#$tcp1 set window_ 1000
#$tcp1 set packetSize_ 1000
 
#TCP N0 and N4
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP
#$ftp1 set window_ 1000
 
 
$ns at 0.1 "$ftp1 start"
$ns at 50.0 "$ftp1 stop"
 
proc finish {} {
	global ns TraceFile NamFile
	$ns flush-trace
	close $TraceFile
	close $NamFile
	exec nam tcp.nam &
	exit 0
}

$ns at 55.0 "finish"
$ns run
