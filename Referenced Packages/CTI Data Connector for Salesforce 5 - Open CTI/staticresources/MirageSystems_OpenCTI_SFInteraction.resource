var whoIdPrefixes = new Array('003', '00q');
var whatIdPrefixes = new Array('001', '006', '500', '701');
var readInfoPrefixes = new Array('001', '003', '00q');
		    
function OpenCTISFInteraction(){
	clickToDialEnabled = false;
	isInConsole = false;
	softphoneLayout = null;//layout description: http://www.salesforce.com/us/developer/docs/api_cti/Content/sforce_api_cti_getsoftphonelayout.htm
	softphoneLayoutString = '';
}
OpenCTISFInteraction.prototype.getCallerName = function (call) {
	try {
		if (call) {
			mirageLogger.LogDebug('OpenCTISFInteraction.getCallerName for call: ' + call.CallId);
			if (call.CallerText) {
				return call.CallerText;
			}
			else if ((call.WhoId) &&
				(call.WhoId.substr(0,3).toLowerCase() == '003')) {
				return call.WhoName;
			}
			else if ((call.WhatId) &&
				(call.WhatId.substr(0,3).toLowerCase() == '001')) {
				return call.WhatName;
			}
		}
		return '';
	}
	catch (e) {
		mirageLogger.LogError('OpenCTISFInteraction.getCallerName caused an exception:', e);
	}
};
OpenCTISFInteraction.prototype.getTypeOfId = function (id) {
	if (id.substr(0,3) == '003') {
		return 'Contact';
	}
	else if (id.substr(0,3) == '00Q') {
		return 'Lead';
	}
	else if (id.substr(0,3) == '001') {
		return 'Account';
	}
	else if (id.substr(0,3) == '006') {
		return 'Opportunity';
	}
	else if (id.substr(0,3) == '500') {
		return 'Case';
	}
	else if (id.substr(0,3) == '701') {
		return 'Campaign';
	}
	else if (id.substr(0,3) == '00T') {
		return 'Task';
	}
	return '';
};
OpenCTISFInteraction.prototype.getCallerType = function (call) {
	try {
		if (call) {
			mirageLogger.LogDebug('OpenCTISFInteraction.getCallerType for call: ' + call.CallId);
			if (call.WhoId) {
				return this.getTypeOfId(call.WhoId);
			}
			else if (call.WhatId) {
				return this.getTypeOfId(call.WhatId);
			}
		}
		return '';
	}
	catch (e) {
		mirageLogger.LogError('OpenCTISFInteraction.getCallerType caused an exception:', e);
	}
};
OpenCTISFInteraction.prototype.AssignObject = function (id, name, call, callback, useCurrentPage) {
	try {
		if ((id) && (name) && (call)) {
			mirageLogger.LogDebug('OpenCTISFInteraction.AssignObject for id: ' + id + ' name: ' + name + ' call: ' + call.CallId);
		    //001->account
		    //003->contact
		    //00Q->lead
		    //006->opportunity
		    //500->cases
		    //701->campaign
		    if ($.inArray(id.substr(0,3).toLowerCase(), whoIdPrefixes) >= 0) {
		        call.WhoId = id;
		        call.WhoName = name;
		        call.WhoType = this.getTypeOfId(id); 
		        call.CallerText = '';
				//this.ReadCallerInfo(call, callback);
		    }
		    else if ($.inArray(id.substr(0,3).toLowerCase(), whatIdPrefixes) >= 0) {
		        call.WhatId = id;
		        call.WhatName = name;
		        call.WhatType = this.getTypeOfId(id);
				call.CallerText = '';
				//this.ReadCallerInfo(call, callback);
		    }
		    else	{
	        	mirageLogger.LogWarn('Unable to assign id ' + id + ': unsupported type.');
		    }
		    /* some objects prevent task from beeing saved
		    else  {
		        call.WhatId = id;
		        call.WhatName = name;
		        call.WhatType = this.getTypeOfId(id); 
				call.CallerText = '';
				//this.ReadCallerInfo(call, callback);
		    }*/

		    if ($.inArray(id.substr(0,3).toLowerCase(), readInfoPrefixes) >= 0) {
				this.ReadCallerInfo(call, callback);
		    }
		    else {
		    	if (callback) {
		    		callback();
		    	}
		    }
	    }
	    else if ((call) && (useCurrentPage)) {
			mirageLogger.LogDebug('OpenCTISFInteraction.AssignObject use current page for id: ' + id);
			var self = this;
			var tmp = call.CallId;
			var assignCallback = function(response) {
				var tmpCall = openCTIObjectWorker.CallById(tmp);
				if (response.result) {
				    var obj = JSON.parse(response.result);
				    if ((obj.objectId) && (obj.objectName)) {
				    	self.AssignObject(obj.objectId, obj.objectName, tmpCall, callback, false);
				    }
				    else {
				    	if (callback) {
				    		callback();
				    	}
				    }
				}
				else {
		        	mirageLogger.LogError('Unable to AssignObject! ' + response.error);
				}
			};
		    sforce.interaction.getPageInfo(assignCallback);
	    }
	    else {
        	mirageLogger.LogError('Unable to AssignObject: no call data available');
	    }
	}
	catch (e) {
		mirageLogger.LogError('OpenCTISFInteraction.AssignObject caused an exception:', e);
	}
};
OpenCTISFInteraction.prototype.ClearIdsIfNec = function (call) {
	//removes information for IDs that are not allowed i.e. Task as WhatId
    if ((call.WhoId) &&
    	($.inArray(call.WhoId.substr(0,3).toLowerCase(), whoIdPrefixes) == -1)) {
		mirageLogger.LogDebug('OpenCTISFInteraction.ClearIdsIfNec clear not allowed WhoId: ' + call.WhoId);
        call.WhoId = '';
        call.WhoName = '';
        call.WhoType = '';
        call.CallerText = '';
    }
    if ((call.WhatId) &&
    	($.inArray(call.WhatId.substr(0,3).toLowerCase(), whatIdPrefixes) == -1)) {
		mirageLogger.LogDebug('OpenCTISFInteraction.ClearIdsIfNec clear not allowed WhatId: ' + call.WhatId);
        call.WhatId = '';
        call.WhatName = '';
        call.WhatType = '';
		call.CallerText = '';
    }
};
OpenCTISFInteraction.prototype.CurrentPage_ObjectId = function (callback) {
	var readid = function(response) {
	    var obj = JSON.parse(response.result);
		callback(obj.objectId);
	};
    sforce.interaction.getPageInfo(readid);
};
OpenCTISFInteraction.prototype.OpenObjectIfNec = function (id) {
	try {
		if (id) {
			mirageLogger.LogDebug('OpenCTISFInteraction.OpenObjectIfNec for id: ' + id);
			var checkifequal = function(currId) {
				if (id == currId) {
					//object is already open
				}
				else {
					//sforce.interaction.searchAndScreenPop(id, '');
					if (mirageTools.GetIEVersion() == 11) {
						top.location.href = '/' + id;
					}
					else {
						sforce.interaction.screenPop('/'+id, true, '');
					}
				}
			};
			this.CurrentPage_ObjectId(checkifequal);
		}
		else {
			mirageLogger.LogWarn('OpenCTISFInteraction.OpenObjectIfNec no id specified.');
		}
	}
	catch (e) {
		mirageLogger.LogError('OpenCTISFInteraction.OpenObjectIfNec caused an exception:', e);
	}
};
OpenCTISFInteraction.prototype.SaveObject = function (call, callback) {
	if (mirageTools.IsTaskSaveLocked(call.CallId)) {
		mirageLogger.LogWarn('Task save for ' + call.CallId + ' is locked from other tab!');
		if (callback) { callback(); }
	}
	else {
		try {
			if (!call.Subject) {
				mirageLogger.LogDebug('OpenCTISFInteraction.SaveObject for call ' + call.CallId + ' denied due to no subject');
			}
			else {
				mirageLogger.LogDebug('OpenCTISFInteraction.SaveObject for call: ' + call.CallId);
			    var timeStamp = new Date().toString();
			    timeStamp = timeStamp.substring(0, timeStamp.lastIndexOf(':') + 3);
			    
			    var dueDate;
			    if (call.CallStart) {
			    	dueDate = call.CallStart.substr(0,10);
			    }
			    else {
				    var currentDate = new Date();
				    var currentDay = currentDate.getDate();
				    var currentMonth = currentDate.getMonth()+1;
				    var currentYear = currentDate.getFullYear();
			    	dueDate = currentYear+ '-' + currentMonth + '-' + currentDay;
			    }
			    
			    var saveParams = new Array();
			    saveParams.push('ActivityDate=' + dueDate);
			    if(call.Disposition) {
			        saveParams.push('CallDisposition=' + call.Disposition);
			    }
			    
			    var callDuration = -1;
			    if ((call.AnsweredAt) && (call.CallEnd)) {
			    	var start = new Date(call.AnsweredAt.replace(' ','T'));
			    	var end = new Date(call.CallEnd.replace(' ','T'));
			    	
			    	callDuration = (end - start) / 1000;
			    }
			    else if (typeof call.Duration != 'undefined') {
			    	callDuration = parseInt(call.Duration);
			    }
			    if (callDuration > -1) {
			    	saveParams.push('CallDurationInSeconds=' + callDuration);
			    }
			    
			    //saveParams += '&CallObject=' + NAMEOFCALLCENTER;
			    if (call.IsInternal) {
			    	saveParams.push('CallType=Internal');
			    }
			    else if (call.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_INCOMING) {
			    	saveParams.push('CallType=Inbound');
			    }
			    else {
			    	saveParams.push('CallType=Outbound');
			    }
			    //saveParams += '&IsClosed=true';isclosed is not writable
			    //saveParams += '&IsVisibleInSelfService=false';
			    if (softphoneModel.HiddenSFUserId().val()) {
			    	saveParams.push('OwnerId=' + softphoneModel.HiddenSFUserId().val());
			    }
			    /* MK 2015-05-06 check implemented
			    saveParams.push('Priority=' + mirageOpenCTISettings.SALESFORCE_DEFAULT_PRIORITY);
			    saveParams.push('Status=' + mirageOpenCTISettings.SALESFORCE_STATUS_COMPLETED);*/
			    if ((mirageOpenCTISettings.SALESFORCE_DEFAULT_PRIORITY) &&
			    	(mirageOpenCTISettings.SALESFORCE_DEFAULT_PRIORITY.toString().toLowerCase() != 'undefined')) {
				    saveParams.push('Priority=' + mirageOpenCTISettings.SALESFORCE_DEFAULT_PRIORITY);
			    }
			    if ((mirageOpenCTISettings.SALESFORCE_STATUS_COMPLETED) &&
			    	(mirageOpenCTISettings.SALESFORCE_STATUS_COMPLETED.toString().toLowerCase() != 'undefined')) {
				    saveParams.push('Status=' + mirageOpenCTISettings.SALESFORCE_STATUS_COMPLETED);
			    }
			    
			    if (call.Subject) {
			    	saveParams.push('Subject=' + call.Subject.HTMLEncode());
			    }
			    var whatIdPrefixes = new Array('001', '006', '500', '701');
				if ((call.WhatId) &&
					($.inArray(call.WhatId.substr(0,3).toLowerCase(), whatIdPrefixes) >= 0)) {
			    	saveParams.push('WhatId=' + call.WhatId);
			    }
				else if (!call.WhatId) {//assignment removed
			    	saveParams.push('WhatId=');
				}
			    var whoIdPrefixes = new Array('003', '00q');
			    if ((call.WhoId) &&
			    	($.inArray(call.WhoId.substr(0,3).toLowerCase(), whoIdPrefixes) >= 0)) {
			    	saveParams.push('WhoId=' + call.WhoId);
			    }
				else if (!call.WhoId) {//assignment removed
			    	saveParams.push('WhoId=');
				}
			    if (call.ActivityId) {
			    	saveParams.push('Id=' + call.ActivityId);
			    }
			    if ((mirageOpenCTISettings.ADAPTER_SETTINGS_CALLER_FIELD) &&
			    	(call.CallerNumber) &&
			    	(call.CallerNumber.Number)) {
			    	saveParams.push(mirageOpenCTISettings.ADAPTER_SETTINGS_CALLER_FIELD + '=' + call.CallerNumber.Number.HTMLEncode());
			    }
			    if ((mirageOpenCTISettings.ADAPTER_SETTINGS_CALLED_FIELD) &&
			    	(call.DialedNumber) &&
			    	(call.DialedNumber.Number)) {
			    	saveParams.push(mirageOpenCTISettings.ADAPTER_SETTINGS_CALLED_FIELD + '=' + call.DialedNumber.Number.HTMLEncode());
			    }
		    	saveParams.push('Mirage__Mirage_Call_ID__c=' + openCTIObjectWorker.GenerateMirageCallId(call));
		    	//MK 2015-04-20 set description to the end of the save parameter list because if it contains unsupported char every information after it will be ignored
			    if (call.Comment) {
			    	saveParams.push('Description=' + call.Comment.HTMLEncode());
			    }
			    
			    var query = saveParams.join('&');
				mirageLogger.LogInfo('OpenCTISFInteraction.SaveObject do save for: ' + query);

				sforce.interaction.saveLog('Task', query, callback);
			}
	    }
	    catch (e) {
			mirageLogger.LogError('OpenCTISFInteraction.SaveObject caused an exception:', e);
	    }
		finally {
			//unlock it here just in case something goes wrong. its unlocked faster in callback
			setTimeout(function(){mirageTools.OpenTaskSave(call.CallId);}, 10000);
		}
	}
};
OpenCTISFInteraction.prototype.ClickToDial = function (info) {
	try {
		mirageLogger.LogDebug('OpenCTISFInteraction.ClickToDial called');
		if (info.result) {
			var clickToDialInfo = JSON.parse(info.result);
			var name = '';
			if (softphoneModel.IsOnCall()) {
				softphoneModel.ShowTransfer(clickToDialInfo.number);
			}
			else {
				if ((clickToDialInfo.objectName) &&
					(clickToDialInfo.objectName != 'null')) {//null comes as string from SF
					name = clickToDialInfo.objectName;
				}
				if (clickToDialInfo.object.toLowerCase() == 'lead') {
					var idx = clickToDialInfo.objectName.indexOf(', ');
					if (idx > -1) {
						name = clickToDialInfo.objectName.substr(0, idx);
					}
				}
				mirageLogger.LogDebug('OpenCTISFInteraction.ClickToDial called for ' + clickToDialInfo.number + ' - ' + clickToDialInfo.objectId + ' - ' + name + ' - ' + clickToDialInfo.object);
				openCTIInterface.Dial(clickToDialInfo.number, softphoneModel.DropDownListLines().val(), clickToDialInfo.objectId, name, clickToDialInfo.object);
			}
		}
		else {
			mirageLogger.LogError('Unable to read click to dial info! ' + info.error);
	    }
	}
	catch (e) {
		mirageLogger.LogError('OpenCTISFInteraction.ClickToDial caused an exception:', e);
	}
};
OpenCTISFInteraction.prototype.EnableClickToDial = function () {
	try {
		var obj = this;
		var callbackenable = function (response) {
	        if (response.result) {
	        	obj.clickToDialEnabled = true;
				sforce.interaction.cti.onClickToDial(obj.ClickToDial);
	        }
	        else {
	        	obj.clickToDialEnabled = false;
	        	mirageLogger.LogError('Unable to enable click to dial! ' + response.error);
	        }
	    };
		//Invokes API method
		sforce.interaction.cti.enableClickToDial(callbackenable);
	}
	catch (e) {
		mirageLogger.LogError('OpenCTISFInteraction.EnableClickToDial caused an exception:', e);
	}
};
OpenCTISFInteraction.prototype.AutoSize = function () {
	sforce.interaction.cti.setSoftphoneHeight(parseInt($('#mirageSystemsOpenCTI').height())+15);
};
OpenCTISFInteraction.prototype.InitSoftphone = function (width, height, callback) {
	try {
		this.EnableClickToDial();
		this.LoadLayout();
		var obj = this;
		sforce.interaction.isInConsole(function(response){
	    	obj.isInConsole = response.result;
	    	if (obj.isInConsole) {
	    		sforce.interaction.cti.setSoftphoneWidth(210);
	    	}
	    	else {
			    /*sforce.interaction.cti.setSoftphoneWidth(width);
			    sforce.interaction.cti.setSoftphoneHeight(height);*/
	    	}
	    	//mirageTools.setLocalStorageObject(mirageOpenCTISettings.STORAGEKEY_SFINTERFACE, obj);
	    	callback();
	    });
		this.InitConsole();
	}
	catch (e) {
		mirageLogger.LogError('OpenCTISFInteraction.InitSoftphone caused an exception:', e);
	}
};
OpenCTISFInteraction.prototype.OpenNewLead = function (call) {
	try {
		if (call) {
			mirageLogger.LogDebug('OpenCTISFInteraction.OpenNewLead for call: ' + call.CallId);
			if (call.CallerNumber) {
				if (mirageTools.GetIEVersion() == 11) {
					top.location.href = '/00Q/e?lea8=' + encodeURIComponent(call.CallerNumber.Number);
				}
				else {
					sforce.interaction.screenPop('/00Q/e?lea8=' + encodeURIComponent(call.CallerNumber.Number), true, '');
				}
			}
			else if (call.DialedNumber) {
				if (mirageTools.GetIEVersion() == 11) {
					top.location.href = '/00Q/e?lea8=' + encodeURIComponent(call.DialedNumber.Number);
				}
				else {
					sforce.interaction.screenPop('/00Q/e?lea8=' + encodeURIComponent(call.DialedNumber.Number), true, '');
				}
			}
			else {
	        	mirageLogger.LogError('OpenCTISFInteraction.OpenNewLead can\'t proceed: no number information is available');
			}
		}
		else {
        	mirageLogger.LogError('OpenCTISFInteraction.OpenNewLead can\'t proceed: no call information is available');
		}
	}
	catch (e) {
		mirageLogger.LogError('OpenCTISFInteraction.OpenNewLead caused an exception:', e);
	}
};
OpenCTISFInteraction.prototype.OpenObject = function (objectId) {
	try {
		if (objectId) {
			if (mirageTools.GetIEVersion() == 11) {
				top.location.href = '/' + objectId;
			}
			else {
				sforce.interaction.screenPop('/' + objectId, true, '');
			}
		}
		else {
        	mirageLogger.LogError('OpenCTISFInteraction.OpenTaskInEditMode can\'t proceed: no taskId is specified');
		}
	}
	catch (e) {
		mirageLogger.LogError('OpenCTISFInteraction.OpenTaskInEditMode caused an exception:', e);
	}
};
OpenCTISFInteraction.prototype.OpenTaskInEditMode = function (taskId) {
	try {
		if (taskId) {
			var url = '/' + taskId + '/e?retURL=%2F' + taskId;
			if (mirageTools.GetIEVersion() == 11) {
				top.location.href = url;
			}
			else {
				sforce.interaction.screenPop(url, true, '');
			}
		}
		else {
        	mirageLogger.LogError('OpenCTISFInteraction.OpenTaskInEditMode can\'t proceed: no taskId is specified');
		}
	}
	catch (e) {
		mirageLogger.LogError('OpenCTISFInteraction.OpenTaskInEditMode caused an exception:', e);
	}
};
OpenCTISFInteraction.prototype.ParseJSON = function (obj) {
	this.clickToDialEnabled = obj.clickToDialEnabled;
	this.isInConsole = obj.isInConsole;
	this.softphoneLayoutString = obj.softphoneLayoutString;
	this.softphoneLayout = JSON.parse(this.softphoneLayoutString);
};
OpenCTISFInteraction.prototype.LoadLayout = function () {
	try {
		if (!this.softphoneLayout) {
			var obj = this;
			var callback = function (response) {
				if (response.result) {
					obj.softphoneLayoutString = response.result;
					obj.softphoneLayout = JSON.parse(obj.softphoneLayoutString);
				}
				else{
					mirageLogger.LogError('Unable to enable click to dial: ' + response.error);
		    	}
			};
			// Calls getSoftphoneLayout
			sforce.interaction.cti.getSoftphoneLayout(callback);
		}
	}
	catch (e) {
		mirageLogger.LogError('OpenCTISFInteraction.LoadLayout caused an exception:', e);
	}
};
OpenCTISFInteraction.prototype.Search = function (call, callback) {
	try {
		mirageLogger.LogDebug('OpenCTISFInteraction.Search for call: ' + call.CallId);
	    //var callType = '';
	    var layoutObject = null;
		var nrs = new Array();
		var nr = '';
	    if (call.IsInternal) {
	    	//callType = 'Internal';
	    	layoutObject = this.softphoneLayout.Internal;
	    	nrs = call.CallerNumber.FormatedNumbers;
	    	nr = call.CallerNumber.Number;
	    }
	    else if (call.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_OUTGOING) {
	    	//callType = 'Outbound';
	    	layoutObject = this.softphoneLayout.Outbound;
	    	nrs = call.DialedNumber.FormatedNumbers;
	    	nr = call.DialedNumber.Number;
	    }
	    else {
	    	//callType = 'Inbound';
	    	layoutObject = this.softphoneLayout.Inbound;
	    	nrs = call.CallerNumber.FormatedNumbers;
	    	nr = call.CallerNumber.Number;
	    }
	    
		var searchVal = new Array();
		//searchVal.push(call.CallerNumber.Number);
		if ((nrs) &&
			(nrs.length > 0)) {
			for (var i=0; i<nrs.length; i++) {
				if ($.inArray(nrs[i], searchVal) == -1) {
					searchVal.push(nrs[i]);
				}
				else {
					//already in query
				}
			}
		}
		else {
			searchVal.push(nr);
		}
		var query = searchVal.join(' or ');
		var tmp = query;

		mirageLogger.LogDebug('OpenCTISFInteraction.Search for: ' + query);
		NumberSearch(call.CallId, query);
		
	    //searchAndScreenPop: searchParam max length = 80
		/*while (query.length > 80) {
			query = query.substr(0, query.lastIndexOf(' or '));
		}
		if (tmp != query) {
			mirageLogger.LogWarn('OpenCTISFInteraction.Search query truncated: ' + tmp.substr(query.length));
		}

		mirageLogger.LogDebug('OpenCTISFInteraction.Search for: ' + query);
		if (query) {
			if (!call.IsWaiting) {
				sforce.interaction.searchAndScreenPop(query, '', callType, callback);
			}
			else {
				sforce.interaction.searchAndGetScreenPopUrl(query, '', callType, callback);
			}
		}*/
	}
	catch (e) {
		mirageLogger.LogError('OpenCTISFInteraction.Search caused an exception:', e);
	}
};
OpenCTISFInteraction.prototype.DoSearchAndScreenPop = function (call, query, callType, callback) {
	if (mirageTools.IsSearchAPILocked(call.CallId)) {
		mirageLogger.LogWarn('Search API for ' + call.CallId + ' is locked from other tab!');
	}
	else {
		try {
			var params = new Array();
			var number;
			if (call.CallerNumber) {
				number = encodeURIComponent(call.CallerNumber.Number);
			}
			else if (call.DialedNumber) {
				number = encodeURIComponent(call.DialedNumber.Number);
			}
			if (number) {
				params.push('lea8=' + number);
				params.push('con10=' + number);
				params.push('acc10=' + number);
				params.push('cas9=' + number);
				params.push('tsk8=' + number);
			}
			sforce.interaction.searchAndScreenPop(query, params.join('&'), callType, callback);
		}
		catch (e) {
			mirageLogger.LogError('OpenCTISFInteraction.DoSearchAndScreenPop caused an exception:', e);
		}
		finally {
			setTimeout(function(){mirageTools.OpenSearchAPI(call.CallId);}, 1000);
		}
	}
};
OpenCTISFInteraction.prototype.NumberSearch = function (call, query, callback) {
	try {
		mirageLogger.LogDebug('OpenCTISFInteraction.NumberSearch for call ' + call.CallId + ': ' + query);
		//if (query) {
			var callType = '';
		    if (call.IsInternal) {
		    	callType = 'Internal';
		    }
		    else if (call.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_OUTGOING) {
		    	callType = 'Outbound';
		    }
		    else {
		    	callType = 'Inbound';
		    }
			if (!call.IsWaiting) {
				mirageTools.LockSearchAPI(call.CallId);//prevent other tab from saving if both refresh at the same time
				var obj = this;
				setTimeout(function(){obj.DoSearchAndScreenPop(call, query, callType, callback);}, 500);
			}
			else {
				sforce.interaction.searchAndGetScreenPopUrl(query, '', callType, callback);
			}
		//}
	}
	catch (e) {
		mirageLogger.LogError('OpenCTISFInteraction.NumberSearch caused an exception:', e);
	}
};
OpenCTISFInteraction.prototype.FillCallerInfo = function (call, sfobject, id, assign) {
	try {
		mirageLogger.LogDebug('OpenCTISFInteraction.FillCallerInfo for call: ' + call.CallId);
		var layoutObject = null;
		if (call.IsInternal) {
			layoutObject = this.softphoneLayout.Internal;
		}
		else if (call.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_OUTGOING) {
			layoutObject = this.softphoneLayout.Outbound;
		}
		else {
			layoutObject = this.softphoneLayout.Inbound;
		}
		
		var fields = layoutObject.objects[sfobject.object];
		if (fields) {
			var callerText = '';
			call.CallInfo = new Array();
			for (var i = 0; i<fields.length; i++) {
				var tmp = sfobject[fields[i].apiName];
				if (tmp) {
					mirageLogger.LogDebug('OpenCTISFInteraction.FillCallerInfo add info ' + fields[i].displayName + ' (' + fields[i].apiName + '): ' + tmp);
					if (fields[i].apiName.toLowerCase() == 'name') {
						call.CallerText = tmp;
					}
					else {
						call.CallInfo.push({key: fields[i].displayName, value: tmp});
					}
				}
				else {
					mirageLogger.LogDebug('OpenCTISFInteraction.FillCallerInfo layout definition ' + fields[i].displayName + ' (' + fields[i].apiName + ') not found in search response info');
				}
			}
			if (assign) {
				this.AssignObject(id, call.CallerText, call, false);
			}
			else {
				//update text
				if (call.WhoId == id) {
					call.WhoName = call.CallerText;
				}
				else if (call.WhatId == id) {
					call.WhatName = call.CallerText;
				}
			}
			mirageTools.setLocalStorageObject(mirageOpenCTISettings.STORAGEKEY_CALLERINFO, call);
			softphoneController.SaveCallObject(call);
		}
		else {
			mirageLogger.LogError('OpenCTISFInteraction.FillCallerInfo no field defs found!');
		}
	}
	catch (e) {
		mirageLogger.LogError('OpenCTISFInteraction.FillCallerInfo caused an exception:', e);
	}
};
OpenCTISFInteraction.prototype.InitializationComplete = function () {
	try {
		sforce.interaction.cti.notifyInitializationComplete();
	}
	catch (e) {
		mirageLogger.LogError('OpenCTISFInteraction.InitializationComplete caused an exception:', e);
	}
};
OpenCTISFInteraction.prototype.ReadCallerInfo = function (call, callback) {
	try {
		var obj = this;
		var objectId;
		var objectName;
		var objectType;
		if (call.WhoId) {
			objectId = call.WhoId;
			objectName = call.WhoName;
			objectType = call.WhoType;
		}
		else if (call.WhatId) {
			objectId = call.WhatId;
			objectName = call.WhatName;
			objectType = call.WhatType;
		}
		mirageLogger.LogDebug('OpenCTISFInteraction.ReadCallerInfo for call: ' + call.CallId + ', id: ' + objectId + ', name: ' + objectName + ', type: ' + objectType);
		
		//only search for name if the id is from the object
		//if dialing from an account page, the id is from the account and the name from the contact
		if ((objectName) &&
			(objectType) &&
			(objectType.toLowerCase() != 'case') &&
			(this.getTypeOfId(objectId).toLowerCase() == objectType.toLowerCase())) {
			var tmp = call.CallId;
			var searchCallback = function (response) {
				try {
					if (response.result) {
						try {
							var res = $.parseJSON(response.result);
							var size = Object.size(res);
							var key;
							var tmpCall = openCTIObjectWorker.CallById(tmp);
							for (key in res) {
								//ID sometimes comes with a suffix, i.e.: contact id in task is '%CONTACTID%IAR'
								//if (key == objectId) {
								if (objectId.startsWith(key)) {
									//generate text from result data
									if (objectId.length > key.length) {
									    if ($.inArray(objectId.substr(0,3).toLowerCase(), whoIdPrefixes) >= 0) {
									    	tmpCall.WhoId = key;
									    }
									    else if ($.inArray(objectId.substr(0,3).toLowerCase(), whatIdPrefixes) >= 0) {
									    	tmpCall.WhatId = key;
									    }
									}
									obj.FillCallerInfo(tmpCall, res[key], key, false);
								}
								else {
									continue;
								}
							}
							if (callback) {
								callback();
							}
						}
						catch (e) {
							mirageLogger.LogError('SoftphoneController.ReadCallerInfo error creating caller text:', e);
						}
					}
					else {
						mirageLogger.LogError('Error in ReadCallerInfo: ' + response.error);
					}
				}
				catch (e) {
					mirageLogger.LogError('Error in ReadCallerInfo: ', e);
				}
			};
		
			var search = objectName;
			var callType = '';
			if (call.IsInternal) {
				callType = 'internal';
			}
			else if (call.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_OUTGOING) {
				callType = 'outbound';
				search += ' and ' + call.DialedSFNumber;
			}
			else {
				callType = 'inbound';
			}
			
			sforce.interaction.searchAndGetScreenPopUrl(search, '', callType, searchCallback);
		}
		else if (objectId) {
			if (!objectName) {
				objectName = objectType;
			}
			
			if (objectType.toLowerCase() != 'case') {
				this.AssignObject(objectId, objectName, call);
			}
			ReadInfo(objectId, objectName, objectType, call.CallId);
		}
	}
	catch (e) {
		mirageLogger.LogError('OpenCTISFInteraction.ReadCallerInfo caused an exception:', e);
	}
};