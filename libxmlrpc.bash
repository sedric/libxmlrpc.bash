#!/bin/bash

send_xmlrpc() {
    xml=$1
    rpcproxy=$2

    wget --header=Content-Type:text/xml -qO - --no-check-certificate --post-data "$xml" "$rpcproxy" | xml2
}

gen_xmlrpc() {
XML="<?xml version=\"1.0\"?>
<methodCall>"
delim=","

while getopts "d:m:p:" option
do
    case $option in
	m )
	    method=$OPTARG
	    method="<methodName>$method</methodName>" ;;
	p )
	    params=$OPTARG ;;
	d )
	    delim=$OPTARG ;;
    esac
done
old_IFS="$IFS"
IFS="$delim"
for param in $params
do
    parameters="${parameters}
      <param>
        <value>$param</value>
      </param>"
done
IFS="$old_IFS"

XML="${XML}
$method
    <params>$parameters
    </params>
</methodCall>"
echo "$XML"
}
