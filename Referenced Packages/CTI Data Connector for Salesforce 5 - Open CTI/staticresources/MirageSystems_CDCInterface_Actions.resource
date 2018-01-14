CDCInterface.prototype.HangUp = function (callId) {
	if (callId) {
		this.DoCall('HangUp', 'mandator=' + mirageOpenCTISettings.ADAPTER_SETTINGS_MANDATOR +
			'&password=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_MANDATOR_PASSWORD) +
			'&participantId=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_PARTICIPANT) + 
			'&callID=' + encodeURIComponent(callId) +
			'&version=' + encodeURIComponent(mirageOpenCTISettings.VERSION));
	}
	else {
		mirageLogger.LogWarn('CDCInterface.HangUp called without callId');
	}
};
CDCInterface.prototype.Answer = function (callId) {
	if (callId) {
		this.DoCall('Answer', 'mandator=' + mirageOpenCTISettings.ADAPTER_SETTINGS_MANDATOR +
			'&password=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_MANDATOR_PASSWORD) +
			'&participantId=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_PARTICIPANT) + 
			'&callID=' + encodeURIComponent(callId) +
			'&version=' + encodeURIComponent(mirageOpenCTISettings.VERSION));
	}
	else {
		mirageLogger.LogWarn('CDCInterface.Answer called without callId');
	}
};
CDCInterface.prototype.Transfer = function (callId, number) {
	if ((callId) && (number)) {
		this.DoCall('Transfer', 'mandator=' + mirageOpenCTISettings.ADAPTER_SETTINGS_MANDATOR +
			'&password=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_MANDATOR_PASSWORD) +
			'&participantId=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_PARTICIPANT) + 
			'&callID=' + encodeURIComponent(callId) + '&number=' + encodeURIComponent(number) +
			'&version=' + encodeURIComponent(mirageOpenCTISettings.VERSION));
	}
	else {
		mirageLogger.LogWarn('CDCInterface.Transfer called without callId and/or number');
	}
};
CDCInterface.prototype.OneStepTransfer = function (callId, number) {
	if ((callId) && (number)) {
		var data = {
				callId:	callId,
				number:	number,
				action:	'OneStepTransfer'
		};
		this.DoCall('AddCommand', 'mandator=' + mirageOpenCTISettings.ADAPTER_SETTINGS_MANDATOR +
			'&password=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_MANDATOR_PASSWORD) +
			'&participantId=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_PARTICIPANT) + 
			'&data=' + encodeURIComponent(JSON.stringify(data)) +
			'&version=' + encodeURIComponent(mirageOpenCTISettings.VERSION));
	}
	else {
		mirageLogger.LogWarn('CDCInterface.OneStepTransfer called without callId and/or number');
	}
};
CDCInterface.prototype.CompleteTransfer = function (callId) {
	if ((callId) && (number)) {
		var data = {
				callId:	callId,
				action:	'CompleteTransfer'
		};
		this.DoCall('AddCommand', 'mandator=' + mirageOpenCTISettings.ADAPTER_SETTINGS_MANDATOR +
			'&password=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_MANDATOR_PASSWORD) +
			'&participantId=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_PARTICIPANT) + 
			'&data=' + encodeURIComponent(JSON.stringify(data)) +
			'&version=' + encodeURIComponent(mirageOpenCTISettings.VERSION));
	}
	else {
		mirageLogger.LogWarn('CDCInterface.OneStepTransfer called without callId and/or number');
	}
};
CDCInterface.prototype.Pause = function (callId) {
	if (callId) {
		this.DoCall('Hold', 'mandator=' + mirageOpenCTISettings.ADAPTER_SETTINGS_MANDATOR +
			'&password=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_MANDATOR_PASSWORD) +
			'&participantId=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_PARTICIPANT) + 
			'&callID=' + encodeURIComponent(callId) +
			'&version=' + encodeURIComponent(mirageOpenCTISettings.VERSION));
	}
	else {
		mirageLogger.LogWarn('CDCInterface.Pause called without callId');
	}
};
CDCInterface.prototype.Resume = function (callId) {
	if (callId) {
		this.DoCall('Answer', 'mandator=' + mirageOpenCTISettings.ADAPTER_SETTINGS_MANDATOR +
			'&password=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_MANDATOR_PASSWORD) +
			'&participantId=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_PARTICIPANT) + 
			'&callID=' + encodeURIComponent(callId) +
			'&version=' + encodeURIComponent(mirageOpenCTISettings.VERSION));
	}
	else {
		mirageLogger.LogWarn('CDCInterface.Resume called without callId');
	}
};
CDCInterface.prototype.Acknowledge = function (action) {
	/* MK 2014-09-24 acknowledged is only used in softphone so there is no need to send it to the server 
	this.DoCall('Acknowledge', 'mandator=' + mirageOpenCTISettings.ADAPTER_SETTINGS_MANDATOR +
		'&password=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_MANDATOR_PASSWORD) +
		'&participantId=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_PARTICIPANT) + 
		'&callID=' + encodeURIComponent(callId) +
		'&version=' + encodeURIComponent(mirageOpenCTISettings.VERSION));*/
	switch (action.Perform) {
		case mirageOpenCTISettings.ICDC_ACTION_DIALINGCALL:
			action.Perform = mirageOpenCTISettings.ICDC_ACTION_DIALINGCALL_ACK;
			break;
		case mirageOpenCTISettings.ICDC_ACTION_ANSWERCALL:
			action.Perform = mirageOpenCTISettings.ICDC_ACTION_ANSWERCALL_ACK;
			break;
		case mirageOpenCTISettings.ICDC_ACTION_TRANSFERCALL:
			action.Perform = mirageOpenCTISettings.ICDC_ACTION_TRANSFERCALL_ACK;
			break;
		case mirageOpenCTISettings.ICDC_ACTION_HOLDCALL:
			action.Perform = mirageOpenCTISettings.ICDC_ACTION_HOLDCALL_ACK;
			break;
		case mirageOpenCTISettings.ICDC_ACTION_HANGUPCALL:
			action.Perform = mirageOpenCTISettings.ICDC_ACTION_HANGUPCALL_ACK;
			break;
		case mirageOpenCTISettings.ICDC_ACTION_DIALINGCALL_ACK:
		case mirageOpenCTISettings.ICDC_ACTION_ANSWERCALL_ACK:
		case mirageOpenCTISettings.ICDC_ACTION_TRANSFERCALL_ACK:
		case mirageOpenCTISettings.ICDC_ACTION_HOLDCALL_ACK:
		case mirageOpenCTISettings.ICDC_ACTION_HANGUPCALL_ACK:
			break;
	}
	mirageTools.setLocalStorageObject(mirageOpenCTISettings.STORAGEKEY_STATUSOBJECT, openCTIObject);
};
CDCInterface.prototype.Dial = function (number, line, objectId, objectName, object) {
	if (number) {
		if (!objectId) {
			objectId = '';
		}
		this.DoCall('Dial', 'mandator=' + mirageOpenCTISettings.ADAPTER_SETTINGS_MANDATOR +
			'&password=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_MANDATOR_PASSWORD) +
			'&participantId=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_PARTICIPANT) + 
			'&number=' + encodeURIComponent(PrepareNumberForDial(number, line)) + 
			'&objectId=' + encodeURIComponent(objectId) +
			'&objectName=' + encodeURIComponent(objectName) +
			'&objectType=' + encodeURIComponent(object) +
			'&version=' + encodeURIComponent(mirageOpenCTISettings.VERSION));
	}
	else {
		mirageLogger.LogWarn('CDCInterface.Dial called without number');
	}
};
CDCInterface.prototype.RefreshSettings = function () {
	this.DoCall('RefreshSettings', 'mandator=' + mirageOpenCTISettings.ADAPTER_SETTINGS_MANDATOR +
		'&password=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_MANDATOR_PASSWORD) +
		'&participantId=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_PARTICIPANT) +
		'&version=' + encodeURIComponent(mirageOpenCTISettings.VERSION));
};
CDCInterface.prototype.Terminate = function (callId) {
	if (callId) {
		this.DoCall('Terminate', 'mandator=' + mirageOpenCTISettings.ADAPTER_SETTINGS_MANDATOR +
			'&password=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_MANDATOR_PASSWORD) +
			'&participantId=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_PARTICIPANT) + 
			'&callID=' + encodeURIComponent(callId) +
			'&version=' + encodeURIComponent(mirageOpenCTISettings.VERSION));
	}
	else {
		mirageLogger.LogWarn('CDCInterface.Terminate called without callId');
	}
};
CDCInterface.prototype.DoCall = function (url, data, tries) {
	try {
		var obj = this;
		if (typeof tries == 'undefined') { var tries = 0; }
		
		if (!this.processActionResponse) {
			if (tries <= mirageOpenCTISettings.ICDC_MAXERRONEOUSREQUESTS) {
				$.ajax({
					type:			'GET',
					url: 			mirageOpenCTISettings.ADAPTER_SETTINGS_OPENCTI_SERVICE_URL + url,
					crossDomain:	true,
				  	dataType:		'jsonp',
				  	jsonpCallback:	'Do' + url + tries + 'Callback',
				  	async:			false,
				  	data: 			data
				})
				.done(function (resData, status, jqXHR) {
					try {
						obj.processActionResponse = true;
						//mirageLogger.LogDebug('CDCInterface.DoCallCallback returns: ' + status);
						tries = 0;
						/* MK 2014-07-15 gibt bool zurück
						obj.ProcessCDCResponse(resData, status);*/
						if (resData.result) {
							//ok
						}
						else{
							mirageLogger.LogWarn('CDCInterface.DoCallCallback for ' + url + ' failed, try again!');
							tries++;
							obj.processActionResponse = false;//MK 2015-04-27
							
							if (url != 'Dial') {
								obj.DoCall(url, data, tries);
							}
						}
					}
					catch (e) {
						mirageLogger.LogError('CDCInterface.DoCallCallback for ' + url + ' caused an exception:', e);
					}
					finally {
						obj.processActionResponse = false;
					}
				})
				.fail(function (jqXHR, status, error) {
					try {
						mirageLogger.LogWarn('CDCInterface.DoCallFailCallback for ' + url + ' returns: ' + status + ' - ' + error);
						
						tries++;
						obj.DoCall(url, data, tries);
					}
					catch (e) {
						mirageLogger.LogError('CDCInterface.DoCallFailCallback for ' + url + ' caused an exception:', e);
					}
				});
			}
			else {
				mirageLogger.LogError('CDCInterface.DoCall for ' + url + ' maximum number of calls reached: ' + url);
			}
		}
		else {
			setTimeout(function(){obj.DoCall(url, data, tries);}, mirageOpenCTISettings.ICDC_DOCALLRETRYINTERVALINMILLISECONDS);
		}
	}
	catch (e) {
		mirageLogger.LogError('CDCInterface.DoCall for ' + url + ' caused an exception:', e);
	}
};