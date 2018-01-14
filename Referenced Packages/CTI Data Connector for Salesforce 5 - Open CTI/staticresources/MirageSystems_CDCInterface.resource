//constructor
function CDCInterface() {
	this.numberOfRequests = 0;
	this.erroneousRequests = 0;
	this.nullResponses = 0;
	this.autoStartDueToNullResponses = 0;
	//this.isRequesting = false;
	this.requestInterval = null;
	this.checkInterval = null;
	this.username = '';
	this.processResponse = false;
	this.processActionResponse = false;
	this.connectionStateControl = null;
	//this.startControl = null;
	//this.stopControl = null;
	this.lastRequest = null;
}
//properties
CDCInterface.prototype.RequestInterval = function () {
	if ((typeof mirageOpenCTISettings != 'undefined') &&
		(typeof mirageOpenCTISettings.ADAPTER_SETTINGS_OPENCTI_WS_POLL_INTERVAL != 'undefined')) {
		return mirageOpenCTISettings.ADAPTER_SETTINGS_OPENCTI_WS_POLL_INTERVAL;
	}
	else {
		return 1000;
	}
};
CDCInterface.prototype.Username = function (name) {
	if (typeof name != 'undefined') {
		this.username = name;
		openCTIObject.Head.Username = this.username;
	}
	else {
		return this.username;
	}
};
CDCInterface.prototype.ConnectionStateControl = function (control) {
	if (typeof control != 'undefined') {
		this.connectionStateControl = control;
	}
	else {
		return this.connectionStateControl;
	}
};
/*CDCInterface.prototype.StopControl = function (control) {
	if (typeof control != 'undefined') {
		this.stopControl = control;
	}
	else {
		return this.stopControl;
	}
};
CDCInterface.prototype.StartControl = function (control) {
	if (typeof control != 'undefined') {
		this.startControl = control;
	}
	else {
		return this.startControl;
	}
};*/
//methods
CDCInterface.prototype.ParseJSON = function (json) {
	try {
		if (json) {
			if (json.lastRequest) {
				this.lastRequest = json.lastRequest;
			}
			if (json.username) {
				this.username = json.username;
			}
			this.numberOfRequests = json.numberOfRequests;
			this.erroneousRequests = json.erroneousRequests;
			this.nullResponses = json.nullResponses;
			this.autoStartDueToNullResponses = json.autoStartDueToNullResponses;
		}
	}
	catch (e) {
		mirageLogger.LogError('CDCInterface.StartRequesting caused an exception:', e);
	}
};
CDCInterface.prototype.StartRequesting = function (sendSettings, fromLS) {
	try {
		mirageLogger.LogInfo('CDCInterface.StartRequesting called with sendSettings=' + sendSettings);
		if (!fromLS) {
			mirageTools.setLocalStorageValue(mirageOpenCTISettings.STORAGEKEY_STARTREQUESTING, 'start');
		}
		//this.StartControl().hide();
		//this.StopControl().show();
		if ((this.erroneousRequests <= mirageOpenCTISettings.ICDC_MAXERRONEOUSREQUESTS) &&
			(this.nullResponses <= mirageOpenCTISettings.ICDC_MAXERRONEOUSREQUESTS)) {
			this.ConnectionStateControl().attr('state', mirageOpenCTISettings.ICDC_CONNECTIONSTATE_STARTED);
		}
		//don't start more than one interval, works even in a new tab
		//if (!this.isRequesting) {
		if (!this.requestInterval) {
			//this.isRequesting = true;
			this.numberOfRequests = 0;
			//this.erroneousRequests = 0;
			//this.nullResponses = 0;
			//this.autoStartDueToNullResponses = 0;
			var tmp = new CDCInterface();
			tmp.ParseJSON(this);
			mirageTools.setLocalStorageObject(mirageOpenCTISettings.STORAGEKEY_INTERFACE, tmp);//store isRequesting
			
			if (sendSettings) {
				mirageOpenCTISettings.SendSettings();
				this.MakeURLSwitchCall();
			}
			
			mirageLogger.LogInfo('CDCInterface.StartRequesting Start requesting webservice');
			this.requestInterval = setInterval((function(self) {
	        	return function() {
	            	self.MakeRequest();
	        	};
	    	})(this), this.RequestInterval());
    	}
		/* MK 2015-04-24 do nothing, openCTIObject is processed by tab sync
		else {
			mirageLogger.LogInfo('CDCInterface.StartRequesting Start checking for requests');
			if (!this.checkInterval) {
				this.checkInterval = setInterval((function(self) {
		        	return function() {
		        		try {
							//mirageLogger.LogInfo('check request: ' + new Date().getTime() + ' - ' + self.lastRequest + ' = ' + (new Date().getTime() - self.lastRequest) + ' vs ' + self.RequestInterval()*3);
							if (new Date().getTime() - self.lastRequest > self.RequestInterval()*3) {
								mirageLogger.LogInfo('CDCInterface.StartRequesting Requesting tab closed, start requesting');
								mirageTools.setLocalStorageValue(mirageOpenCTISettings.STORAGEKEY_LASTREQUEST, new Date().getTime());//prevent other tabs to start
								
								//self.isRequesting = false;
								self.StartRequesting(false, true);
								clearInterval(self.checkInterval);
								self.checkInterval = null;
							}
							else {
								openCTIObject = mirageTools.getLocalStorageObject(mirageOpenCTISettings.STORAGEKEY_STATUSOBJECT);
								softphoneController.ProcessCDCResponse(openCTIObject);
							}
						}
						catch (e) {
							mirageLogger.LogError('CDCInterface.StartRequesting_check caused an exception:', e);
						}
		        	};
		    	})(this), this.RequestInterval()*3);
			}
		}*/
	}
	catch (e) {
		mirageLogger.LogError('CDCInterface.StartRequesting caused an exception:', e);
	}
};
CDCInterface.prototype.StopRequesting = function (fromLS) {
	try {
		if (!fromLS) {
			mirageTools.setLocalStorageValue(mirageOpenCTISettings.STORAGEKEY_STOPREQUESTING, 'stop');
		}
		//if (this.isRequesting) {
			if (this.requestInterval) {
				clearInterval(this.requestInterval);
				this.requestInterval = null;
			}
			//this.isRequesting = false;
			mirageLogger.LogInfo('Requesting stopped!');
			var tmp = new CDCInterface();
			tmp.ParseJSON(this);
			mirageTools.setLocalStorageObject(mirageOpenCTISettings.STORAGEKEY_INTERFACE, tmp);//store isRequesting
		//}
		softphoneModel.setConnectionStateRed();
		this.ConnectionStateControl().attr('state', mirageOpenCTISettings.ICDC_CONNECTIONSTATE_STOPED);
	}
	catch (e) {
		mirageLogger.LogError('CDCInterface.StopRequesting caused an exception:', e);
	}
};
CDCInterface.prototype.MakeRequest = function () {
	try {
		var obj = this;
		if (!this.processResponse) {
			if (this.erroneousRequests > mirageOpenCTISettings.ICDC_MAXERRONEOUSREQUESTS) {
				this.StopRequesting();
				this.ConnectionStateControl().attr('state', mirageOpenCTISettings.ICDC_CONNECTIONSTATE_STOPED);
				softphoneModel.setConnectionStateRed();
			}
			else if (new Date().getTime() - this.lastRequest < this.RequestInterval()) {
				//mirageLogger.LogDebug('CDCInterface.MakeRequest request was already made in time, skip it: ' + new Date().getTime() + ' - ' +  this.lastRequest + ' < ' + this.RequestInterval());
			}
			else {
				try {
					this.lastRequest = new Date().getTime();
					mirageTools.setLocalStorageValue(mirageOpenCTISettings.STORAGEKEY_LASTREQUEST, this.lastRequest);
					var data = 'mandator=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_MANDATOR) +
							'&password=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_MANDATOR_PASSWORD) +
							'&participantId=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_PARTICIPANT) +
							'&version=' + encodeURIComponent(mirageOpenCTISettings.VERSION);
					$.ajax({
						type:			'GET',
						url: 			mirageOpenCTISettings.ADAPTER_SETTINGS_OPENCTI_SERVICE_URL + 'ReadStatus',
					  	crossDomain:	true,
					  	dataType:		'jsonp',
					  	jsonpCallback:	'MakeRequestCallback',
					  	data: 			data
					})
					.done(function (data, status, jqXHR) {
						try {
							obj.erroneousRequests = 0;
							//mirageLogger.LogDebug('CDCInterface.MakeRequestCallback returns: ' + status);
							/* MK 2015-04-27 depricated
							if (!obj.ConnectionStateControl().text().startsWith('connected')) {
								obj.ConnectionStateControl().attr('state', mirageOpenCTISettings.ICDC_CONNECTIONSTATE_STARTED);
								softphoneModel.setConnectionStateYellow();
							}*/
							
							obj.ProcessCDCResponse(data, status);
						}
						catch (e) {
							mirageLogger.LogError('CDCInterface.MakeRequestCallback caused an exception:', e);
						}
					})
					.fail(function (jqXHR, status, error) {
						try {
							mirageLogger.LogWarn('CDCInterface.MakeRequestFailCallback returns: ' + status + ' - ' + error + '. inc erroneous requests' + obj.erroneousRequests);
							
							obj.erroneousRequests++;//callback functions can't access 'this'
						}
						catch (e) {
							mirageLogger.LogError('CDCInterface.MakeRequestFailCallback caused an exception:', e);
						}
					});
				}
				catch(e) {
					mirageLogger.LogError('CDCInterface.MakeRequest caused an exception:', e);
				}
				finally {
					this.numberOfRequests++;
				}
			}
		}
		else {
			mirageLogger.LogInfo('CDCInterface.MakeRequest aborted because response is in progress!');
		}
	}
	catch (e) {
		mirageLogger.LogError('CDCInterface.MakeRequest caused an exception:', e);
		//alert(e);
	}
};
CDCInterface.prototype.ProcessCDCResponse = function (data, status) {
	try {
		if (status != 'success') {
			mirageLogger.LogWarn('ProcessCDCResponse called with status ' + status + ' and data ' + data + ' (type: ' + typeof data + ')');
		}
		this.processResponse = true;
		
		if (data == null) {
			mirageLogger.LogWarn('ProcessCDCResponse data is null!');
			this.nullResponses++;
			if (this.nullResponses > mirageOpenCTISettings.ICDC_MAXERRONEOUSREQUESTS) {
				mirageLogger.LogDebug('ProcessCDCResponse stop requesting!');
				this.StopRequesting();
				this.ConnectionStateControl().attr('state', mirageOpenCTISettings.ICDC_CONNECTIONSTATE_STOPED);
				softphoneModel.setConnectionStateRed();
				
				if ((mirageOpenCTISettings.ADAPTER_SETTINGS_AUTORECONNECT) &&
					(this.autoStartDueToNullResponses < 3)) {
					mirageLogger.LogDebug('ProcessCDCResponse restart requesting!');
					this.nullResponses = 0;
					this.autoStartDueToNullResponses++;
					setTimeout(function () {openCTIInterface.StartRequesting(true);}, this.RequestInterval()*2);
				}
			}
		}
		else {
			this.nullResponses = 0;
			this.autoStartDueToNullResponses = 0;
			openCTIObjectWorker.AssignStatusObject(openCTIObject, data);
			mirageTools.setLocalStorageObject(mirageOpenCTISettings.STORAGEKEY_STATUSOBJECT, openCTIObject);
			var tmp = new CDCInterface();
			tmp.ParseJSON(this);
			mirageTools.setLocalStorageObject(mirageOpenCTISettings.STORAGEKEY_INTERFACE, tmp);
			
			softphoneController.ProcessCDCResponse(openCTIObject, status);
		}
	}
	catch (e) {
		mirageLogger.LogError('CDCInterface.ProcessCDCResponse caused an exception:', e);
	}
	finally {
		this.processResponse = false;
	}
};
CDCInterface.prototype.MakeURLSwitchCall = function (settings) {
	try {
		var obj = this;

		mirageLogger.LogDebug('CDCInterface.MakeURLSwitchCall performs request');
		
		//send settings
		var data = 'participantId=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_PARTICIPANT) + 
				'&adr=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_OPENCTI_SERVICE_URL) +
				'&version=' + encodeURIComponent(mirageOpenCTISettings.VERSION);
		
		$.ajax({
			type:			'GET',
			url: 			'https://miragecloud1.com/MirageSwitch/MirageSwitch.asmx/StAd',
		  	crossDomain:	true,
		  	dataType:		'jsonp',
		  	jsonpCallback:	'StAdCallback',
		  	data: 			data
		})
		.done(function (data, status, jqXHR) {
			try {
				//obj.erroneousRequests = 0;
				mirageLogger.LogDebug('CDCInterface.MakeURLSwitchCallCallback returns: ' + status);
			}
			catch (e) {
				mirageLogger.LogError('CDCInterface.MakeURLSwitchCallCallback caused an exception:', e);
			}
		})
		.fail(function (jqXHR, status, error) {
			try {
				mirageLogger.LogWarn('CDCInterface.MakeURLSwitchCallFailCallback returns: ' + status + ' - ' + error);
				
				//obj.erroneousRequests++;//callback functions can't access 'this'
			}
			catch (e) {
				mirageLogger.LogError('CDCInterface.MakeURLSwitchCallFailCallback caused an exception:', e);
			}
		});
	}
	catch (e) {
		mirageLogger.LogError('CDCInterface.MakeURLSwitchCall caused an exception:', e);
	}
};
CDCInterface.prototype.SendSettings = function (settings) {
	try {
		var obj = this;

		mirageLogger.LogDebug('CDCInterface.SendSettings performs request');
		
		//send settings
		var data = 'mandator=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_MANDATOR) +
				'&password=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_MANDATOR_PASSWORD) +
				'&participantId=' + encodeURIComponent(mirageOpenCTISettings.ADAPTER_SETTINGS_PARTICIPANT) + 
				'&settings=' + encodeURIComponent(JSON.stringify(settings)) +
				'&version=' + encodeURIComponent(mirageOpenCTISettings.VERSION);
		
		mirageOpenCTISettings.SETTINGSLASTSENT = new Date().getTime();
		$.ajax({
			type:			'GET',
			url: 			mirageOpenCTISettings.ADAPTER_SETTINGS_OPENCTI_SERVICE_URL + 'UpdateSettings',
		  	crossDomain:	true,
		  	dataType:		'jsonp',
		  	jsonpCallback:	'SendSettingsCallback',
		  	data: 			data
		})
		.done(function (data, status, jqXHR) {
			try {
				//obj.erroneousRequests = 0;
				mirageLogger.LogDebug('CDCInterface.SendSettingsCallback returns: ' + status);
				
				obj.RefreshSettings();
			}
			catch (e) {
				mirageLogger.LogError('CDCInterface.SendSettingsCallback caused an exception:', e);
			}
		})
		.fail(function (jqXHR, status, error) {
			try {
				mirageLogger.LogWarn('CDCInterface.SendSettingsFailCallback returns: ' + status + ' - ' + error);
				
				//obj.erroneousRequests++;//callback functions can't access 'this'
			}
			catch (e) {
				mirageLogger.LogError('CDCInterface.SendSettingsFailCallback caused an exception:', e);
			}
		});
	}
	catch (e) {
		mirageLogger.LogError('CDCInterface.SendSettings caused an exception:', e);
		//alert(e);
	}
};
function InterfaceError(error) {
	try {
		//alert(error);
		mirageLogger.LogError('CDCInterface.InterfaceError called with:' + error);
	}
	catch (e) {
		//alert(e);
		mirageLogger.LogError('CDCInterface.InterfaceError caused an exception:', e);
	}
}