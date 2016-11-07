<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.127
	 Created on:   	September 20, 2016
	 Created by:   	Richard Smith, GSweet
	 Organization: 	Savers, Inc.
	 Filename:     	git-Get-DNSScavengingData.ps1 
	===========================================================================
	.DESCRIPTION
		Script shown will dump the DNS server name and scavenging settings for each 
		DNS server in the domain.

#>

Import-Module ActiveDirectory;

# Function - Logging file
function Logging($pingerror, $Computer, $DnsStatus)
{
	$outputfile = "\\savers.com\Shares\Install\UTILITY\Automation\logs\log_DnsScavengingData.txt";
	
	$timestamp = (Get-Date).ToString();
	
	$logstring = "Computer / DNS (reported in Hours): {0}, {1}" -f $Computer, $DnsStatus;
	
	"$timestamp - $logstring" | out-file $outputfile -Append;
	
	if ($pingerror -eq $false)
	{
		Write-Host "$timestamp - $logstring";
	}
	else
	{
		Write-Host "$timestamp - $logstring" -foregroundcolor red;
	}
	return $null;
}

# Query for a list of all domain controllers
$DCs = (GET-ADDOMAIN -Identity Savers.com).ReplicadirectoryServers

# ForEach Loop - Process list of DCs and return lines with "scavenging" only in them 
foreach ($dc in $DCs)
{
	$output = dnscmd $DC /info
	$string = $output | Select-string "Scavenging"
	Write-host $DC
	Write-host $string
	Write-host ""
	
	Logging $False $DC $string;
}
