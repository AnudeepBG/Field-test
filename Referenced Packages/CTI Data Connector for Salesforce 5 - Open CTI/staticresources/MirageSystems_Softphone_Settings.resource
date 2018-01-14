//constants
var LOGLEVEL_DEBUG = 1;
var LOGLEVEL_INFO = 2;
var LOGLEVEL_WARN = 3;
var LOGLEVEL_ERROR = 4;
var LOGLEVEL_LOGGINGOFF = 5;

//settings
function MirageOpenCTISettings() {
	this.VERSION = '5.2.23';
	this.SETTINGSLASTREAD = null;
	this.SETTINGSLASTSENT = null;
	this.READSETTINGSTIMEOUT = 10*60*1000;//10min
	this.SENDSETTINGSTIMEOUT = 24*60*60*1000;//24h
	this.TABSTIMEOUT = 10*60*1000;//10min
	
	this.LOG_USECONSOLE = true;
	this.LOG_USECONTROL = false;
	this.LOG_USECACHE = true;
	this.LOG_ALERTERRORS = true;
	this.LOG_LEVEL = LOGLEVEL_DEBUG;
	
	this.MAX_HISTORY_LENGTH = 25;
	
	this.ICDC_MAXERRONEOUSREQUESTS = 5;
	this.ICDC_DOCALLRETRYINTERVALINMILLISECONDS = 1000;
	this.ICDC_USEPORTSHARING = true;
	
	this.ICDC_ACTION_DIALINGCALL = 10;
	this.ICDC_ACTION_DIALINGCALL_ACK = 11;
	this.ICDC_ACTION_ANSWERCALL = 20;
	this.ICDC_ACTION_ANSWERCALL_ACK = 21;
	this.ICDC_ACTION_TRANSFERCALL = 30;
	this.ICDC_ACTION_TRANSFERCALL_ACK = 31;
	this.ICDC_ACTION_HOLDCALL = 40;
	this.ICDC_ACTION_HOLDCALL_ACK = 41;
	this.ICDC_ACTION_HANGUPCALL = 50;
	this.ICDC_ACTION_HANGUPCALL_ACK = 51;
	
    this.ICDC_CALLTYPE_INCOMING = 1;
    this.ICDC_CALLTYPE_OUTGOING = 2;

    this.ICDC_CONNECTIONSTATE_STARTED = 1;
    this.ICDC_CONNECTIONSTATE_STOPED = 2;
    
    this.SALESFORCE_STATUS_COMPLETED = 'Completed';
    this.SALESFORCE_DEFAULT_PRIORITY = 'low';
	
	this.STORAGEKEY_INTERFACE = 'mirage_systems.opencti.interface_object';
	this.STORAGEKEY_CONTROLLER = 'mirage_systems.opencti.controller_object';
	this.STORAGEKEY_SFINTERFACE = 'mirage_systems.opencti.sfinterface_object';
	this.STORAGEKEY_SETTINGS = 'mirage_systems.opencti.settings_object';
	this.STORAGEKEY_LASTREQUEST = 'mirage_systems.opencti.last_request';
	this.STORAGEKEY_STATUSOBJECT = 'mirage_systems.opencti.status_object';
	this.STORAGEKEY_CALLHISTORY = 'mirage_systems.opencti.call_history';
	this.STORAGEKEY_CALLERINFO = 'mirage_systems.opencti.caller_info';
	this.STORAGEKEY_WRAPUP = 'mirage_systems.opencti.wrap_up';
	this.STORAGEKEY_ADDTASKSAVELOCK = 'mirage_systems.opencti.add_task_save_lock';
	this.STORAGEKEY_REMOVETASKSAVELOCK = 'mirage_systems.opencti.remove_task_save_lock';
	this.STORAGEKEY_ADDSEARCHAPILOCK = 'mirage_systems.opencti.add_search_api_lock';
	this.STORAGEKEY_REMOVESEARCHAPILOCK = 'mirage_systems.opencti.remove_search_api_lock';
	this.STORAGEKEY_ANSWERONHOLD = 'mirage_systems.opencti.answer_on_hold';
	this.STORAGEKEY_ACTIONTOTOP = 'mirage_systems.opencti.action_to_top';
	this.STORAGEKEY_REFRESHACTIVITYLIST = 'mirage_systems.opencti.refresh_activity_list';
	this.STORAGEKEY_SESSIONID = 'mirage_systems.opencti.sessionid';
	this.STORAGEKEY_TABID = 'mirage_systems.opencti.tabid';
	this.STORAGEKEY_CALLHISTORYVISIBLE = 'mirage_systems.opencti.call_history_visible';
	this.STORAGEKEY_STOPREQUESTING = 'mirage_systems.opencti.stop_requesting';
	this.STORAGEKEY_STARTREQUESTING = 'mirage_systems.opencti.start_requesting';
	this.STORAGEKEY_SOFTPHONEVERSION = 'mirage_systems.opencti.softphone_version';
	this.STORAGEKEY_CALLSTATUS = 'mirage_systems.opencti.call_status';
	this.STORAGEKEY_CALLPRIORITY = 'mirage_systems.opencti.call_priority';
	
	this.ADAPTER_SETTINGS_BTNDONOTSAVE = true;
	this.ADAPTER_SETTINGS_COUNTRY_CODE = '';
	this.ADAPTER_SETTINGS_DONT_SHOW_INTERNAL_CALLS = false;
	this.ADAPTER_SETTINGS_INCOMING_CUTPOSTFIX = '';
	this.ADAPTER_SETTINGS_INCOMING_PREFIXTOADD = '';
	this.ADAPTER_SETTINGS_INCOMING_PREFIXTOREMOVE = '';
	this.ADAPTER_SETTINGS_INTERNAL_MAXLEN = 0;
	this.ADAPTER_SETTINGS_INTERNATIONAL_PREFIX ='';
	this.ADAPTER_SETTINGS_LONGDIST_PREFIX = '';
	this.ADAPTER_SETTINGS_OUTGOING_PREFIXTOADD = '';
	this.ADAPTER_SETTINGS_OUTGOING_PREFIXTOREMOVE = '';
	this.ADAPTER_SETTINGS_OUTSIDE_PREFIX = '';
	this.ADAPTER_SETTINGS_TRUNCATEPHONENUMBERAT = '';
	this.ADAPTER_SETTINGS_MAX_DO_RESPONS_EERRORS = 10;
	this.ADAPTER_SETTINGS_SF_POLL_INTERVAL = 1000;
	this.ADAPTER_SETTINGS_SETUP_TRANSFER_TIMEOUT = 30;
	this.ADAPTER_SETTINGS_OPENCTI_WS_POLL_INTERVAL = 1000;
	this.ADAPTER_SETTINGS_TAPILINK_WS_POLL_INTERVAL = 1000;
	this.ADAPTER_SETTINGS_SOFTPHONE_HEIGHT = 475;
	this.ADAPTER_SETTINGS_SOFTPHONE_WIDTH = 275;
	this.ADAPTER_SETTINGS_VERSION = '';
	this.ADAPTER_SETTINGS_AUTOSAVE_INCOMINGCALLS = true;
	this.ADAPTER_SETTINGS_AUTOSAVE_INTERNALCALLS = true;
	this.ADAPTER_SETTINGS_AUTOSAVE_OUTGOINGCALLS = true;
	this.ADAPTER_SETTINGS_AUTOSAVE_UNSUCCESSFUL_INCOMINGCALLS = false;
	this.ADAPTER_SETTINGS_AUTOSAVE_UNSUCCESSFUL_INTERNALCALLS = false;
	this.ADAPTER_SETTINGS_AUTOSAVE_UNSUCCESSFUL_OUTGOINGCALLS = false;
	this.ADAPTER_SETTINGS_CALLER_FIELD = '';
	this.ADAPTER_SETTINGS_CALLED_FIELD = '';
	this.ADAPTER_SETTINGS_AUTO_EDIT_TASK = false
	this.ADAPTER_SETTINGS_SUBJECT = '{calltype} {time}';
	this.ADAPTER_SETTINGS_WRAPUPENABLE = true;
	this.ADAPTER_SETTINGS_WRAPUPREQUIRED = false;
	this.ADAPTER_SETTINGS_WRAPUPLABEL1 = '';
	this.ADAPTER_SETTINGS_WRAPUPVALUE1 = '';
	this.ADAPTER_SETTINGS_WRAPUPLABEL2 = '';
	this.ADAPTER_SETTINGS_WRAPUPVALUE2 = '';
	this.ADAPTER_SETTINGS_WRAPUPLABEL3 = '';
	this.ADAPTER_SETTINGS_WRAPUPVALUE3 = '';
	this.ADAPTER_SETTINGS_WRAPUPLABEL4 = '';
	this.ADAPTER_SETTINGS_WRAPUPVALUE4 = '';
	this.ADAPTER_SETTINGS_WRAPUPLABEL5 = '';
	this.ADAPTER_SETTINGS_WRAPUPVALUE5 = '';
	this.ADAPTER_SETTINGS_WRAPUPLABEL6 = '';
	this.ADAPTER_SETTINGS_WRAPUPVALUE6 = '';
	this.ADAPTER_SETTINGS_WRAPUPLABEL7 = '';
	this.ADAPTER_SETTINGS_WRAPUPVALUE7 = '';
	this.ADAPTER_SETTINGS_WRAPUPLABEL8 = '';
	this.ADAPTER_SETTINGS_WRAPUPVALUE8 = '';
	this.ADAPTER_SETTINGS_WRAPUPLABEL9 = '';
	this.ADAPTER_SETTINGS_WRAPUPVALUE9 = '';
	this.ADAPTER_SETTINGS_WRAPUPLABEL10 = '';
	this.ADAPTER_SETTINGS_WRAPUPVALUE10 = '';
	this.ADAPTER_SETTINGS_WRAPUPLABEL11 = '';
	this.ADAPTER_SETTINGS_WRAPUPVALUE11 = '';
	this.ADAPTER_SETTINGS_WRAPUPLABEL12 = '';
	this.ADAPTER_SETTINGS_WRAPUPVALUE12 = '';
	this.ADAPTER_SETTINGS_WRAPUPLABEL13 = '';
	this.ADAPTER_SETTINGS_WRAPUPVALUE13 = '';
	this.ADAPTER_SETTINGS_WRAPUPLABEL14 = '';
	this.ADAPTER_SETTINGS_WRAPUPVALUE14 = '';
	this.ADAPTER_SETTINGS_WRAPUPLABEL15 = '';
	this.ADAPTER_SETTINGS_WRAPUPVALUE15 = '';
	this.ADAPTER_SETTINGS_WRAPUPMISSEDCALLLABEL = '';
	this.ADAPTER_SETTINGS_WRAPUPMISSEDCALLVALUE = '';
	this.ADAPTER_SETTINGS_WRAPUPNOANSWERLABEL = '';
	this.ADAPTER_SETTINGS_WRAPUPNOANSWERVALUE = '';
	this.ADAPTER_SETTINGS_HISTORY_LENGTH = 10;
	this.ADAPTER_SETTINGS_AUTOASSIGN_OBJECT = false;
	this.ADAPTER_SETTINGS_MANDATOR = '';
	this.ADAPTER_SETTINGS_MANDATOR_PASSWORD = '';
	this.ADAPTER_SETTINGS_PARTICIPANT = '';
	this.ADAPTER_SETTINGS_OPENCTI_SERVICE_URL = '';
	this.ADAPTER_SETTINGS_CONSOLE_USEINTERACTIONLOG = true;
	this.ADAPTER_SETTINGS_OUTLINELABEL1 = '';
	this.ADAPTER_SETTINGS_OUTLINEVALUE1 = '';
	this.ADAPTER_SETTINGS_OUTLINELABEL2 = '';
	this.ADAPTER_SETTINGS_OUTLINEVALUE2 = '';
	this.ADAPTER_SETTINGS_OUTLINELABEL3 = '';
	this.ADAPTER_SETTINGS_OUTLINEVALUE3 = '';
	this.ADAPTER_SETTINGS_OUTLINELABEL4 = '';
	this.ADAPTER_SETTINGS_OUTLINEVALUE4 = '';
	this.ADAPTER_SETTINGS_OUTLINELABEL5 = '';
	this.ADAPTER_SETTINGS_OUTLINEVALUE5 = '';
	this.ADAPTER_SETTINGS_OUTLINELABEL6 = '';
	this.ADAPTER_SETTINGS_OUTLINEVALUE6 = '';
	this.ADAPTER_SETTINGS_OUTLINELABEL7 = '';
	this.ADAPTER_SETTINGS_OUTLINEVALUE7 = '';
	this.ADAPTER_SETTINGS_OUTLINELABEL8 = '';
	this.ADAPTER_SETTINGS_OUTLINEVALUE8 = '';
	this.ADAPTER_SETTINGS_OUTLINELABEL9 = '';
	this.ADAPTER_SETTINGS_OUTLINEVALUE9 = '';
	this.ADAPTER_SETTINGS_OUTLINELABEL10 = '';
	this.ADAPTER_SETTINGS_OUTLINEVALUE10 = '';
	this.ADAPTER_SETTINGS_SHOWTRANSFERBUTTON = false;
	this.ADAPTER_SETTINGS_SHOWONESTEPTRANSFERBUTTON = true;
	this.ADAPTER_SETTINGS_AUTORECONNECT = false;

	this.CDCSTATUS_OFFLINE = 0;
	this.CDCSTATUS_ONLINE = 1;
	this.CDCSTATUS_TIMEOUT = 2;
	
	this.SyncArray = new Array();
}

MirageOpenCTISettings.prototype.ReadSettings = function (callback) {
	try {
		mirageLogger.LogDebug('MirageOpenCTISettings.ReadSettings called.');
		var obj = this;
		var readSettings_Callback = function(response) {
			mirageLogger.LogDebug('MirageOpenCTISettings.ReadSettings Callback called');
			if (!obj.ReadSettings_Callback(response)) {
				mirageLogger.LogError('SF Settings konnten nicht gelesen werden!');
			}
			if (callback) { callback(); }
		}
		if (typeof sforce == 'undefined') {
			mirageLogger.LogError('Salesforce API is not available!');
		}
		this.SETTINGSLASTREAD = new Date().getTime();
		sforce.interaction.cti.getCallCenterSettings(readSettings_Callback);
	}
	catch(e) {
		mirageLogger.LogError('MirageOpenCTISettings.ReadSettings caused an exception:', e);
	}
};
MirageOpenCTISettings.prototype.ReadSettings_Callback = function (response) {
	try {
		mirageLogger.LogDebug('MirageOpenCTISettings.ReadSettings_Callback processing response');
		if (response != null) {
			if (response.result != null) {
				var setting = function(key, value) {
					this.Key = key;
					this.Value = value;
				}
				var jsonSettings = jQuery.parseJSON(response.result);
				var keys = Object.keys(jsonSettings);
				
				this.SyncArray = new Array();

				//no adapter setting
				this.ADAPTER_SETTINGS_PARTICIPANT = softphoneModel.HiddenSFUsername().val();
				
				for (var i=0; i<keys.length; i++) {
					//prepare sync array
					if ((keys[i].startsWith('/reqDialingOptions')) ||
						(keys[i].endsWith('reqSFPollInterval')) ||
						(keys[i].endsWith('reqSetupTransferTimeout')) ||
						(keys[i].endsWith('reqTAPILINKWSPollInterval'))) {
						this.SyncArray.push(new setting(keys[i], jsonSettings[keys[i]]));
					}

					//fill settings
					if (keys[i].endsWith('reqButtonDoNotSave')) {
						this.ADAPTER_SETTINGS_BTNDONOTSAVE = jsonSettings[keys[i]].isStrYes();
					}
					else if (keys[i].endsWith('reqCountryCode')) {
						this.ADAPTER_SETTINGS_COUNTRY_CODE = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqDontShowInternalCalls')) {
						this.ADAPTER_SETTINGS_DONT_SHOW_INTERNAL_CALLS = jsonSettings[keys[i]].isStrYes();
					}
					else if (keys[i].endsWith('reqIncomingCutPostfix')) {
						this.ADAPTER_SETTINGS_INCOMING_CUTPOSTFIX = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqIncomingPrefixToAdd')) {
						this.ADAPTER_SETTINGS_INCOMING_PREFIXTOADD = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqIncomingPrefixToRemove')) {
						this.ADAPTER_SETTINGS_INCOMING_PREFIXTOREMOVE = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqInternalMaxLen')) {
						this.ADAPTER_SETTINGS_INTERNAL_MAXLEN = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqInternationalPrefix')) {
						this.ADAPTER_SETTINGS_INTERNATIONAL_PREFIX = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqLongDistPrefix')) {
						this.ADAPTER_SETTINGS_LONGDIST_PREFIX = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqOutgoingPrefixToAdd')) {
						this.ADAPTER_SETTINGS_OUTGOING_PREFIXTOADD = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqOutgoingPrefixToRemove')) {
						this.ADAPTER_SETTINGS_OUTGOING_PREFIXTOREMOVE = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqOutsidePrefix')) {
						this.ADAPTER_SETTINGS_OUTSIDE_PREFIX = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqTruncatePhoneNumberAt')) {
						this.ADAPTER_SETTINGS_TRUNCATEPHONENUMBERAT = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqSFPollInterval')) {
						try {
							var interval = parseInt(jsonSettings[keys[i]]);
							if ((interval>20) && (interval<2000)) {
								//MK 2015-05-05 change old default
								if (interval == 500) {
									this.ADAPTER_SETTINGS_SF_POLL_INTERVAL = 1000;
								}
								else {
									this.ADAPTER_SETTINGS_SF_POLL_INTERVAL = interval;
								}
							}
						}
						catch (e) {
							mirageLogger.LogError('MirageOpenCTISettings.ReadSettings_Callback failed to read reqSFPollInterval!', e);
						}
					}
					else if (keys[i].endsWith('reqOCTIWSPollInterval')) {
						try {
							var interval = parseInt(jsonSettings[keys[i]]);
							if ((interval>=100) && (interval<=5000)) {
								this.ADAPTER_SETTINGS_OPENCTI_WS_POLL_INTERVAL = interval;
							}
						}
						catch (e) {
							mirageLogger.LogError('MirageOpenCTISettings.ReadSettings_Callback failed to read reqOCTIWSPollInterval!', e);
						}
					}
					else if (keys[i].endsWith('reqTAPILINKWSPollInterval')) {
						try {
							var interval = parseInt(jsonSettings[keys[i]]);
							if ((interval>=100) && (interval<=5000)) {
								this.ADAPTER_SETTINGS_TAPILINK_WS_POLL_INTERVAL = interval;
							}
						}
						catch (e) {
							mirageLogger.LogError('MirageOpenCTISettings.ReadSettings_Callback failed to read reqTAPILINKWSPollInterval!', e);
						}
					}
					else if (keys[i].endsWith('reqSoftphoneHeight')) {
						this.ADAPTER_SETTINGS_SOFTPHONEHEIGHT = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqSoftphoneWidth')) {
						this.ADAPTER_SETTINGS_SOFTPHONEWIDTH = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqVersion')) {
						this.ADAPTER_SETTINGS_VERSION = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqAutosaveIncomingCalls')) {
						this.ADAPTER_SETTINGS_AUTOSAVE_INCOMINGCALLS = jsonSettings[keys[i]].isStrYes();
					}
					else if (keys[i].endsWith('reqAutosaveInternalCalls')) {
						this.ADAPTER_SETTINGS_AUTOSAVE_INTERNALCALLS = jsonSettings[keys[i]].isStrYes();
					}
					else if (keys[i].endsWith('reqAutosaveOutgoingCalls')) {
						this.ADAPTER_SETTINGS_AUTOSAVE_OUTGOINGCALLS = jsonSettings[keys[i]].isStrYes();
					}
					else if (keys[i].endsWith('reqAutosaveUnsuccessfulIncomingCalls')) {
						this.ADAPTER_SETTINGS_AUTOSAVE_UNSUCCESSFUL_INCOMINGCALLS = jsonSettings[keys[i]].isStrYes();
					}
					else if (keys[i].endsWith('reqAutosaveUnsuccessfulInternalCalls')) {
						this.ADAPTER_SETTINGS_AUTOSAVE_UNSUCCESSFUL_INTERNALCALLS = jsonSettings[keys[i]].isStrYes();
					}
					else if (keys[i].endsWith('reqAutosaveUnsuccessfulOutgoingCalls')) {
						this.ADAPTER_SETTINGS_AUTOSAVE_UNSUCCESSFUL_OUTGOINGCALLS = jsonSettings[keys[i]].isStrYes();
					}
					else if (keys[i].endsWith('reqCallerField')) {
						this.ADAPTER_SETTINGS_CALLER_FIELD = jsonSettings[keys[i]];
						/*if ((this.ADAPTER_SETTINGS_CALLER_FIELD) && (!this.ADAPTER_SETTINGS_CALLER_FIELD.startsWith('Mirage__'))) {
							this.ADAPTER_SETTINGS_CALLER_FIELD = 'Mirage__' + this.ADAPTER_SETTINGS_CALLER_FIELD;
						}*/
						if ((this.ADAPTER_SETTINGS_CALLER_FIELD) && (!this.ADAPTER_SETTINGS_CALLER_FIELD.endsWith('__c'))) {
							this.ADAPTER_SETTINGS_CALLER_FIELD += '__c';
						}
					}
					else if (keys[i].endsWith('reqCalledField')) {
						this.ADAPTER_SETTINGS_CALLED_FIELD = jsonSettings[keys[i]];
						/*if ((this.ADAPTER_SETTINGS_CALLED_FIELD) && (!this.ADAPTER_SETTINGS_CALLED_FIELD.startsWith('Mirage__'))) {
							this.ADAPTER_SETTINGS_CALLED_FIELD = 'Mirage__' + this.ADAPTER_SETTINGS_CALLED_FIELD;
						}*/
						if ((this.ADAPTER_SETTINGS_CALLED_FIELD) && (!this.ADAPTER_SETTINGS_CALLED_FIELD.endsWith('__c'))) {
							this.ADAPTER_SETTINGS_CALLED_FIELD += '__c';
						}
					}
					else if (keys[i].endsWith('reqAutoEditTask')) {
						this.ADAPTER_SETTINGS_AUTO_EDIT_TASK = jsonSettings[keys[i]].isStrYes();
					}
					else if (keys[i].endsWith('reqSubject')) {
						this.ADAPTER_SETTINGS_SUBJECT = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupEnable')) {
						this.ADAPTER_SETTINGS_WRAPUPENABLE = jsonSettings[keys[i]].isStrYes();
					}
					else if (keys[i].endsWith('reqWrapuprequired')) {
						this.ADAPTER_SETTINGS_WRAPUPREQUIRED = jsonSettings[keys[i]].isStrYes();
					}
					else if (keys[i].endsWith('reqWrapupLabel1')) {
						this.ADAPTER_SETTINGS_WRAPUPLABEL1 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupValue1')) {
						this.ADAPTER_SETTINGS_WRAPUPVALUE1 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupLabel2')) {
						this.ADAPTER_SETTINGS_WRAPUPLABEL2 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupValue2')) {
						this.ADAPTER_SETTINGS_WRAPUPVALUE2 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupLabel3')) {
						this.ADAPTER_SETTINGS_WRAPUPLABEL3 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupValue3')) {
						this.ADAPTER_SETTINGS_WRAPUPVALUE3 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupLabel4')) {
						this.ADAPTER_SETTINGS_WRAPUPLABEL4 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupValue4')) {
						this.ADAPTER_SETTINGS_WRAPUPVALUE4 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupLabel5')) {
						this.ADAPTER_SETTINGS_WRAPUPLABEL5 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupValue5')) {
						this.ADAPTER_SETTINGS_WRAPUPVALUE5 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupLabel6')) {
						this.ADAPTER_SETTINGS_WRAPUPLABEL6 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupValue6')) {
						this.ADAPTER_SETTINGS_WRAPUPVALUE6 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupLabel7')) {
						this.ADAPTER_SETTINGS_WRAPUPLABEL7 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupValue7')) {
						this.ADAPTER_SETTINGS_WRAPUPVALUE7 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupLabel8')) {
						this.ADAPTER_SETTINGS_WRAPUPLABEL8 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupValue8')) {
						this.ADAPTER_SETTINGS_WRAPUPVALUE8 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupLabel9')) {
						this.ADAPTER_SETTINGS_WRAPUPLABEL9 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupValue9')) {
						this.ADAPTER_SETTINGS_WRAPUPVALUE9 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupLabel10')) {
						this.ADAPTER_SETTINGS_WRAPUPLABEL10 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupValue10')) {
						this.ADAPTER_SETTINGS_WRAPUPVALUE10 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupLabel11')) {
						this.ADAPTER_SETTINGS_WRAPUPLABEL11 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupValue11')) {
						this.ADAPTER_SETTINGS_WRAPUPVALUE11 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupLabel12')) {
						this.ADAPTER_SETTINGS_WRAPUPLABEL12 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupValue12')) {
						this.ADAPTER_SETTINGS_WRAPUPVALUE12 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupLabel13')) {
						this.ADAPTER_SETTINGS_WRAPUPLABEL13 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupValue13')) {
						this.ADAPTER_SETTINGS_WRAPUPVALUE13 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupLabel14')) {
						this.ADAPTER_SETTINGS_WRAPUPLABEL14 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupValue14')) {
						this.ADAPTER_SETTINGS_WRAPUPVALUE14 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupLabel15')) {
						this.ADAPTER_SETTINGS_WRAPUPLABEL15 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupValue15')) {
						this.ADAPTER_SETTINGS_WRAPUPVALUE15 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupMissedCallLabel')) {
						this.ADAPTER_SETTINGS_WRAPUPMISSEDCALLLABEL = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupMissedCallValue')) {
						this.ADAPTER_SETTINGS_WRAPUPMISSEDCALLVALUE = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupNoAnswerLabel')) {
						this.ADAPTER_SETTINGS_WRAPUPNOANSWERLABEL = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqWrapupNoAnswerValue')) {
						this.ADAPTER_SETTINGS_WRAPUPNOANSWERVALUE = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqHistoryLength')) {
						if (jsonSettings[keys[i]]) {
							try {
								this.ADAPTER_SETTINGS_HISTORY_LENGTH = parseInt(jsonSettings[keys[i]]);
								if (this.ADAPTER_SETTINGS_HISTORY_LENGTH > this.MAX_HISTORY_LENGTH) {
									this.ADAPTER_SETTINGS_HISTORY_LENGTH = this.MAX_HISTORY_LENGTH;
								}
							}
							catch (e) {}
						}
					}
					else if (keys[i].endsWith('reqAutoAssignObject')) {
						this.ADAPTER_SETTINGS_AUTOASSIGN_OBJECT = jsonSettings[keys[i]].isStrYes();
					}
					else if (keys[i].endsWith('reqMandator')) {
						this.ADAPTER_SETTINGS_MANDATOR = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqMandatorPassword')) {
						this.ADAPTER_SETTINGS_MANDATOR_PASSWORD = jsonSettings[keys[i]];
					}
					/*else if (keys[i].endsWith('reqParticipant')) {
						this.ADAPTER_SETTINGS_PARTICIPANT = jsonSettings[keys[i]];
						if (this.ADAPTER_SETTINGS_PARTICIPANT == '') {
							this.ADAPTER_SETTINGS_PARTICIPANT = softphoneModel.HiddenSFUsername().val();
						}
					}*/
					else if (keys[i].endsWith('reqOpenCTIServiceUrl')) {
						this.ADAPTER_SETTINGS_OPENCTI_SERVICE_URL = jsonSettings[keys[i]];
						if (!this.ADAPTER_SETTINGS_OPENCTI_SERVICE_URL.endsWith('/')) { this.ADAPTER_SETTINGS_OPENCTI_SERVICE_URL += '/'; }
					}
					else if (keys[i].endsWith('reqConsoleUseInteractionLog')) {
						this.ADAPTER_SETTINGS_CONSOLE_USEINTERACTIONLOG = jsonSettings[keys[i]].isStrYes();
					}
					else if (keys[i].endsWith('reqSetupTransferTimeout')) {
						this.ADAPTER_SETTINGS_SETUP_TRANSFER_TIMEOUT = jsonSettings[keys[i]].isStrYes();
					}
					else if (keys[i].endsWith('reqOutLineLabel1')) {
						this.ADAPTER_SETTINGS_OUTLINELABEL1 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqOutLineValue1')) {
						this.ADAPTER_SETTINGS_OUTLINEVALUE1 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqOutLineLabel2')) {
						this.ADAPTER_SETTINGS_OUTLINELABEL2 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqOutLineValue2')) {
						this.ADAPTER_SETTINGS_OUTLINEVALUE2 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqOutLineLabel3')) {
						this.ADAPTER_SETTINGS_OUTLINELABEL3 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqOutLineValue3')) {
						this.ADAPTER_SETTINGS_OUTLINEVALUE3 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqOutLineLabel4')) {
						this.ADAPTER_SETTINGS_OUTLINELABEL4 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqOutLineValue4')) {
						this.ADAPTER_SETTINGS_OUTLINEVALUE4 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqOutLineLabel5')) {
						this.ADAPTER_SETTINGS_OUTLINELABEL5 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqOutLineValue5')) {
						this.ADAPTER_SETTINGS_OUTLINEVALUE5 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqOutLineLabel6')) {
						this.ADAPTER_SETTINGS_OUTLINELABEL6 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqOutLineValue6')) {
						this.ADAPTER_SETTINGS_OUTLINEVALUE6 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqOutLineLabel7')) {
						this.ADAPTER_SETTINGS_OUTLINELABEL7 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqOutLineValue7')) {
						this.ADAPTER_SETTINGS_OUTLINEVALUE7 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqOutLineLabel8')) {
						this.ADAPTER_SETTINGS_OUTLINELABEL8 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqOutLineValue8')) {
						this.ADAPTER_SETTINGS_OUTLINEVALUE8 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqOutLineLabel9')) {
						this.ADAPTER_SETTINGS_OUTLINELABEL9 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqOutLineValue9')) {
						this.ADAPTER_SETTINGS_OUTLINEVALUE9 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqOutLineLabel10')) {
						this.ADAPTER_SETTINGS_OUTLINELABEL10 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqOutLineValue10')) {
						this.ADAPTER_SETTINGS_OUTLINEVALUE10 = jsonSettings[keys[i]];
					}
					else if (keys[i].endsWith('reqShowTransferButton')) {
						this.ADAPTER_SETTINGS_SHOWTRANSFERBUTTON = jsonSettings[keys[i]].isStrYes();
					}
					else if (keys[i].endsWith('reqShowTransferOneStepButton')) {
						this.ADAPTER_SETTINGS_SHOWONESTEPTRANSFERBUTTON = jsonSettings[keys[i]].isStrYes();
					}
					else if (keys[i].endsWith('reqAutoReconnect')) {
						this.ADAPTER_SETTINGS_AUTORECONNECT = jsonSettings[keys[i]].isStrYes();
					}
				}
				softphoneModel.FillWrapUpStatus();
				softphoneModel.FillLines();
				mirageTools.setLocalStorageObject(mirageOpenCTISettings.STORAGEKEY_SETTINGS, this);
				
				return true;
			}
			else {
				mirageLogger.LogError('MirageOpenCTISettings.ReadSettings_Callback returns error: ' + response.error);
			}
		}
		else {
			mirageLogger.LogError('MirageOpenCTISettings.ReadSettings_Callback was called with empty response!');
		}
	}
	catch(e) {
		mirageLogger.LogError('MirageOpenCTISettings.ReadSettings_Callback caused an exception:', e);
		return false;
	}
};
MirageOpenCTISettings.prototype.SendSettings = function () {
	openCTIInterface.SendSettings(this.SyncArray);
};
MirageOpenCTISettings.prototype.ParseJSON = function (obj) {
	if (obj) {
		this.SyncArray = obj.SyncArray;
		this.ADAPTER_SETTINGS_BTNDONOTSAVE = obj.ADAPTER_SETTINGS_BTNDONOTSAVE;
		this.ADAPTER_SETTINGS_COUNTRY_CODE = obj.ADAPTER_SETTINGS_COUNTRY_CODE;
		this.ADAPTER_SETTINGS_DONT_SHOW_INTERNAL_CALLS = obj.ADAPTER_SETTINGS_DONT_SHOW_INTERNAL_CALLS;
		this.ADAPTER_SETTINGS_INCOMING_CUTPOSTFIX = obj.ADAPTER_SETTINGS_INCOMING_CUTPOSTFIX;
		this.ADAPTER_SETTINGS_INCOMING_PREFIXTOADD = obj.ADAPTER_SETTINGS_INCOMING_PREFIXTOADD;
		this.ADAPTER_SETTINGS_INCOMING_PREFIXTOREMOVE = obj.ADAPTER_SETTINGS_INCOMING_PREFIXTOREMOVE;
		this.ADAPTER_SETTINGS_INTERNAL_MAXLEN = obj.ADAPTER_SETTINGS_INTERNAL_MAXLEN;
		this.ADAPTER_SETTINGS_INTERNATIONAL_PREFIX = obj.ADAPTER_SETTINGS_INTERNATIONAL_PREFIX;
		this.ADAPTER_SETTINGS_LONGDIST_PREFIX = obj.ADAPTER_SETTINGS_LONGDIST_PREFIX;
		this.ADAPTER_SETTINGS_OUTGOING_PREFIXTOADD = obj.ADAPTER_SETTINGS_OUTGOING_PREFIXTOADD;
		this.ADAPTER_SETTINGS_OUTGOING_PREFIXTOREMOVE = obj.ADAPTER_SETTINGS_OUTGOING_PREFIXTOREMOVE;
		this.ADAPTER_SETTINGS_OUTSIDE_PREFIX = obj.ADAPTER_SETTINGS_OUTSIDE_PREFIX;
		this.ADAPTER_SETTINGS_TRUNCATEPHONENUMBERAT = obj.ADAPTER_SETTINGS_TRUNCATEPHONENUMBERAT;
		this.ADAPTER_SETTINGS_SF_POLL_INTERVAL = obj.ADAPTER_SETTINGS_SF_POLL_INTERVAL;
		this.ADAPTER_SETTINGS_SETUP_TRANSFER_TIMEOUT = obj.ADAPTER_SETTINGS_SETUP_TRANSFER_TIMEOUT;
		this.ADAPTER_SETTINGS_OPENCTI_WS_POLL_INTERVAL = obj.ADAPTER_SETTINGS_OPENCTI_WS_POLL_INTERVAL;
		this.ADAPTER_SETTINGS_TAPILINK_WS_POLL_INTERVAL = obj.ADAPTER_SETTINGS_TAPILINK_WS_POLL_INTERVAL;
		this.ADAPTER_SETTINGS_SOFTPHONEHEIGHT = obj.ADAPTER_SETTINGS_SOFTPHONEHEIGHT;
		this.ADAPTER_SETTINGS_SOFTPHONEWIDTH = obj.ADAPTER_SETTINGS_SOFTPHONEWIDTH;
		this.ADAPTER_SETTINGS_VERSION = obj.ADAPTER_SETTINGS_VERSION;
		this.ADAPTER_SETTINGS_AUTOSAVE_INCOMINGCALLS = obj.ADAPTER_SETTINGS_AUTOSAVE_INCOMINGCALLS;
		this.ADAPTER_SETTINGS_AUTOSAVE_INTERNALCALLS = obj.ADAPTER_SETTINGS_AUTOSAVE_INTERNALCALLS;
		this.ADAPTER_SETTINGS_AUTOSAVE_OUTGOINGCALLS = obj.ADAPTER_SETTINGS_AUTOSAVE_OUTGOINGCALLS;
		this.ADAPTER_SETTINGS_AUTOSAVE_UNSUCCESSFUL_INCOMINGCALLS = obj.ADAPTER_SETTINGS_AUTOSAVE_UNSUCCESSFUL_INCOMINGCALLS;
		this.ADAPTER_SETTINGS_AUTOSAVE_UNSUCCESSFUL_INTERNALCALLS = obj.ADAPTER_SETTINGS_AUTOSAVE_UNSUCCESSFUL_INTERNALCALLS;
		this.ADAPTER_SETTINGS_AUTOSAVE_UNSUCCESSFUL_OUTGOINGCALLS = obj.ADAPTER_SETTINGS_AUTOSAVE_UNSUCCESSFUL_OUTGOINGCALLS;
		this.ADAPTER_SETTINGS_CALLER_FIELD = obj.ADAPTER_SETTINGS_CALLER_FIELD;
		this.ADAPTER_SETTINGS_CALLED_FIELD = obj.ADAPTER_SETTINGS_CALLED_FIELD;
		this.ADAPTER_SETTINGS_AUTO_EDIT_TASK = obj.ADAPTER_SETTINGS_AUTO_EDIT_TASK;
		this.ADAPTER_SETTINGS_SUBJECT = obj.ADAPTER_SETTINGS_SUBJECT;
		this.ADAPTER_SETTINGS_WRAPUPENABLE = obj.ADAPTER_SETTINGS_WRAPUPENABLE;
		this.ADAPTER_SETTINGS_WRAPUPREQUIRED = obj.ADAPTER_SETTINGS_WRAPUPREQUIRED;
		this.ADAPTER_SETTINGS_WRAPUPLABEL1 = obj.ADAPTER_SETTINGS_WRAPUPLABEL1;
		this.ADAPTER_SETTINGS_WRAPUPVALUE1 = obj.ADAPTER_SETTINGS_WRAPUPVALUE1;
		this.ADAPTER_SETTINGS_WRAPUPLABEL2 = obj.ADAPTER_SETTINGS_WRAPUPLABEL2;
		this.ADAPTER_SETTINGS_WRAPUPVALUE2 = obj.ADAPTER_SETTINGS_WRAPUPVALUE2;
		this.ADAPTER_SETTINGS_WRAPUPLABEL3 = obj.ADAPTER_SETTINGS_WRAPUPLABEL3;
		this.ADAPTER_SETTINGS_WRAPUPVALUE3 = obj.ADAPTER_SETTINGS_WRAPUPVALUE3;
		this.ADAPTER_SETTINGS_WRAPUPLABEL4 = obj.ADAPTER_SETTINGS_WRAPUPLABEL4;
		this.ADAPTER_SETTINGS_WRAPUPVALUE4 = obj.ADAPTER_SETTINGS_WRAPUPVALUE4;
		this.ADAPTER_SETTINGS_WRAPUPLABEL5 = obj.ADAPTER_SETTINGS_WRAPUPLABEL5;
		this.ADAPTER_SETTINGS_WRAPUPVALUE5 = obj.ADAPTER_SETTINGS_WRAPUPVALUE5;
		this.ADAPTER_SETTINGS_WRAPUPLABEL6 = obj.ADAPTER_SETTINGS_WRAPUPLABEL6;
		this.ADAPTER_SETTINGS_WRAPUPVALUE6 = obj.ADAPTER_SETTINGS_WRAPUPVALUE6;
		this.ADAPTER_SETTINGS_WRAPUPLABEL7 = obj.ADAPTER_SETTINGS_WRAPUPLABEL7;
		this.ADAPTER_SETTINGS_WRAPUPVALUE7 = obj.ADAPTER_SETTINGS_WRAPUPVALUE7;
		this.ADAPTER_SETTINGS_WRAPUPLABEL8 = obj.ADAPTER_SETTINGS_WRAPUPLABEL8;
		this.ADAPTER_SETTINGS_WRAPUPVALUE8 = obj.ADAPTER_SETTINGS_WRAPUPVALUE8;
		this.ADAPTER_SETTINGS_WRAPUPLABEL9 = obj.ADAPTER_SETTINGS_WRAPUPLABEL9;
		this.ADAPTER_SETTINGS_WRAPUPVALUE9 = obj.ADAPTER_SETTINGS_WRAPUPVALUE9;
		this.ADAPTER_SETTINGS_WRAPUPLABEL10 = obj.ADAPTER_SETTINGS_WRAPUPLABEL10;
		this.ADAPTER_SETTINGS_WRAPUPVALUE10 = obj.ADAPTER_SETTINGS_WRAPUPVALUE10;
		this.ADAPTER_SETTINGS_WRAPUPLABEL11 = obj.ADAPTER_SETTINGS_WRAPUPLABEL11;
		this.ADAPTER_SETTINGS_WRAPUPVALUE11 = obj.ADAPTER_SETTINGS_WRAPUPVALUE11;
		this.ADAPTER_SETTINGS_WRAPUPLABEL12 = obj.ADAPTER_SETTINGS_WRAPUPLABEL12;
		this.ADAPTER_SETTINGS_WRAPUPVALUE12 = obj.ADAPTER_SETTINGS_WRAPUPVALUE12;
		this.ADAPTER_SETTINGS_WRAPUPLABEL13 = obj.ADAPTER_SETTINGS_WRAPUPLABEL13;
		this.ADAPTER_SETTINGS_WRAPUPVALUE13 = obj.ADAPTER_SETTINGS_WRAPUPVALUE13;
		this.ADAPTER_SETTINGS_WRAPUPLABEL14 = obj.ADAPTER_SETTINGS_WRAPUPLABEL14;
		this.ADAPTER_SETTINGS_WRAPUPVALUE14 = obj.ADAPTER_SETTINGS_WRAPUPVALUE14;
		this.ADAPTER_SETTINGS_WRAPUPLABEL15 = obj.ADAPTER_SETTINGS_WRAPUPLABEL15;
		this.ADAPTER_SETTINGS_WRAPUPVALUE15 = obj.ADAPTER_SETTINGS_WRAPUPVALUE15;
		this.ADAPTER_SETTINGS_WRAPUPMISSEDCALLLABEL = obj.ADAPTER_SETTINGS_WRAPUPMISSEDCALLLABEL;
		this.ADAPTER_SETTINGS_WRAPUPMISSEDCALLVALUE = obj.ADAPTER_SETTINGS_WRAPUPMISSEDCALLVALUE;
		this.ADAPTER_SETTINGS_WRAPUPNOANSWERLABEL = obj.ADAPTER_SETTINGS_WRAPUPNOANSWERLABEL;
		this.ADAPTER_SETTINGS_WRAPUPNOANSWERVALUE = obj.ADAPTER_SETTINGS_WRAPUPNOANSWERVALUE;
		this.ADAPTER_SETTINGS_HISTORY_LENGTH = obj.ADAPTER_SETTINGS_HISTORY_LENGTH;
		this.ADAPTER_SETTINGS_AUTOASSIGN_OBJECT = obj.ADAPTER_SETTINGS_AUTOASSIGN_OBJECT;
		this.ADAPTER_SETTINGS_MANDATOR = obj.ADAPTER_SETTINGS_MANDATOR;
		this.ADAPTER_SETTINGS_MANDATOR_PASSWORD = obj.ADAPTER_SETTINGS_MANDATOR_PASSWORD;
		this.ADAPTER_SETTINGS_PARTICIPANT = obj.ADAPTER_SETTINGS_PARTICIPANT;
		this.ADAPTER_SETTINGS_OPENCTI_SERVICE_URL = obj.ADAPTER_SETTINGS_OPENCTI_SERVICE_URL;
		this.ADAPTER_SETTINGS_CONSOLE_USEINTERACTIONLOG = obj.ADAPTER_SETTINGS_CONSOLE_USEINTERACTIONLOG;
		this.ADAPTER_SETTINGS_OUTLINELABEL1 = obj.ADAPTER_SETTINGS_OUTLINELABEL1;
		this.ADAPTER_SETTINGS_OUTLINEVALUE1 = obj.ADAPTER_SETTINGS_OUTLINEVALUE1;
		this.ADAPTER_SETTINGS_OUTLINELABEL2 = obj.ADAPTER_SETTINGS_OUTLINELABEL2;
		this.ADAPTER_SETTINGS_OUTLINEVALUE2 = obj.ADAPTER_SETTINGS_OUTLINEVALUE2;
		this.ADAPTER_SETTINGS_OUTLINELABEL3 = obj.ADAPTER_SETTINGS_OUTLINELABEL3;
		this.ADAPTER_SETTINGS_OUTLINEVALUE3 = obj.ADAPTER_SETTINGS_OUTLINEVALUE3;
		this.ADAPTER_SETTINGS_OUTLINELABEL4 = obj.ADAPTER_SETTINGS_OUTLINELABEL4;
		this.ADAPTER_SETTINGS_OUTLINEVALUE4 = obj.ADAPTER_SETTINGS_OUTLINEVALUE4;
		this.ADAPTER_SETTINGS_OUTLINELABEL5 = obj.ADAPTER_SETTINGS_OUTLINELABEL5;
		this.ADAPTER_SETTINGS_OUTLINEVALUE5 = obj.ADAPTER_SETTINGS_OUTLINEVALUE5;
		this.ADAPTER_SETTINGS_OUTLINELABEL6 = obj.ADAPTER_SETTINGS_OUTLINELABEL6;
		this.ADAPTER_SETTINGS_OUTLINEVALUE6 = obj.ADAPTER_SETTINGS_OUTLINEVALUE6;
		this.ADAPTER_SETTINGS_OUTLINELABEL7 = obj.ADAPTER_SETTINGS_OUTLINELABEL7;
		this.ADAPTER_SETTINGS_OUTLINEVALUE7 = obj.ADAPTER_SETTINGS_OUTLINEVALUE7;
		this.ADAPTER_SETTINGS_OUTLINELABEL8 = obj.ADAPTER_SETTINGS_OUTLINELABEL8;
		this.ADAPTER_SETTINGS_OUTLINEVALUE8 = obj.ADAPTER_SETTINGS_OUTLINEVALUE8;
		this.ADAPTER_SETTINGS_OUTLINELABEL9 = obj.ADAPTER_SETTINGS_OUTLINELABEL9;
		this.ADAPTER_SETTINGS_OUTLINEVALUE9 = obj.ADAPTER_SETTINGS_OUTLINEVALUE9;
		this.ADAPTER_SETTINGS_OUTLINELABEL10 = obj.ADAPTER_SETTINGS_OUTLINELABEL10;
		this.ADAPTER_SETTINGS_OUTLINEVALUE10 = obj.ADAPTER_SETTINGS_OUTLINEVALUE10;
		this.ADAPTER_SETTINGS_SHOWTRANSFERBUTTON = obj.ADAPTER_SETTINGS_SHOWTRANSFERBUTTON;
		this.ADAPTER_SETTINGS_SHOWONESTEPTRANSFERBUTTON = obj.ADAPTER_SETTINGS_SHOWONESTEPTRANSFERBUTTON;
		this.ADAPTER_SETTINGS_AUTORECONNECT = obj.ADAPTER_SETTINGS_AUTORECONNECT;
	}
	else {
		mirageLogger.LogError('MirageOpenCTISettings.ParseJSON: no obj specified!');
	}
};