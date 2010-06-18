#!/usr/bin/env ruby
# encoding: ASCII-8BIT

$serverName = 'ApacheSOAP2.2'
$serverBase = 'http://nagoya.apache.org:5049/soap/servlet/rpcrouter'
$serverGroupB = 'None'

require 'clientBase'

drvBase = SOAP::RPC::Driver.new($serverBase, InterfaceNS)
methodDefBase( drvBase )

#drvGroupB = SOAP::RPC::Driver.new($serverGroupB, InterfaceNS)
#methodDefGroupB( drvGroupB )

doTestBase( drvBase )
#doTestGroupB( drvGroupB )
submitTestResult
