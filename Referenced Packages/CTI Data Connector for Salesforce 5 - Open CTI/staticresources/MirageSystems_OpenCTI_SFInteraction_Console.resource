OpenCTISFInteraction.prototype.UseInteractionLog = function () {
	return (this.isInConsole) && (mirageOpenCTISettings.ADAPTER_SETTINGS_CONSOLE_USEINTERACTIONLOG);
};
OpenCTISFInteraction.prototype.IsCallActive = function (call, onActiveCallback, onInactiveCallback) {
	try {
		if (this.UseInteractionLog()) {
			mirageLogger.LogDebug('OpenCTISFInteraction.IsCallActive called for ' + call.CallId);
			var idscallback = function (response) {
				if ((response.ids) &&
					(response.ids != 'null') &&
					(response.ids.indexOf(call.CallId) != -1)) {
					mirageLogger.LogDebug('OpenCTISFInteraction.IsCallActive call ' + call.CallId + ' is active');
					if (onActiveCallback) { onActiveCallback(); }
				}
				else {
					mirageLogger.LogDebug('OpenCTISFInteraction.IsCallActive call ' + call.CallId + ' is inactive');
					if (onInactiveCallback) { onInactiveCallback(); }
				}
	        };
	
	        sforce.console.cti.getCallObjectIds(idscallback);
		}
	}
	catch (e) {
		mirageLogger.LogError('OpenCTISFInteraction.IsCallActive caused an exception:', e);
	}
};
OpenCTISFInteraction.prototype.OnBeginCall = function (call) {
	try {
		if (this.UseInteractionLog()) {
			mirageLogger.LogDebug('OpenCTISFInteraction.OnBeginCall called for ' + call.CallId);
			var onInactiveCallback = function () {
				var callType;
				var number;
				if (call.IsInternal) {
			    	callType = 'Internal';
			    	if (call.CallerNumber) {
				    	number = call.CallerNumber.Number;
			    	}
			    	else {
				    	number = call.DialedNumber.Number;
			    	}
				}
				else if (call.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_OUTGOING) {
			    	callType = 'Outbound';
			    	number = call.DialedNumber.Number;
			    }
			    else {
			    	callType = 'Inbound';
			    	number = call.CallerNumber.Number;
			    }
			    var callback = function (response) {
			    	if (response) {
			    		mirageLogger.LogDebug('OpenCTISFInteraction.OnBeginCall api response ' + response.success);
			    		
			    		/*//Test - responseData.success war false, evtl. weil keine daten gesetzt wurden
		                var callbackData = function (responseData) {
		                	if ((responseData) &&
		                		(responseData.success)) {
		                		var data = responseData.data;
		                		var obj = $.parseJSON(data);
		                	}
		                };
			    		sforce.console.cti.getCallAttachedData(call.CallId, callbackData);*/
			    	}
			    };
				//sforce.console.cti.fireOnCallBegin(call.CallId, callType, call.Subject, callback);
				sforce.console.cti.fireOnCallBegin(call.CallId, callType, number, callback);
			};
			this.IsCallActive(call, null, onInactiveCallback);
		}
	}
	catch (e) {
		mirageLogger.LogError('OpenCTISFInteraction.OnBeginCall caused an exception:', e);
	}
};
OpenCTISFInteraction.prototype.OnEndCall = function (call) {
	try {
		if (this.UseInteractionLog()) {
			mirageLogger.LogDebug('OpenCTISFInteraction.OnEndCall called for ' + call.CallId);
			var onActiveCallback = function () {
			    var callback = function (response) {
			    	if (response) {
			    		mirageLogger.LogDebug('OpenCTISFInteraction.OnEndCall api response ' + response.success);
			    	}
			    };
				sforce.console.cti.fireOnCallEnd(call.CallId, call.Duration, call.Disposition, callback);
			};
			this.IsCallActive(call, onActiveCallback, null);
		}
	}
	catch (e) {
		mirageLogger.LogError('OpenCTISFInteraction.OnEndCall caused an exception:', e);
	}
};
OpenCTISFInteraction.prototype.InitConsole = function () {
	try {
		var onCallLogSaved = function (result) {
			if (result) {
				mirageLogger.LogDebug('OpenCTISFInteraction.onCallLogSaved called for task id: ' + result.id);
				var call = openCTIObjectWorker.CallById(softphoneModel.HiddenCallId().val());
				if (!call) {
					call = openCTIObjectWorker.CallById(softphoneModel.HiddenCallWrapUpCallId().val());
				}
				if (call) {
					mirageLogger.LogDebug('OpenCTISFInteraction.onCallLogSaved assign task id ' + result.id + ' to call ' + call.CallId);
					if (call.ActivityId != result.id) {
						//interaction log saved own task, delete the softphone one
						RemoveTask(call.ActivityId, '');
					}
					call.ActivityId = result.id;
					softphoneController.SaveCallObject(call);
					softphoneController.SaveCall(call, false, false, null, true);

					//close after wrapup was selected and IL was saved
					if ((call.CallEnd) && (call.Disposition)) {
						softphoneController.CloseWrapUp();
					}
				}
			}
		};
        sforce.console.cti.onCallLogSaved(onCallLogSaved);
        

        var callback = function (result) {
        	mirageLogger.LogDebug('OpenCTISFInteraction.onCallLogSaved sendCTIMessage API sent the following message: ' + result.message);
        };

        sforce.console.cti.onSendCTIMessage(callback);
	}
	catch (e) {
		mirageLogger.LogError('OpenCTISFInteraction.InitConsole caused an exception:', e);
	}
};
OpenCTISFInteraction.prototype.OnIncomingCall = function () {
	try {
		if (this.isInConsole) {
			mirageLogger.LogDebug('OpenCTISFInteraction.OnIncomingCall called');
			var poppedOutCallback = function (response) {
				if ((response.success) &&
					(!response.poppedOut)) {
					sforce.console.setCustomConsoleComponentVisible(true);
				}
			};
			sforce.console.isCustomConsoleComponentPoppedOut(poppedOutCallback);
		}
	}
	catch (e) {
		mirageLogger.LogError('OpenCTISFInteraction.OnIncomingCall caused an exception:', e);
	}
};