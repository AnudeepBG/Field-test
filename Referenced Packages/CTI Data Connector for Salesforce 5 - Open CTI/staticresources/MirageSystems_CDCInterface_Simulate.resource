CDCInterface.prototype.Simulate_IncomingCall = function (val) {
	try {
		mirageLogger.LogDebug('CDCInterface.IncomingCall called with:' + val);
		$.ajax({
			type:			'GET',
			url: 			mirageOpenCTISettings.ADAPTER_SETTINGS_OPENCTI_SERVICE_URL + 'Simulate_IncomingCall',
		  	cache:			false,
		  	dataType:		'jsonp',
			crossDomain:	true,
			jsonpCallback:	'Simulate_IncomingCallCallback',
			data:			'number=' + val
		})
		.done(function (data, status, jqXHR) {
		})
		.fail(function (jqXHR, status, error) {
			mirageLogger.LogError('CDCInterface.IncomingCall ajax failed with status ' + status + ' and error ' + error);
		});
	}
	catch (e) {
		alert(e);
		mirageLogger.LogError('CDCInterface.IncomingCall caused an exception:', e);
	}
};
CDCInterface.prototype.Simulate_HangUp = function (val) {
	try {
		mirageLogger.LogDebug('CDCInterface.HangUp called with:' + val);
		$.ajax({
			type:			'GET',
			url: 			mirageOpenCTISettings.ADAPTER_SETTINGS_OPENCTI_SERVICE_URL + 'Simulate_HangUp',
		  	cache:			false,
		  	dataType:		'jsonp',
			crossDomain:	true,
			jsonpCallback:	'Simulate_HangUpCallback',
			data:			'number=' + val
		})
		.done(function (data, status, jqXHR) {
		})
		.fail(function (jqXHR, status, error) {
			mirageLogger.LogError('CDCInterface.HangUp ajax failed with status ' + status + ' and error ' + error);
		});
	}
	catch (e) {
		alert(e);
		mirageLogger.LogError('CDCInterface.HangUp caused an exception:', e);
	}
};
CDCInterface.prototype.WCFTest2 = function (controlId) {
	try {
		mirageLogger.LogDebug('CDCInterface.WCFTest2 called');
		var obj = this;
		$.ajax({
			type:			'GET',
			url: 			mirageOpenCTISettings.ADAPTER_SETTINGS_OPENCTI_SERVICE_URL + 'TestCall2'
		})
		.done(function (data) {
			$('#' + controlId).val(data);
		})
		.fail(function (jqXHR, status, error) {
			$('#' + controlId).val(status + ' - ' + error + ' - ' + jqXHR);
		});
	}
	catch (e) {
		alert(e);
		mirageLogger.LogError('CDCInterface.WCFTest2 caused an exception:', e);
	}
};
CDCInterface.prototype.WCFTest3 = function (val, controlId) {
	try {
		mirageLogger.LogDebug('CDCInterface.WCFTest3 called with:' + val);
		var obj = this;
		$.ajax({
			type:			'GET',
			url: 			mirageOpenCTISettings.ADAPTER_SETTINGS_OPENCTI_SERVICE_URL + 'TestCall3',
		  	cache:			false,
		  	dataType:		'jsonp',
			data:			'value=' + val
		})
		.done(function (data) {
			$('#' + controlId).val(data);
		})
		.fail(function (jqXHR, status, error) {
			$('#' + controlId).val(status + ' - ' + error);
		});
	}
	catch (e) {
		alert(e);
		mirageLogger.LogError('CDCInterface.WCFTest3 caused an exception:', e);
	}
};
CDCInterface.prototype.WCFTest4 = function (val, controlId) {
	try {
		mirageLogger.LogDebug('CDCInterface.WCFTest4 called with:' + val);
		var obj = this;
		$.ajax({
			type:			'GET',
			url: 			mirageOpenCTISettings.ADAPTER_SETTINGS_OPENCTI_SERVICE_URL + 'TestCall4',
		  	cache:			false,
		  	crossDomain:	true,
		  	dataType:		'jsonp',
		  	jsonpCallback:	'WCFTest4Callback',
			data:			'callback=WCFTest4Callback&value=' + val
		})
		.done(function (data) {
			$('#' + controlId).val('done: ' + data);
			openCTIInterface.WCFTest4Callback(data);
		})
		.fail(function (jqXHR, status, error) {
			$('#' + controlId).val('fail: ' + status + ' - ' + error);
		});
	}
	catch (e) {
		alert(e);
		mirageLogger.LogError('CDCInterface.WCFTest4 caused an exception:', e);
	}
};
CDCInterface.prototype.WCFTest4Callback = function (data) {
	try {
		alert(2);
		alert(data.value);
	}
	catch (e) {
		mirageLogger.LogError('CDCInterface.WCFTest4 caused an exception:', e);
	}
};