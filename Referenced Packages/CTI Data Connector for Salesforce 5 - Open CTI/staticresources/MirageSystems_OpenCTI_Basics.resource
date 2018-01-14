var openCTIObject = null;
var mirageOpenCTISettings = null; 
var mirageTools = null;
var mirageLogger = null;
var openCTIInterface = null;
var softphoneModel = null;
var softphoneController = null;
var openCTIObjectWorker = null;
var openCTISFInteraction = null;
var callHistory = null;
var taskSaveLocked = new Array();
var searchAPILocked = new Array();
var i18nextObject = null;

$(document).ready(function() {
	InitSoftphone();
});
function InitSoftphone() {
	try {
		mirageOpenCTISettings = new MirageOpenCTISettings();
		mirageLogger = new MirageLogger();	
		mirageTools = new MirageTools();
		softphoneModel = new SoftphoneModel();
		openCTIInterface = new CDCInterface();
		openCTISFInteraction = new OpenCTISFInteraction();
		
		//translate
		var url;
		if ($('#langURL').val().indexOf('?') != -1) {
			url = $('#langURL').val().substr(0, $('#langURL').val().indexOf('?')) + '/__lng__.json';
		}
		else {
			url = $('#langURL').val() + '/__lng__.json';
		}
		var lng = softphoneModel.HiddenSFUserLanguage().val();
		mirageLogger.LogDebug('OpenCTIBasics.InitSoftphone version ' + mirageOpenCTISettings.VERSION + ' salesforce user language ' + lng);
		if (!lng) {
			lng = 'en';
		}
		else if (lng.indexOf('_') != -1) {
			lng = lng.substr(0, lng.indexOf('_'));
		}
		i18n.init({ 
			lng: lng,
			debug: true,
			load: 'unspecific',
			//getAsync: false,
			//resGetPath: 'locales/__lng__/__ns__.json',
			ns: {
	        	namespaces: ['translation'],
	        	defaultNs: 'translation'
	    	},
			resGetPath: url
		}, function(t) {
			i18nextObject = t;
			// translate nav
			$('#initializing').i18n();
			$('#softphone_header').i18n();
			$('#searchHead').i18n();
			$('#divCalledNumber').i18n();
			$('#transferedCall').i18n();
			$('#actions').i18n();
			$('#callWrapUp').i18n();
			$('#ShowCallHistory').i18n();
			/* MK 2015-04-16 translation doesn't work in IE, use defaults
			$('#actionBar').i18n();*/
			//$('#searchHead span').text(Translate('header.phonesearch', 'PN'));
			$('#imgNumberPad').attr('title', Translate('action.numberpad', 'Show dial pad'));
			$('#imgDial').attr('title', Translate('action.dial', 'Dial'));
			$('#imgAnswer').attr('title', Translate('action.answer', 'Resume call'));
			$('#ringing').attr('title', Translate('action.ringing', 'Answer call'));
			$('#imgTransfer').attr('title', Translate('action.transfer', 'Transfer call'));
			$('#imgOneStepTransfer').attr('title', Translate('action.onestep', '1 step transfer'));
			$('#imgCompleteTransfer').attr('title', Translate('action.completetransfer', 'Commit call'));
			$('#imgHold').attr('title', Translate('action.hold', 'Hold call'));
			$('#imgHangUp').attr('title', Translate('action.hangup', 'End call'));
		});
	}
	catch(e) {
		mirageLogger.LogError('OpenCTIBasics.InitSoftphone translation caused an exception:', e);
	}
	try {
		openCTISFInteraction.InitializationComplete();

		var softphoneVersion = mirageTools.getLocalStorageValue(mirageOpenCTISettings.STORAGEKEY_SOFTPHONEVERSION);
		if (softphoneVersion != mirageOpenCTISettings.VERSION) {
			mirageLogger.LogDebug('OpenCTIBasics.InitSoftphone softphone version changed!');
			mirageTools.setLocalStorageValue(mirageOpenCTISettings.STORAGEKEY_SOFTPHONEVERSION, mirageOpenCTISettings.VERSION);
			mirageTools.removeLocalStorage();
		}

		var tmpSessID = mirageTools.getLocalStorageValue(mirageOpenCTISettings.STORAGEKEY_SESSIONID);
		if ((!tmpSessID) ||
			(tmpSessID != softphoneModel.HiddenSFUserSessID().val())) {
			mirageLogger.LogDebug('OpenCTIBasics.InitSoftphone salesforce session changed!');
			mirageTools.removeLocalStorage();
			mirageTools.setLocalStorageValue(mirageOpenCTISettings.STORAGEKEY_SESSIONID, softphoneModel.HiddenSFUserSessID().val());
		}
		
		/*var tmpSFI = mirageTools.getLocalStorageObject(mirageOpenCTISettings.STORAGEKEY_SFINTERFACE);
		if (tmpSFI != null) {
			openCTISFInteraction.ParseJSON(tmpSFI);
		}*/
		openCTIObjectWorker = new OpenCTIObject_Worker();
		softphoneController = new SoftphoneController();
		var tmpC = mirageTools.getLocalStorageObject(mirageOpenCTISettings.STORAGEKEY_CONTROLLER);
		if (tmpC != null) {
			softphoneController.ParseJSON(tmpC);
		}
		var tmpS = mirageTools.getLocalStorageObject(mirageOpenCTISettings.STORAGEKEY_SETTINGS);
		if (tmpS) {
			if ((!tmpS.SETTINGSLASTREAD) ||
				(new Date().getTime() - tmpS.SETTINGSLASTREAD > mirageOpenCTISettings.READSETTINGSTIMEOUT)) {
				//read settings, but don't send them to webservice to avoid that the status objects were reseted
				mirageLogger.LogDebug('OpenCTIBasics.InitSoftphone refresh settings.');
				mirageOpenCTISettings.ReadSettings(function () {AfterSettingsRead(true);});
			}
			else {
				mirageLogger.LogDebug('OpenCTIBasics.InitSoftphone settings alredy read.');
				mirageOpenCTISettings.ParseJSON(tmpS);
				softphoneModel.FillWrapUpStatus();
				softphoneModel.FillLines();
				setTimeout(function (){AfterSettingsRead(true);}, 1000);
			}
		}
		else {
			//read settings and send them to server
			mirageOpenCTISettings.ReadSettings(AfterSettingsRead);
		}
	}
	catch (e) {
		mirageLogger.LogError('OpenCTIBasics.InitSoftphone caused an exception:', e);
	}
}
function AfterSettingsRead(dontSendSettings) {
	try {
		softphoneController.InitResultList();
		//MK 2015-05-06
		var tmpStatus = mirageTools.getLocalStorageValue(mirageOpenCTISettings.STORAGEKEY_CALLSTATUS);
		if (tmpStatus) {
			mirageOpenCTISettings.SALESFORCE_STATUS_COMPLETED = tmpStatus; 
		}
		var tmpPriority = mirageTools.getLocalStorageValue(mirageOpenCTISettings.STORAGEKEY_CALLPRIORITY);
		if (tmpPriority) {
			mirageOpenCTISettings.SALESFORCE_DEFAULT_PRIORITY = tmpPriority; 
		}
		softphoneController.ReadTaskBasics();
		
		var init = false;
		openCTIObject = new OpenCTIObject();
		var tmpSO = mirageTools.getLocalStorageObject(mirageOpenCTISettings.STORAGEKEY_STATUSOBJECT);
		if (tmpSO != null) {
			openCTIObject = tmpSO;
			init = true;
		}

		callHistory = new Array();
		var tmpCH = mirageTools.getLocalStorageObject(mirageOpenCTISettings.STORAGEKEY_CALLHISTORY);
		if (tmpCH != null) {
			callHistory = tmpCH;
			softphoneController.UpdateCallHistory();
		}
		
		if ((mirageOpenCTISettings.SETTINGSLASTSENT) &&
			(new Date().getTime() - mirageOpenCTISettings.SETTINGSLASTSENT > mirageOpenCTISettings.SENDSETTINGSTIMEOUT) &&
			(openCTIObject.Actions.length == 0)) {
			dontSendSettings = false;
		}
		
		var tmpI = mirageTools.getLocalStorageObject(mirageOpenCTISettings.STORAGEKEY_INTERFACE);
		if (tmpI == null) {
			openCTIInterface.Username(softphoneModel.HiddenSFUsername().val());
			/* MK 2015-04-15
			openCTIObject.Head.Version = mirageOpenCTISettings.VERSION;*/
			
			mirageTools.setLocalStorageObject(mirageOpenCTISettings.STORAGEKEY_INTERFACE, openCTIInterface);
		}
		else {
			openCTIInterface.ParseJSON(tmpI);
			//openCTIInterface.isRequesting = false;
			//softphoneController.ProcessCDCResponse(openCTIObject, 'refresh');
		}
		/* verschoben
		sforce.interaction.cti.notifyInitializationComplete();*/
	
		if (init) {
			//setTimeout(function(){softphoneController.ProcessCDCResponse(openCTIObject);}, 2000);
			openCTIObject.ActionsChanged = true;
			//clear IsWaiting so waiting calls are added to waiting list again
			for (var i=0;i<openCTIObject.Actions.length;i++) {
				openCTIObject.Actions[i].Call.IsWaiting = false;
			}
			softphoneController.ProcessCDCResponse(openCTIObject);
		}
		
		if (!softphoneModel.IsOnWrapUp()) {
			try {
				var waId = mirageTools.getLocalStorageValue(mirageOpenCTISettings.STORAGEKEY_WRAPUP);
				if (waId) {
	        		softphoneController.ShowCallWrapUp(parseInt(waId), true);
				}
			}
			catch (e) {
				mirageLogger.LogError('OpenCTIBasics.AfterSettingsRead unable to read wrapup data:', e);
			}
		}
		
		openCTIInterface.ConnectionStateControl(softphoneModel.ImageConnectionState());
		//openCTIInterface.StartControl(softphoneModel.ButtonStartRequesting());
		//openCTIInterface.StopControl(softphoneModel.ButtonStopRequesting());
		if (mirageOpenCTISettings.ADAPTER_SETTINGS_AUTORECONNECT) {
			openCTIInterface.erroneousRequests = 0;
			openCTIInterface.nullResponses = 0;
			openCTIInterface.autoStartDueToNullResponses = 0;
		}
		openCTIInterface.StartRequesting(!dontSendSettings);
	
		if (mirageOpenCTISettings.LOG_USECONTROL) {
			$('#softPhone').append('<div id="MirageLog" class="invisible"></div>');
			mirageLogger.ControlReady = true;
		}
	
		/*if (window.addEventListener) {
			//firefox, chrome, ie9
		    window.addEventListener("storage", storageEventHandler, false);
		}
		else {
		    window.attachEvent("onstorage", storageEventHandler);
		}*/
		var win;
		if (mirageTools.GetIEVersion() == 11) {
			win = window.parent || window.opener || window;
		}
		else {
			win = window;
		}
		try {
			if (win.addEventListener) {
				//firefox, chrome, ie9
				win.addEventListener("storage", storageEventHandler, false);
			}
			else {
				window.attachEvent("onstorage", storageEventHandler);
			}
		}
		catch(e) {
			mirageLogger.LogError('OpenCTIBasics.AfterSettingsRead localStorage event caused an exception:', e);
		}

		if (mirageOpenCTISettings.ADAPTER_SETTINGS_AUTOASSIGN_OBJECT) {
			softphoneController.Action_Assign();
		}
		
		if (callHistory.length > 0) {
			var first = callHistory[callHistory.length-1];
			if (!first.ActivityId) {
				ExistsTask(openCTIObjectWorker.GenerateMirageCallId(first), first.CallId);
			}
		}
		
		$(window).on('focus', function() {
			openCTISFInteraction.AutoSize();
		});
	}
	catch (e) {
		mirageLogger.LogError('OpenCTIBasics.AfterSettingsRead caused an exception:', e);
	}
}

function storageEventHandler(evt) {
	try {
		//only IE raises the event in local tab
		if ((mirageTools.GetIEVersion() > 0) && ($.inArray(evt.key, localStorageCurrentTab) != -1)) {
			if ((evt.key != mirageOpenCTISettings.STORAGEKEY_LASTREQUEST) &&
				(evt.key != mirageOpenCTISettings.STORAGEKEY_STATUSOBJECT) &&
				(evt.key != mirageOpenCTISettings.STORAGEKEY_INTERFACE) &&
				(evt.key != mirageOpenCTISettings.STORAGEKEY_WRAPUP)) {
				mirageLogger.LogDebug('OpenCTIBasics.storageEventHandler called from own tab for key ' + evt.key);
			}
			for (var i=0;i<localStorageCurrentTab.length;i++) {
				if (localStorageCurrentTab[i] == evt.key) {
					localStorageCurrentTab.splice(i, 1);
					break;
				}
			}
    	}
		else {
			if ((evt.key != mirageOpenCTISettings.STORAGEKEY_STATUSOBJECT) &&
				(evt.key != mirageOpenCTISettings.STORAGEKEY_LASTREQUEST) &&
				(evt.key != mirageOpenCTISettings.STORAGEKEY_INTERFACE)) {
				mirageLogger.LogDebug('OpenCTIBasics.storageEventHandler called for key ' + evt.key);
			}
		    switch(evt.key){
		        case mirageOpenCTISettings.STORAGEKEY_SFINTERFACE:
		        	break;
		        case mirageOpenCTISettings.STORAGEKEY_CONTROLLER:
		        	break;
		        case mirageOpenCTISettings.STORAGEKEY_SETTINGS:
		        	var tmp = mirageTools.getLocalStorageObject(evt.key);
		        	if (tmp) {
		        		mirageOpenCTISettings.ParseJSON(tmp);
		        	}
		        	break;
		        case mirageOpenCTISettings.STORAGEKEY_INTERFACE:
		        	if (!openCTIInterface) {
		        		openCTIInterface = new CDCInterface();
		        	}
		        	var tmp = mirageTools.getLocalStorageObject(evt.key);
		        	if (tmp) {
		        		openCTIInterface.ParseJSON(tmp);
		        	}
		        	break;
		        case mirageOpenCTISettings.STORAGEKEY_LASTREQUEST:
		        	if (openCTIInterface) {
		        		openCTIInterface.lastRequest = evt.newValue;
		        	}
		        	break;
		        case mirageOpenCTISettings.STORAGEKEY_STATUSOBJECT:
		        	openCTIObjectWorker.AssignStatusObject(openCTIObject, mirageTools.getLocalStorageObject(evt.key), true);
					softphoneController.ProcessCDCResponse(openCTIObject);
		        	break;
		        case mirageOpenCTISettings.STORAGEKEY_CALLHISTORY:
		        	/* MK 2015-04-09
		        	callHistory = mirageTools.getLocalStorageObject(evt.key);*/
		        	openCTIObjectWorker.AssignHistory(mirageTools.getLocalStorageObject(evt.key));
					softphoneController.UpdateCallHistory();
					openCTISFInteraction.AutoSize();
		        	break;
		        case mirageOpenCTISettings.STORAGEKEY_CALLERINFO:
		        	var callInfo = mirageTools.getLocalStorageObject(evt.key);
		        	if (callInfo) {
			        	var call = openCTIObjectWorker.CallById(callInfo.CallId);
			        	if (call) {
			        		call.Subject = callInfo.Subject;
			        		call.Comment = callInfo.Comment;
			        		call.Disposition = callInfo.Disposition;
			        		call.DoNotSave = callInfo.DoNotSave;
			        	}
			    		softphoneController.ShowCallInfo(callInfo);
		        	}
		        	break;
		        case mirageOpenCTISettings.STORAGEKEY_WRAPUP:
		        	if (evt.newValue) {
		        		softphoneController.ShowCallWrapUp(evt.newValue, true);
		        	}
		        	else {
		        		softphoneController.CallWrapUp_Cancel();
		        	}
		        	break;
		        case mirageOpenCTISettings.STORAGEKEY_ADDTASKSAVELOCK:
	    			mirageLogger.LogDebug('OpenCTIBasics.storageEventHandler add task to save lock ' + evt.newValue + ' (' + taskSaveLocked + ')');
		        	if ($.inArray(evt.newValue, taskSaveLocked) == -1) {
		        		taskSaveLocked.push(evt.newValue);
		        	}
		        	break;
		        case mirageOpenCTISettings.STORAGEKEY_REMOVETASKSAVELOCK:
	    			mirageLogger.LogDebug('OpenCTIBasics.storageEventHandler remove task from save lock ' + evt.newValue + ' (' + taskSaveLocked + ')');
		        	for (var i=0;i<taskSaveLocked.length;i++) {
		        		if (taskSaveLocked[i] == evt.newValue) {
		        			taskSaveLocked.splice(i, 1);
		        			break;
		        		}
		        	}
		        	break;
		        case mirageOpenCTISettings.STORAGEKEY_ADDSEARCHAPILOCK:
	    			mirageLogger.LogDebug('OpenCTIBasics.storageEventHandler add task to search lock ' + evt.newValue + ' (' + searchAPILocked + ')');
		        	if ($.inArray(evt.newValue, searchAPILocked) == -1) {
		        		searchAPILocked.push(evt.newValue);
		        	}
		        	break;
		        case mirageOpenCTISettings.STORAGEKEY_REFRESHACTIVITYLIST:
	    			mirageLogger.LogDebug('OpenCTIBasics.storageEventHandler refresh activity list');
	    			softphoneController.RefreshActivityList(true);
		        	break;
		        case mirageOpenCTISettings.STORAGEKEY_REMOVESEARCHAPILOCK:
	    			mirageLogger.LogDebug('OpenCTIBasics.storageEventHandler remove task from search lock ' + evt.newValue + ' (' + searchAPILocked + ')');
		        	for (var i=0;i<searchAPILocked.length;i++) {
		        		if (searchAPILocked[i] == evt.newValue) {
		        			searchAPILocked.splice(i, 1);
		        			break;
		        		}
		        	}
		        	break;
		        case mirageOpenCTISettings.STORAGEKEY_ANSWERONHOLD:
					softphoneModel.HiddenAnswerOnHoldCallId().val(evt.newValue);
		        	break;
		        case mirageOpenCTISettings.STORAGEKEY_ACTIONTOTOP:
		    		openCTIObjectWorker.MoveActionToTop(openCTIObjectWorker.getActionForCallId(evt.newValue));
		        	break;
		        case mirageOpenCTISettings.STORAGEKEY_SESSIONID:
		        	setTimeout(function(){InitSoftphone();}, 2000);
		        	break;
		        case mirageOpenCTISettings.STORAGEKEY_CALLHISTORYVISIBLE:
		        	if (IsStrYes(evt.newValue)) {
		        		softphoneModel.SoftPhone_CallHistory().show();
		        	}
		        	else {
		        		softphoneModel.SoftPhone_CallHistory().hide();
		        	}
		        	break;
		        case mirageOpenCTISettings.STORAGEKEY_STOPREQUESTING:
		        	openCTIInterface.StopRequesting(true);
		        	break;
		        case mirageOpenCTISettings.STORAGEKEY_STARTREQUESTING:
		        	openCTIInterface.StartRequesting(false, true);
		        	break;
		        case mirageOpenCTISettings.STORAGEKEY_SOFTPHONEVERSION:
		        	location.reload(true);
		        	break;
		        case mirageOpenCTISettings.STORAGEKEY_CALLSTATUS:
		        	mirageOpenCTISettings.SALESFORCE_STATUS_COMPLETED = evt.newValue;
		        	break;
		        case mirageOpenCTISettings.STORAGEKEY_CALLPRIORITY:
		        	mirageOpenCTISettings.SALESFORCE_DEFAULT_PRIORITY = evt.newValue;
		        	break;
		        default:
		    		mirageLogger.LogWarn('OpenCTIBasics.storageEventHandler: unknown key ' + evt.key);
		        	break;
		    }
		}
	}
	catch (e) {
		mirageLogger.LogError('OpenCTIBasics.storageEventHandler caused an exception:', e);
	}
}