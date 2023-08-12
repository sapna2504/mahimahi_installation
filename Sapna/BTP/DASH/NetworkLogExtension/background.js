var contentport;

chrome.runtime.onConnect.addListener(function(port) {
  console.assert(port.name == "netlogextension");
  contentport = port;
});

function logFunc(requestDetails, tag) {
  var date = new Date();
  logstr = tag + " " + date.getTime() + " " + JSON.stringify(requestDetails);
	contentport.postMessage(logstr);
}


chrome.webRequest.onBeforeRequest.addListener(
  function(x){logFunc(x,"BEFORE_REQUEST")},
  {urls: ["<all_urls>"]}
);

// long on first byte received
chrome.webRequest.onResponseStarted.addListener(
  function(x){logFunc(x,"RESPONSE_STARTED")},
  {urls: ["<all_urls>"]}
);

// long on header
chrome.webRequest.onSendHeaders.addListener(
  function(x){logFunc(x,"SEND_HEADERS")},
  {urls: ["<all_urls>"]}
);

// log response finished
chrome.webRequest.onCompleted.addListener(
  function(x){logFunc(x,"COMPLETE")},
  {urls: ["<all_urls>"]},
  ["responseHeaders"]
);

navigator.connection.addEventListener('change', logNetworkInfo);

function logNetworkInfo() {
  var date = new Date();
  // current time
  console.log('         time: ' + date.getTime());
  
  // Network type that browser uses
  console.log('         type: ' + navigator.connection.type);

  // Effective bandwidth estimate
  console.log('     downlink: ' + navigator.connection.downlink + ' Mb/s');

  // Effective round-trip time estimate
  console.log('          rtt: ' + navigator.connection.rtt + ' ms');

  // Upper bound on the downlink speed of the first network hop
  console.log('  downlinkMax: ' + navigator.connection.downlinkMax + ' Mb/s');

  // Effective connection type determined using a combination of recently
  // observed rtt and downlink values: ' +
  console.log('effectiveType: ' + navigator.connection.effectiveType);
  
  // True if the user has requested a reduced data usage mode from the user
  // agent.
  console.log('     saveData: ' + navigator.connection.saveData);
  
  // Add whitespace for readability
  console.log('');
}

logNetworkInfo();

