#!/bin/tclsh

# if this script replaces /bin/checkInternet, set also the system stateFile, otherwise set our stateFile
if { [file exists /etc/config/fbReplaceCheckInternet] == 1} {
	set stateFile "/var/status/hasInternet"
} else {
	set stateFile "/var/status/hasInternetFritzBox"
}

load tclrega.so

package require http

proc setSysVar { value } {
	set script "
string  svName = \"FRITZ!Box Status Internetverbindung\";
object  svObj  = dom.GetObject(svName);
if (!svObj){   
	object svObjects = dom.GetObject(ID_SYSTEM_VARIABLES);
	svObj = dom.CreateObject(OT_VARDP);
	svObjects.Add(svObj.ID());
	svObj.Name(svName);   
	svObj.ValueType(ivtInteger);
	svObj.ValueSubType(istEnum);
	svObj.DPInfo(\"FRITZ!Box Status der Internetverbindung\");
	svObj.ValueList(\"Unconfigured;Connecting;Authenticating;Connected;PendingDisconnect;Disconnecting;Disconnected;Error\");
	svObj.DPArchive(false);
	svObj.State(0);
	svObj.Internal(false);
	svObj.Visible(true);
	dom.RTUpdate(0);
}
if(svObj.Value() != $value) {
	svObj.State($value);
}
	"
	rega_script $script
}

if { [catch {
	set url "http://fritz.box:49000/igdupnp/control/WANIPConn1"
	set header "SoapAction urn:schemas-upnp-org:service:WANIPConnection:1#GetStatusInfo"

	set postData "<?xml version=\"1.0\" encoding=\"utf-8\" ?>
		<s:Envelope s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\">
		    <s:Body>
		        <u:GetStatusInfo xmlns:u=\"urn:schemas-upnp-org:service:WANIPConnection:1\" />
		    </s:Body>
		</s:Envelope>
	"

	set connstate_xml [::http::data [::http::geturl $url -headers $header -query $postData -type "text/xml; charset=utf-8"]]

	regexp {<NewConnectionStatus>(.+)<\/NewConnectionStatus>} $connstate_xml] matched connstate
	switch $connstate {
		Unconfigured {
			setSysVar 0
			file delete $stateFile
		}
		Connecting {
			setSysVar 1
			file delete $stateFile
		}
		Authenticating {
			setSysVar 2
			file delete $stateFile
		}
		Connected {
			setSysVar 3
			set fc [open $stateFile w]
			close $fc
		}
		PendingDisconnect {
			setSysVar 4
			file delete $stateFile
		}
		Disconnecting {
			setSysVar 5
			file delete $stateFile
		}
		Disconnected {
			setSysVar 6
			file delete $stateFile
		}
		default {
			setSysVar 7
			file delete $stateFile
		}
	}
} errorString] } {
    setSysVar 7
	file delete $stateFile
}
