var openCTILastActions = '';
function OpenCTIObject_Worker() {
	this.emptyWSActions = 0;
}

OpenCTIObject_Worker.prototype.CallById = function (callId) {
	try {
		if ((typeof callId != 'undefined') &&
			(callId != '')) {
			if ((openCTIObject != null) &&
				(openCTIObject.Actions != null)) {
				for (var i=0; i<openCTIObject.Actions.length; i++) {
					if (openCTIObject.Actions[i].Call.CallId == callId) {
						return openCTIObject.Actions[i].Call;
					}
				}
			}

			if (callHistory != null) {
				/* MK 2015-02-18 wenn mehrere Calls mit gleicher CallID kommen, gibt es Probleme
				for (var i=0; i<callHistory.length; i++) {*/
				for (var i=callHistory.length-1; i>=0; i--) {
					if (callHistory[i].CallId == callId) {
						return callHistory[i];
					}
				}
			}
		}
		return null;
	}
	catch (e) {
		return null;
	}
};
OpenCTIObject_Worker.prototype.IsCallHistoricised = function (call) {
	try {
		if (callHistory != null) {
			for (var i=0; i<callHistory.length; i++) {
				if (callHistory[i].CallId == call.CallId) {
					return true;
				}
			}
		}
		return false;
	}
	catch (e) {
		return false;
	}
};
OpenCTIObject_Worker.prototype.getActionForCall = function (call) {
	if (call) {
		return this.getActionForCallId(call.CallId);
	}
	return null;
};
OpenCTIObject_Worker.prototype.getActionForCallId = function (callId, useHist) {
	if (callId) {
		for (var i=0;i<openCTIObject.Actions.length;i++) {
			if (callId == openCTIObject.Actions[i].Call.CallId) {
				return openCTIObject.Actions[i];
			}
		}

		if ((useHist) &&
			(callHistory != null)) {
			for (var i=callHistory.length-1; i>=0; i--) {
				if (callHistory[i].CallId == callId) {
					var action = new OpenCTIObject_Action();
					action.Perform = 51;
					action.Call = callHistory[i];
					return action;
				}
			}
		}
	}
	return null;
};
OpenCTIObject_Worker.prototype.AssignStatusObject = function (object, data, fromOtherTab) {
	try {
		if (!object) {
			object = new OpenCTIObject();
		}
		if (data) {
			if ((data.Head) &&
				(data.Head.Version) &&
				((!object.Head) ||
				(!object.Head.Version) ||
				(object.Head.Version != data.Head.Version))) {
				try {
					//check version
					var versionParts = data.Head.Version.split('.');
					if ((parseInt(versionParts[0]) >= 5) &&
						(parseInt(versionParts[1]) >= 2)) {
						//ok
					}
					else {
						setTimeout(function () {
							softphoneModel.Hint('wrongversion', 'webservice', '5.2');
							openCTIInterface.StopRequesting();
						}, 2000);
					}
				}
				catch (e) {}
			}
			object.Head = data.Head;
			if (data.Head.OCTISettings) {
				if (data.Head.OCTISettings.OCTIVersion) {
					object.Head.OCTIVersion = data.Head.OCTISettings.OCTIVersion;
				}
			}
			
			var actionsString = JSON.stringify(data.Actions);
			if (((openCTILastActions == '') ||
				(openCTILastActions == '[]') ||
				(actionsString != openCTILastActions)) &&
				(actionsString) &&
				(actionsString != '[]')) {
				this.emptyWSActions = 0;
				openCTILastActions = actionsString;
				//object.ActionsChanged = true;
				if ((data.Actions) &&
					(data.Actions.length > 0)) {
					for (var da=0; da<data.Actions.length; da++) {
						if ((!data.Actions[da].Call.CallId) ||
							(data.Actions[da].Call.CallId == "0") ||
							(data.Actions[da].Call.CallId == "-1")) {
							mirageLogger.LogDebug('OpenCTIObject_Worker.AssignStatusObject: Ignore call with no CallId.');
							continue;//next iteration
						}
						var found = false;
						var action = this.getActionForCallId(data.Actions[da].Call.CallId, fromOtherTab);
						if (action != null) {
							found = true;
							//actions are differing too often because action.Perform differs a lot: 20 vs 21 vs 20 vs 21 ...
							//compare duration seperatly to avoid assigning an object just because duration changes
							if ((data.Actions[da].Call.Duration) &&
								(action.Call.Duration < data.Actions[da].Call.Duration)) {
								action.Call.Duration = data.Actions[da].Call.Duration;
							}
							var currString = JSON.stringify(action.Call);
							var newString = JSON.stringify(data.Actions[da].Call);
							if ((currString == newString) ||
								((action.Call.Subject) &&
								(!data.Actions[da].Call.Subject))) {
								//just action.Perform changed or old status
								if ((parseInt(action.Perform) != parseInt(data.Actions[da].Perform)+1) && //already acknowledged
									(parseInt(action.Perform) != parseInt(data.Actions[da].Perform)) && //same
									(parseInt(action.Perform) != parseInt(data.Actions[da].Perform)-1)) { //acknowledged but old one from other tab
									object.ActionsChanged = true;
									action.Perform = data.Actions[da].Perform;
								}
								//mirageLogger.LogDebug('OpenCTIObject_Worker.AssignStatusObject: call data of ' + action.Call.CallId + ' has not changed');
							}
							else {
								mirageLogger.LogDebug('OpenCTIObject_Worker.AssignStatusObject: assign call ' + action.Call.CallId);
								this.AssignAction(object, action, data.Actions[da], fromOtherTab);
							}
							break;//prevents from showing waiting calls
						}
						if (!found) {
							object.ActionsChanged = true;
							if (!object.Actions) {
								object.Actions = new Array();
							}
							/* parse data
							object.Actions.push(data.Actions[da]);*/
							var action = new OpenCTIObject_Action();
							/*for (var ba=0; ba<object.ActionBin.length; ba++) {
								if (object.ActionBin[ba].Call.CallId == data.Actions[da].Call.CallId) {
									action = object.ActionBin[ba];
									object.ActionBin.splice(ba,1);
								}
							}*/
							this.AssignAction(object, action, data.Actions[da], fromOtherTab, true);
							mirageLogger.LogInfo('OpenCTIObject_Worker.AssignStatusObject: add call: ' + action.Call.CallId);
							if (action.Call.CallerNumber) {
								mirageLogger.LogDebug('OpenCTIObject_Worker.AssignStatusObject: added call caller number: ' + action.Call.CallerNumber.Number);
							}
							if (action.Call.DialedNumber) {
								mirageLogger.LogDebug('OpenCTIObject_Worker.AssignStatusObject: added call dialed number: ' + action.Call.DialedNumber.Number);
							}
							object.Actions.push(action);
						}
					}
					//remove
					for (var oa=0; oa<object.Actions.length; oa++) {
						var found = false;
						for (var da=0; da<data.Actions.length; da++) {
							if (data.Actions[da].Call.CallId == object.Actions[oa].Call.CallId) {
								found = true;
								break;
							}
						}
						if (!found) {
							var removed = object.Actions.splice(oa,1);
							mirageLogger.LogDebug('OpenCTIObject_Worker.AssignStatusObject: remove call: ' + removed[0].Call.CallId);
							this.HistoriciseCall(removed[0].Call, true);
						}
					}
				}
				else {
					for (var oa=0; oa<object.Actions.length; oa++) {
						var removed = object.Actions.splice(oa,1);
						mirageLogger.LogDebug('OpenCTIObject_Worker.AssignStatusObject: remove call: ' + removed[0].Call.CallId);
						this.HistoriciseCall(removed[0].Call, true);
					}
					//clear actions
					//object.Actions.length = 0;
				}
			}
			else {
				//mirageLogger.LogDebug('OpenCTIObject_Worker.AssignStatusObject: nothing changed');
				if ((!actionsString) ||
					(actionsString == '[]')) {
					this.emptyWSActions++;
					
					if (this.emptyWSActions >= 10) {
						this.emptyWSActions = 0;
						if (softphoneModel.IsOnCall()) {
							mirageLogger.LogDebug('OpenCTIObject_Worker.AssignStatusObject end active call due to no call data was sent from web service');
							var call = openCTIObjectWorker.CallById(softphoneModel.HiddenCallId().val());
							softphoneController.OnCallEnd(call);
							this.HistoriciseCall(call, false);
						}
					}
				}
			}
		}
		else{
			//no data
		}
	}
	catch (e) {
		mirageLogger.LogError('OpenCTIObject_Worker.AssignStatusObject caused an exception:', e);
	}
};
OpenCTIObject_Worker.prototype.AssignAction = function (object, objectAction, dataAction, fromOtherTab, added) {
	if ((parseInt(objectAction.Perform) != parseInt(dataAction.Perform)+1) && //already acknowledged
		(parseInt(objectAction.Perform) != parseInt(dataAction.Perform)) && //same
		(parseInt(objectAction.Perform) != parseInt(dataAction.Perform)-1)) { //acknowledged but old one from other tab
		object.ActionsChanged = true;
		objectAction.Perform = dataAction.Perform;
	}
	objectAction.Call.CallId = dataAction.Call.CallId;
	if (dataAction.Call.CallerNumber) {
		if (!objectAction.Call.CallerNumber) {
			objectAction.Call.CallerNumber = new OpenCTIObject_Number();
		}
		if ((objectAction.Call.CallerNumber.LocalNumber) && 
			(objectAction.Call.CallerNumber.LocalNumber != dataAction.Call.CallerNumber.LocalNumber)) {
			objectAction.Call.CallerNumber.NumberChanged = true;
		}
		if (dataAction.Call.CallerNumber.CountryCode) {
			objectAction.Call.CallerNumber.CountryCode = dataAction.Call.CallerNumber.CountryCode.toString().onlyNumeric();
		}
		else {
			objectAction.Call.CallerNumber.CountryCode = '';
		}
		if (dataAction.Call.CallerNumber.AreaCode) {
			objectAction.Call.CallerNumber.AreaCode = dataAction.Call.CallerNumber.AreaCode.toString().onlyNumeric();
		}
		else {
			objectAction.Call.CallerNumber.AreaCode = '';
		}
		if (dataAction.Call.CallerNumber.LocalNumber) {
			objectAction.Call.CallerNumber.LocalNumber = dataAction.Call.CallerNumber.LocalNumber.toString().onlyNumeric();
		}
		else {
			objectAction.Call.CallerNumber.LocalNumber = '';
		}
		if (dataAction.Call.CallerNumber.Number) {
			objectAction.Call.CallerNumber.Number = dataAction.Call.CallerNumber.Number.trim();
		}
		else {
			dataAction.Call.CallerNumber.Number = '';
		}
		this.FillFormatedNumbers(objectAction.Call, added);
	}
	if (dataAction.Call.DialedNumber) {
		if (!objectAction.Call.DialedNumber) {
			objectAction.Call.DialedNumber = new OpenCTIObject_Number();
		}
		if ((objectAction.Call.DialedNumber.LocalNumber) &&
			(objectAction.Call.DialedNumber.LocalNumber != dataAction.Call.DialedNumber.LocalNumber)) {
			objectAction.Call.DialedNumber.NumberChanged = true;
		}
		if (dataAction.Call.DialedNumber.CountryCode) {
			objectAction.Call.DialedNumber.CountryCode = dataAction.Call.DialedNumber.CountryCode.toString().onlyNumeric();
		}
		else {
			objectAction.Call.DialedNumber.CountryCode = '';
		}
		if (dataAction.Call.DialedNumber.AreaCode) {
			objectAction.Call.DialedNumber.AreaCode = dataAction.Call.DialedNumber.AreaCode.toString().onlyNumeric();
		}
		else {
			objectAction.Call.DialedNumber.AreaCode = '';
		}
		if (dataAction.Call.DialedNumber.LocalNumber) {
			objectAction.Call.DialedNumber.LocalNumber = dataAction.Call.DialedNumber.LocalNumber.toString().onlyNumeric();
		}
		else {
			objectAction.Call.DialedNumber.LocalNumber = '';
		}
		if (dataAction.Call.DialedNumber.Number) {
			objectAction.Call.DialedNumber.Number = dataAction.Call.DialedNumber.Number.trim();
		}
		else {
			objectAction.Call.DialedNumber.Number = '';
		}
		this.FillFormatedNumbers(objectAction.Call, added);
	}
	if (dataAction.Call.DialedSFNumber) {
		dataAction.Call.DialedSFNumber = this.RemoveLine(dataAction.Call.DialedSFNumber);
		
		objectAction.Call.DialedSFNumber = dataAction.Call.DialedSFNumber;
		objectAction.Call.DialedNumber.Number = dataAction.Call.DialedSFNumber;
	}
	objectAction.Call.CallDirection = dataAction.Call.CallDirection;
	objectAction.Call.IsOnTransfer = dataAction.Call.IsOnTransfer;
	objectAction.Call.IsOnOneStepTransfer = dataAction.Call.IsOnOneStepTransfer;
	objectAction.Call.TransferedTo = dataAction.Call.TransferedTo;

	if (((added) ||
		(fromOtherTab)) &&
		(typeof dataAction.Call.WhoId != 'undefined')) {
		objectAction.Call.WhoId = dataAction.Call.WhoId;
		objectAction.Call.WhoName = dataAction.Call.WhoName;
		objectAction.Call.WhoType = dataAction.Call.WhoType;
	}
	if (((added) ||
		(fromOtherTab)) &&
		(typeof dataAction.Call.WhatId != 'undefined')) {
		objectAction.Call.WhatId = dataAction.Call.WhatId;
		objectAction.Call.WhatName = dataAction.Call.WhatName;
		objectAction.Call.WhatType = dataAction.Call.WhatType;
	}
	
	if (fromOtherTab) {
		if (dataAction.Call.ActivityId) {
			if ((objectAction.Call.ActivityId) &&
				(objectAction.Call.ActivityId != dataAction.Call.ActivityId)) {
				mirageLogger.LogDebug('OpenCTIObject_Worker.AssignAction: new task id for call ' + objectAction.Call.CallId + ' - ' + dataAction.Call.ActivityId + ' differs from previous' + objectAction.Call.ActivityId + '. Remove previous.');
				RemoveTask(objectAction.Call.ActivityId, '');
			}
			if (objectAction.Call.ActivityId != dataAction.Call.ActivityId) {
				mirageLogger.LogDebug('OpenCTIObject_Worker.AssignAction: new task id for call ' + objectAction.Call.CallId + ' is ' + dataAction.Call.ActivityId);
				var refresh = false;
				if (!objectAction.Call.ActivityId) {
					refresh = true;
				}
				objectAction.Call.ActivityId = dataAction.Call.ActivityId;
				if (refresh) {
					softphoneController.UpdateCallHistory();
				}
			}
		}
		if (dataAction.Call.CallInfo) { objectAction.Call.CallInfo = dataAction.Call.CallInfo; }
		if (typeof dataAction.Call.DoNotSave != 'undefined') { objectAction.Call.DoNotSave = dataAction.Call.DoNotSave; }
		if (typeof dataAction.Call.SFSearchDone != 'undefined') { objectAction.Call.SFSearchDone = dataAction.Call.SFSearchDone; }
		if (dataAction.Call.Subject) { objectAction.Call.Subject = dataAction.Call.Subject; }
		if (dataAction.Call.Comment) { objectAction.Call.Comment = dataAction.Call.Comment; }
		if (dataAction.Call.Disposition) { objectAction.Call.Disposition = dataAction.Call.Disposition; }
		if (typeof dataAction.Call.CallerText != 'undefined') { objectAction.Call.CallerText = dataAction.Call.CallerText; }
		if (typeof dataAction.Call.Historicised != 'undefined') { objectAction.Call.Historicised = dataAction.Call.Historicised; }//MK 2015-04-09
	}
	
	//params
	//set defaults (required for reset)
	objectAction.IsInternal = false;
	if (dataAction.Call.Params) {
		if (dataAction.Call.Params.IsInternal) {
			objectAction.IsInternal = IsStrYes(dataAction.Call.Params.IsInternal);
		}
	}
};
OpenCTIObject_Worker.prototype.AssignHistory = function (newHist) {
	mirageLogger.LogDebug('OpenCTIObject_Worker.AssignHistory called');
	var found = false;
	for (var n=0; n<newHist.length; n++) {
		found = false;
		for (var o=0; o<callHistory.length; o++) {
			if (callHistory[o].CallId == newHist[n].CallId) {
				found = true;
				if (newHist[n].ActivityId) {
					if ((callHistory[o].ActivityId) &&
						(callHistory[o].ActivityId != newHist[n].ActivityId)) {
						mirageLogger.LogDebug('OpenCTIObject_Worker.AssignHistory: new task id for call ' + callHistory[o].CallId + ' - ' + newHist[n].ActivityId + ' differs from previous' + callHistory[o].ActivityId + '. Remove previous.');
						RemoveTask(callHistory[o].ActivityId, '');
					}
					if (callHistory[o].ActivityId != newHist[n].ActivityId) {
						mirageLogger.LogDebug('OpenCTIObject_Worker.AssignHistory: new task id for call ' + callHistory[o].CallId + ' is ' + newHist[n].ActivityId);
						var refresh = false;
						if (!callHistory[o].ActivityId) {
							refresh = true;
						}
						callHistory[o].ActivityId = newHist[n].ActivityId;
						if (refresh) {
							softphoneController.UpdateCallHistory();
						}
					}
				}
				if (typeof newHist[n].DoNotSave != 'undefined') { callHistory[o].DoNotSave = newHist[n].DoNotSave; }
				if (newHist[n].Subject) { callHistory[o].Subject = newHist[n].Subject; }
				if (newHist[n].Comment) { callHistory[o].Comment = newHist[n].Comment; }
				if (newHist[n].Disposition) { callHistory[o].Disposition = newHist[n].Disposition; }
				if (typeof newHist[n].Historicised != 'undefined') { callHistory[o].Historicised = newHist[n].Historicised; }
				break;
			}
		}
		if (!found) {
			softphoneController.UpdateCallHistory(newHist[n]);
		}
	}
};
OpenCTIObject_Worker.prototype.RemoveLine = function (number) {
	try {
		number = number.toString();//removeStart is a string extension
		if (mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE1) {
			number = number.removeStart(mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE1);
		}
		if (mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE2) {
			number = number.removeStart(mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE2);
		}
		if (mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE3) {
			number = number.removeStart(mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE3);
		}
		if (mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE4) {
			number = number.removeStart(mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE4);
		}
		if (mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE5) {
			number = number.removeStart(mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE5);
		}
		if (mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE6) {
			number = number.removeStart(mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE6);
		}
		if (mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE7) {
			number = number.removeStart(mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE7);
		}
		if (mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE8) {
			number = number.removeStart(mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE8);
		}
		if (mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE9) {
			number = number.removeStart(mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE9);
		}
		if (mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE10) {
			number = number.removeStart(mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE10);
		}
		
		return number;
	}
	catch (e) {
		mirageLogger.LogError('OpenCTIObject_Worker.RemoveLine caused an exception:', e);
		return number;
	}
};
OpenCTIObject_Worker.prototype.TimeFromDateTime = function (date) {
	try {
		return date.substring(11, 16);
	}
	catch (e) {
		mirageLogger.LogError('OpenCTIObject_Worker.TimeFromDateTime caused an exception:', e);
		return '';
	}
};
OpenCTIObject_Worker.prototype.DateFromDateTime = function (date) {
	try {
		return date.substring(0, 10);
	}
	catch (e) {
		mirageLogger.LogError('OpenCTIObject_Worker.DateFromDateTime caused an exception:', e);
		return '';
	}
};
OpenCTIObject_Worker.prototype.getDateTimeString = function (date) {
	try {
		return date.replace('T', ' ');
	}
	catch (e) {
		mirageLogger.LogError('OpenCTIObject_Worker.getDateTimeString caused an exception:', e);
		return '';
	}
};
OpenCTIObject_Worker.prototype.HistoriciseCall = function (call, alreadyRemoved) {
	try {
		if (call) {
			mirageLogger.LogDebug('OpenCTIObject_Worker.HistoriciseCall called for: ' + call.CallId + ' - ' + call.Historicised);
			call.Historicised = true;
			var found = false;
			for (var i=0; i<callHistory.length; i++) {
				if (call.CallId == callHistory[i].CallId) {
					found = true;
					break;
				}
			}
			if (!found) {
				mirageLogger.LogInfo('OpenCTIObject_Worker.HistoriciseCall add call: ' + call.CallId);
				callHistory.push(call);
				
				//remove
				while (callHistory.length > mirageOpenCTISettings.ADAPTER_SETTINGS_HISTORY_LENGTH) {
					var removedItem = callHistory.shift();
					mirageLogger.LogDebug('SoftphoneController.HistoriciseCall remove call from history: ' + removedItem.CallId);
				}
				mirageTools.setLocalStorageObject(mirageOpenCTISettings.STORAGEKEY_CALLHISTORY, callHistory);
			}
			if (!alreadyRemoved) { this.RemoveActionByCallId(call.CallId); }
		}
		else {
			mirageLogger.LogWarn('OpenCTIObject_Worker.HistoriciseCall called without call object');
		}
	}
	catch (e) {
		mirageLogger.LogError('OpenCTIObject_Worker.HistoriciseCall caused an exception:', e);
		return '';
	}
};
OpenCTIObject_Worker.prototype.RemoveActionByCallId = function (callId) {
	if (callId) {
		for (var i=openCTIObject.Actions.length-1; i>=0; i--) {
			if (openCTIObject.Actions[i].Call.CallId == callId) {
				var removed = openCTIObject.Actions.splice(i,1);
				mirageLogger.LogDebug('OpenCTIObject_Worker.RemoveActionByCallId: remove call: ' + removed[0].Call.CallId);
				break;
			}
		}
	}
};
OpenCTIObject_Worker.prototype.FillFormatedNumbers = function (call, added) {
	var nrCountryCode = '';
	var nrAreaCode = '';
	var nrLocalNumber = '';
	var nrNumber = '';
    if (call.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_OUTGOING) {
    	nrCountryCode = call.DialedNumber.CountryCode;
    	nrAreaCode = call.DialedNumber.AreaCode;
    	nrLocalNumber = call.DialedNumber.LocalNumber;
    	nrNumber = call.DialedNumber.Number;
    }
    else {
    	nrCountryCode = call.CallerNumber.CountryCode;
    	nrAreaCode = call.CallerNumber.AreaCode;
    	nrLocalNumber = call.CallerNumber.LocalNumber;
    	nrNumber = call.CallerNumber.Number;
    }
    
    if (added) {
	    mirageLogger.LogDebug('OpenCTIObject_Worker.FillFormatedNumbers with ADAPTER_SETTINGS_COUNTRY_CODE ' + mirageOpenCTISettings.ADAPTER_SETTINGS_COUNTRY_CODE +
	    		' and ADAPTER_SETTINGS_LONGDIST_PREFIX: ' + mirageOpenCTISettings.ADAPTER_SETTINGS_LONGDIST_PREFIX +
	    		' and ADAPTER_SETTINGS_INTERNATIONAL_PREFIX: ' + mirageOpenCTISettings.ADAPTER_SETTINGS_INTERNATIONAL_PREFIX +
	    		' and country code: ' + nrCountryCode + 
	    		' and area code: ' + nrAreaCode +
	    		' and local number: ' + nrLocalNumber);
    }
	
	var nr1 = getFormat1(mirageOpenCTISettings.ADAPTER_SETTINGS_INTERNATIONAL_PREFIX,
		nrCountryCode,
		nrAreaCode,
		nrLocalNumber);
	var nr2 = getFormat2(nrCountryCode,
		nrAreaCode,
		nrLocalNumber);
	var nr3 = getFormat3(mirageOpenCTISettings.ADAPTER_SETTINGS_COUNTRY_CODE,
		mirageOpenCTISettings.ADAPTER_SETTINGS_LONGDIST_PREFIX,
		mirageOpenCTISettings.ADAPTER_SETTINGS_INTERNATIONAL_PREFIX,
		nrCountryCode,
		nrAreaCode,
		nrLocalNumber);
	var nr4 = getFormat4(mirageOpenCTISettings.ADAPTER_SETTINGS_LONGDIST_PREFIX,
		mirageOpenCTISettings.ADAPTER_SETTINGS_INTERNATIONAL_PREFIX,
		nrCountryCode,
		nrAreaCode,
		nrLocalNumber);
	var nr5 = getFormat5(mirageOpenCTISettings.ADAPTER_SETTINGS_LONGDIST_PREFIX,
		nrCountryCode,
		nrAreaCode,
		nrLocalNumber);
	
    if (call.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_OUTGOING) {
    	call.DialedNumber.FormatedNumbers = [nrNumber, nr1, nr2, nr3, nr4, nr5];
    }
    else {
    	call.CallerNumber.FormatedNumbers = [nrNumber, nr1, nr2, nr3, nr4, nr5];
    }
};
OpenCTIObject_Worker.prototype.MoveActionToTop = function (action) {
	openCTIObject.Actions.MoveTo(action, 0);
};
OpenCTIObject_Worker.prototype.GenerateMirageCallId = function (call) {
    var callId = new Array();
    callId.push(call.CallId);
	if (call.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_OUTGOING) {
		callId.push(call.DialedNumber.Number.onlyNumeric());
	}
	else {
		callId.push(call.CallerNumber.Number.onlyNumeric());
	}
	/* MK 2015-04-13
	callId.push(mirageTools.getDateTimeForCallID());*/
	var cson = call.CallStart.onlyNumeric();
	if (cson) {
		callId.push(cson.substr(0,cson.length-2));
	}
	else {
		callId.push(mirageTools.getDateTimeForCallID());
	}
	callId.push(softphoneModel.HiddenSFUsername().val().split('@')[0]);
	return callId.join('-');
};