var localStorageCurrentTab = new Array();

function MirageTools(){
	this.iEVersion = -1;
}

MirageTools.prototype.getDateTime = function () {
	try {
	    var now     = new Date(); 
	    var year    = now.getFullYear();
	    var month   = now.getMonth()+1; 
	    var day     = now.getDate();
	    var hour    = now.getHours();
	    var minute  = now.getMinutes();
	    var second  = now.getSeconds(); 
	    if(month.toString().length == 1) {
	        month = '0'+month;
	    }
	    if(day.toString().length == 1) {
	        var day = '0'+day;
	    }   
	    if(hour.toString().length == 1) {
	        var hour = '0'+hour;
	    }
	    if(minute.toString().length == 1) {
	        var minute = '0'+minute;
	    }
	    if(second.toString().length == 1) {
	        var second = '0'+second;
	    }   
	    var dateTime = year+'-'+month+'-'+day+' '+hour+':'+minute+':'+second;
	    return dateTime;
    }
    catch (e) {
    	return 'YYYY-MM-DD HH:MM:SS';
    }
};
MirageTools.prototype.getDateTimeForCallID = function () {
	try {
	    var now     = new Date(); 
	    var year    = now.getFullYear();
	    var month   = now.getMonth()+1; 
	    var day     = now.getDate();
	    var hour    = now.getHours();
	    var minute  = now.getMinutes();

	    if(month.toString().length == 1) {
	        month = '0'+month;
	    }
	    if(day.toString().length == 1) {
	        day = '0'+day;
	    }
	    if(hour.toString().length == 1) {
	        hour = '0'+hour;
	    }
	    if(minute.toString().length == 1) {
	        var minute = '0'+minute;
	    }
	    var dateTime = year+month+day+hour+minute;
	    return dateTime;
    }
    catch (e) {
    	return null;
    }
};
MirageTools.prototype.getDate = function () {
	try {
	    var now     = new Date(); 
	    var year    = now.getFullYear();
	    var month   = now.getMonth()+1; 
	    var day     = now.getDate();
	    if(month.toString().length == 1) {
	        month = '0'+month;
	    }
	    if(day.toString().length == 1) {
	        var day = '0'+day;
	    }
	    var dateTime = year+'-'+month+'-'+day;
	    return dateTime;
    }
    catch (e) {
    	return 'YYYY-MM-DD';
    }
};
// Local storage persistence 
MirageTools.prototype.setLocalStorageValue = function (key,value){
	try {
		//if ($.inArray(key, localStorageCurrentTab) == -1) {
			localStorageCurrentTab.push(key);
    	//}
		
		localStorage.setItem(key, value);
	}
	catch (e) {
		mirageLogger.LogError('MirageTools.setLocalStorageValue(' + key + ') caused an exception:', e);
	}
};
MirageTools.prototype.getLocalStorageValue = function getLocalStorageValue(name){
	try {
		return localStorage.getItem(name);
	}
	catch (e) {
		mirageLogger.LogError('MirageTools.getLocalStorageValue(' + key + ') caused an exception:', e);
		return null;
	}
};
MirageTools.prototype.setLocalStorageObject = function (key, value) {
	try {
		this.setLocalStorageValue(key, JSON.stringify(value));
	}
	catch (e) {
		mirageLogger.LogError('MirageTools.setLocalStorageObject(' + key + ') caused an exception:', e);
	}
};
MirageTools.prototype.getLocalStorageObject = function (key) {
	try {
	    var value = this.getLocalStorageValue(key);
	    return value && JSON.parse(value);
	}
	catch (e) {
		mirageLogger.LogError('MirageTools.getLocalStorageObject(' + key + ') caused an exception:', e);
		return null;
	}
};
MirageTools.prototype.removeLocalStorage = function () {
	try {
		mirageLogger.LogDebug('MirageTools.removeLocalStorage called');
		localStorage.removeItem(mirageOpenCTISettings.STORAGEKEY_INTERFACE);
		localStorage.removeItem(mirageOpenCTISettings.STORAGEKEY_CONTROLLER);
		localStorage.removeItem(mirageOpenCTISettings.STORAGEKEY_SFINTERFACE);
		localStorage.removeItem(mirageOpenCTISettings.STORAGEKEY_LASTREQUEST);
		localStorage.removeItem(mirageOpenCTISettings.STORAGEKEY_STATUSOBJECT);
		localStorage.removeItem(mirageOpenCTISettings.STORAGEKEY_CALLERINFO);
		localStorage.removeItem(mirageOpenCTISettings.STORAGEKEY_WRAPUP);
		localStorage.removeItem(mirageOpenCTISettings.STORAGEKEY_SETTINGS);
		localStorage.removeItem(mirageOpenCTISettings.STORAGEKEY_CALLSTATUS);
		localStorage.removeItem(mirageOpenCTISettings.STORAGEKEY_CALLPRIORITY);
	}
	catch (e) {
		mirageLogger.LogError('MirageTools.removeLocalStorage caused an exception:', e);
	}
};
MirageTools.prototype.removeLocalStorageValue = function (key) {
    localStorage.removeItem(key);
};
//session storage persistence 
MirageTools.prototype.setSessionStorageValue = function (key,value){
	try {
		sessionStorage.setItem(key, value);
	}
	catch (e) {
		mirageLogger.LogError('MirageTools.setSessionStorageValue(' + key + ') caused an exception:', e);
	}
};
MirageTools.prototype.getSessionStorageValue = function getLocalStorageValue(key){
	try {
		return sessionStorage.getItem(key);
	}
	catch (e) {
		mirageLogger.LogError('MirageTools.getSessionStorageValue(' + key + ') caused an exception:', e);
		return null;
	}
};
MirageTools.prototype.setSessionStorageObject = function (key, value) {
	try {
		this.setSessionStorageValue(key, JSON.stringify(value));
	}
	catch (e) {
		mirageLogger.LogError('MirageTools.setSessionStorageObject(' + key + ') caused an exception:', e);
	}
};
MirageTools.prototype.getSessionStorageObject = function (key) {
	try {
	    var value = this.getSessionStorageValue(key);
	    return value && JSON.parse(value);
	}
	catch (e) {
		mirageLogger.LogError('MirageTools.getSessionStorageObject(' + key + ') caused an exception:', e);
		return null;
	}
};
MirageTools.prototype.CreateCallSubject = function (call, missed) {
	try {
		if (mirageOpenCTISettings.ADAPTER_SETTINGS_SUBJECT) {
		    var result = mirageOpenCTISettings.ADAPTER_SETTINGS_SUBJECT;
		    var part;
		    var failed = false;
		    
		    
	    	if (result.indexOf('{calltype}') != -1) {
	    		part = '';
	    	    if (missed) {
	        		if (call.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_INCOMING) {
	        			if (call.IsInternal) {
	        				part = Translate('wrapup.subject.missed_internal', 'Missed (internal)');
	        			}
	        			else {
	        				if (mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPMISSEDCALLLABEL) {
	        					part = mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPMISSEDCALLLABEL;
	        				}
	        				else {
	        					part = Translate('wrapup.subject.missed', 'Missed');
	        				}
	        			}
	        		}
	        		else {
	        			if (call.IsInternal) {
	        				part = Translate('wrapup.subject.noanswer_internal', 'No Answer (internal)');
	        			}
	        			else {
	        				if (mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPNOANSWERLABEL) {
	        					part = mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPNOANSWERLABEL;
	        				}
	        				else {
	        					part = Translate('wrapup.subject.noanswer', 'No Answer');
	        				}
	        			}
	        		}
	    	    }
	    	    else if (call.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_INCOMING) {
	    			if (call.IsInternal) {
	    				part = Translate('wrapup.subject.inbound_internal', 'inbound (internal)');
	    			}
	    			else {
	    				part = Translate('wrapup.subject.inbound', 'inbound');
	    			}
	    		}
	    		else {
	    			if (call.IsInternal) {
	    				part = Translate('wrapup.subject.outbound_internal', 'outbound (internal)');
	    			}
	    			else {
	    				part = Translate('wrapup.subject.outbound', 'outbound');
	    			}
	    		}
	    		result = result.replace('{calltype}', part);
	    	}
	    	
	    	if (result.indexOf('{time}') != -1) {
	    		part = '';
	    		if ((call.Answered) && (call.AnsweredAt)) {
	    			part = openCTIObjectWorker.TimeFromDateTime(call.AnsweredAt);
	    		}
	    		else if ((!call.Answered) && (call.CallStart)) {
	    			part = openCTIObjectWorker.TimeFromDateTime(call.CallStart);
	    		}
	    		else {
	    			failed = true;
	    		}
	    		result = result.replace('{time}', part);
	    	}
	    	
	    	if (result.indexOf('{date}') != -1) {
	    		part = '';
	    		if ((call.Answered) && (call.AnsweredAt)) {
	    			part = openCTIObjectWorker.DateFromDateTime(call.AnsweredAt);
	    		}
	    		else if ((!call.Answered) && (call.CallStart)) {
	    			part = openCTIObjectWorker.DateFromDateTime(call.CallStart);
	    		}
	    		else {
	    			failed = true;
	    		}
	    		result = result.replace('{date}', part);
	    	}
	
		    if (failed) {
		    	result = '';
		    }
		    return result;
		}
		else {
			mirageLogger.LogWarn('MirageTools.CreateCallSubject no adapter settings for subject available!');
			return '';
		}
    }
    catch (e) {
		mirageLogger.LogError('MirageTools.CreateCallSubject caused an exception:', e);
		return '';
    }   
};
MirageTools.prototype.IsTaskSaveLocked = function(callId) {
	mirageLogger.LogDebug('MirageTools.IsTaskSaveLocked for call: ' + callId);
	return $.inArray(callId, taskSaveLocked) != -1;
};
MirageTools.prototype.LockTaskSave = function(callId) {
	this.setLocalStorageValue(mirageOpenCTISettings.STORAGEKEY_ADDTASKSAVELOCK,callId);
};
MirageTools.prototype.OpenTaskSave = function(callId) {
	this.setLocalStorageValue(mirageOpenCTISettings.STORAGEKEY_REMOVETASKSAVELOCK,callId);
	for (var i=0;i<taskSaveLocked.length;i++) {
		if (taskSaveLocked[i] == callId) {
			taskSaveLocked.splice(i, 1);
			break;
		}
	}
};
MirageTools.prototype.IsSearchAPILocked = function(callId) {
	mirageLogger.LogDebug('MirageTools.IsSearchAPILocked for call: ' + callId);
	return $.inArray(callId, searchAPILocked) != -1;
};
MirageTools.prototype.LockSearchAPI = function(callId) {
	this.setLocalStorageValue(mirageOpenCTISettings.STORAGEKEY_ADDSEARCHAPILOCK,callId);
};
MirageTools.prototype.OpenSearchAPI = function(callId) {
	this.setLocalStorageValue(mirageOpenCTISettings.STORAGEKEY_REMOVESEARCHAPILOCK,callId);
	for (var i=0;i<searchAPILocked.length;i++) {
		if (searchAPILocked[i] == callId) {
			searchAPILocked.splice(i, 1);
			break;
		}
	}
};
MirageTools.prototype.GetIEVersion = function () {
	try {
		if (this.iEVersion == -1) {
		var sAgent = window.navigator.userAgent;
		var Idx = sAgent.indexOf("MSIE");
		// If IE, return version number.
		if (Idx > 0)
			this.iEVersion = parseInt(sAgent.substring(Idx+ 5, sAgent.indexOf(".", Idx)));
		// If IE 11 then look for Updated user agent string.
		else if (!!navigator.userAgent.match(/Trident\/7\./))
			this.iEVersion = 11;
		else
			this.iEVersion = 0; //It is not IE
		}
		return this.iEVersion;
	}
	catch (e) {
		mirageLogger.LogError('MirageTools.GetIEVersion caused an exception:', e);
	}
};

Object.size = function(obj) {
    var size = 0, key;
    for (key in obj) {
        if (obj.hasOwnProperty(key)) size++;
    }
    return size;
};
function Translate(trans, def) {
	try {
		if (i18nextObject) {
			var res = i18nextObject(trans);
			if ((res) && (res != trans)) {
				return res;
			}
			else {
				return def;
			}
		}
		else {
			return def;
		}
	}
	catch(e) {
		mirageLogger.LogError('Translate(' + trans + ', ' + def + ') caused an exception:', e);
		return def;
	}
}

function IsStrYes(val) {
	try {
		if (!val) {
			return false;
		}
		val = val.toString().toLowerCase();
		if ((val == 'y') ||
				(val == 'yes') ||
				(val == 'j') ||
				(val == 'ja') ||
				(val == 't') ||
				(val == 'true') ||
				(val == '1')) {
			return true;
		}
		else {
			return false;
		}
	}
	catch(e) {
		mirageLogger.LogError('IsStrYes caused an exception:', e);
		return false;
	}
}



function TestSearch() {
	try {
		$('#txtTestSearchResult').val('')
		var callback = function (response) {
			if (response.result) {
				$('#txtTestSearchResult').val(response.result);
			}
			else {
				mirageLogger.LogError('sforce.interaction.searchAndScreenPop failed: ' + response.error);
			}
	    };
	    var s = $('#txtTestSearch').val();
		//sforce.interaction.searchAndScreenPop(s, '', 'inbound', callback);
		sforce.interaction.searchAndGetScreenPopUrl(s, '', 'outbound', callback);
	}
	catch (e) {
		$('#txtTestSearchResult').val(e);
	}
}
$(document).ready(function() {
	$('#txtTestSave').val('ActivityDate=2014-10-23&CallDisposition=Got Voicemail&CallDurationInSeconds=6&CallType=Inbound&Description=gfdfgdf&OwnerId=005A0000001qAmPIAU&Priority=low&Status=Completed&Subject=inbound 14:34:42&WhoId=003A000000pjU0t');
});
function TestSave() {
	try {
		$('#txtTestSaveResult').val('');
		var safeCallback = function(response) {
			if (response.result) {
				$('#txtTestSaveResult').val(response.result);
			}
			else{
				$('#txtTestSaveResult').val(response.error);
			}
		}
		var s = $('#txtTestSave').val();
	    sforce.interaction.saveLog('Task', s, safeCallback); 
	}
	catch (e) {
		$('#txtTestSaveResult').val(e);
	}
}
function TestSendCTIMessage() {
	var callback = function (result) {
        if (result.success) {
        	mirageLogger.LogDebug('CTI message was sent successfully!');
       } else {
    	   mirageLogger.LogDebug('CTI message was not sent successfully.');
         }
     };
	sforce.console.cti.sendCTIMessage($('#txtTestSendCTIMessage').val(), callback);
}