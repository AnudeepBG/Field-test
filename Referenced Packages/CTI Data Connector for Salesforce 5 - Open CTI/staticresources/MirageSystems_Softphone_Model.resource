
//constructor
function SoftphoneModel() {
	this.CallHistory = new Array();
}
//properties
SoftphoneModel.prototype.ContactListLength = function() {
	if ((typeof $('.idContactListLength').val() != 'undefined') &&
		($('.idContactListLength').val() != '')) {
		return parseInt($('.idContactListLength').val());
	}
	else {
		return 0;
	}
};
SoftphoneModel.prototype.AccountListLength = function() {
	if ((typeof $('.idAccountListLength').val() != 'undefined') &&
		($('.idAccountListLength').val() != '')) {
		return parseInt($('.idAccountListLength').val());
	}
	else {
		return 0;
	}
};
//controls
SoftphoneModel.prototype.ContactResultHeader = function() {
	return $('#rlhContacts');
};
SoftphoneModel.prototype.AccountResultHeader = function() {
	return $('#rlhAccounts');
};
SoftphoneModel.prototype.ContactResultList = function() {
	return $('#contactList');
};
SoftphoneModel.prototype.AccountResultList = function() {
	return $('#accountList');
};
SoftphoneModel.prototype.ResultLists = function() {
	return $('#resultLists');
};
SoftphoneModel.prototype.LabelCallDuration = function() {
	return $('#lblCallDuration');
};
SoftphoneModel.prototype.LabelCallAditionalInfo = function() {
	return $('#lblCallAditionalInfo');
};
SoftphoneModel.prototype.LabelCallingNumber = function() {
	return $('#lblCallingNumber');
};
SoftphoneModel.prototype.LabelCallingName = function() {
	return $('.lblCallingName');
};
SoftphoneModel.prototype.LabelCalledNumber = function() {
	return $('#lblCalledNumber');
};
SoftphoneModel.prototype.LabelTransferedNumber = function() {
	return $('#lblTransferedNumber');
};
SoftphoneModel.prototype.LabelTransferedFrom = function() {
	return $('#lblTransferedFrom');
};
SoftphoneModel.prototype.LabelCalledNumber = function() {
	return $('#lblCalledNumber');
};
SoftphoneModel.prototype.LabelOutgoingNumber = function() {
	return $('#lblOutgoingNumber');
};
SoftphoneModel.prototype.HeaderOCTI = function() {
	return $('#octiHeader');
};
SoftphoneModel.prototype.TextSearchValue = function() {
	return $('.idSearchValue');
};
SoftphoneModel.prototype.TextContactListLength = function() {
	return $('.idContactListLength');
};
SoftphoneModel.prototype.TextAccountListLength = function() {
	return $('.idAccountListLength');
};
SoftphoneModel.prototype.TextSingleId = function() {
	return $('.idSingleId');
};
SoftphoneModel.prototype.TextSingleName = function() {
	return $('.idSingleName');
};
SoftphoneModel.prototype.TextSearchType = function() {
	return $('.idSearchType');
};
SoftphoneModel.prototype.TextUsername = function() {
	return $('#username');
};
SoftphoneModel.prototype.TextCallSubject = function() {
	return $('#callSubject');
};
SoftphoneModel.prototype.TextCallDescription = function() {
	return $('#callDescription');
};
SoftphoneModel.prototype.CheckBoxDontSave = function() {
	return $('#chkDontSave');
};
SoftphoneModel.prototype.LabelDontSave = function() {
	return $('#lblDontSave');
};
SoftphoneModel.prototype.LabelAssignObject = function() {
	return $('#lblAssignObject');
};
SoftphoneModel.prototype.PanelAuthenticate = function() {
	return $('#authenticate');
};
SoftphoneModel.prototype.PanelSoftPhone = function() {
	return $('#softPhone');
};
SoftphoneModel.prototype.PanelCallingNumber = function() {
	return $('#divCallingNumber');
};
SoftphoneModel.prototype.PanelCalledNumber = function() {
	return $('#divCalledNumber');
};
SoftphoneModel.prototype.PanelTransferedNumber = function() {
	return $('#divTransferedNumber');
};
SoftphoneModel.prototype.PanelTransferedFrom = function() {
	return $('#divTransferedFrom');
};
SoftphoneModel.prototype.PanelCallWrapUpAssignedTo = function() {
	return $('#assignedTo');
};
SoftphoneModel.prototype.PanelHint = function() {
	return $('#hintPanel');
};
SoftphoneModel.prototype.PanelLines = function() {
	return $('#linesPanel');
};
SoftphoneModel.prototype.ButtonAuthenticate = function() {
	return $('#btnAuthenticate');
};
/*SoftphoneModel.prototype.ButtonStopRequesting = function() {
	return $('#btnStopRequesting');
};
SoftphoneModel.prototype.ButtonStartRequesting = function() {
	return $('#btnStartRequesting');
};*/
SoftphoneModel.prototype.ButtonCallWrapUpSave = function() {
	return $('#btnCallWrapUpSave');
};
SoftphoneModel.prototype.ButtonCallWrapUpCancel = function() {
	return $('#btnCallWrapUpCancel');
};
/*SoftphoneModel.prototype.ButtonAssignObject = function() {
	return $('#btnAssignObject');
};*/
SoftphoneModel.prototype.HiddenSFUsername = function() {
	return $('.idSFUsername');
};
SoftphoneModel.prototype.HiddenSFUserId = function() {
	return $('.idSFUserId');
};
SoftphoneModel.prototype.HiddenSFUserLanguage = function() {
	return $('.idSFUserLanguage');
};
SoftphoneModel.prototype.HiddenSFUserSessID = function() {
	return $('.idSFUserSessID');
};
SoftphoneModel.prototype.HiddenSelectedList = function() {
	return $('.idSelectedList');
};
SoftphoneModel.prototype.HiddenCallId = function() {
	return $('#hfCallId');
};
SoftphoneModel.prototype.HiddenAnswerOnHoldCallId = function() {
	return $('#hfAnswerOnHoldCallId');
};
SoftphoneModel.prototype.HiddenRemovedTaskCallId = function() {
	return $('.idRemovedTaskCallId');
};
SoftphoneModel.prototype.HiddenRemoveTaskResult = function() {
	return $('.idRemoveTaskResult');
};
SoftphoneModel.prototype.HiddenExistsTaskCallId = function() {
	return $('.idExistsTaskCallId');
};
SoftphoneModel.prototype.HiddenExistsTaskResult = function() {
	return $('.idExistsTaskResult');
};
SoftphoneModel.prototype.HiddenCheckTaskCallId = function() {
	return $('.idCheckTaskCallId');
};
SoftphoneModel.prototype.HiddenCheckTaskResult = function() {
	return $('.idCheckTaskResult');
};
SoftphoneModel.prototype.HiddenCheckLeadConvCallId = function() {
	return $('.idCheckLeadConvCallId');
};
SoftphoneModel.prototype.HiddenCheckLeadConvResult = function() {
	return $('.idCheckLeadConvResult');
};
SoftphoneModel.prototype.HiddenCheckLeadConvDoSave = function() {
	return $('.idCheckLeadConvDoSave');
};
SoftphoneModel.prototype.HiddenCheckLeadDoSave = function() {
	return $('.idCheckLeadDoSave');
};
SoftphoneModel.prototype.HiddenReadInfoCallId = function() {
	return $('.idReadInfoCallId');
};
SoftphoneModel.prototype.HiddenReadTaskBasicsResult = function() {
	return $('.idReadTaskBasicsResult');
};
SoftphoneModel.prototype.HiddenNumberSearchCallId = function() {
	return $('.idNumberSearchCallId');
};
SoftphoneModel.prototype.HiddenNumberSearchResult = function() {
	return $('.idNumberSearchResult');
};
SoftphoneModel.prototype.HiddenReadInfoResult = function() {
	return $('.idReadInfoResult');
};
SoftphoneModel.prototype.HiddenCallWrapUpCallId = function() {
	return $('#hfCallWrapUpCallId');
};
SoftphoneModel.prototype.HiddenLastAction = function() {
	return $('#hfLastAction');
};
SoftphoneModel.prototype.HintAuthentication = function() {
	return $('#hintAuthentication');
};
SoftphoneModel.prototype.DropDownListWrapUpStatus = function() {
	return $('#ddlWrapUpStatus');
};
SoftphoneModel.prototype.DropDownListLines = function() {
	return $('#ddlLines');
};
SoftphoneModel.prototype.SoftPhone_InfoPanel = function() {
	return $('#infoPanel');
};
SoftphoneModel.prototype.SoftPhone_SearchPanel = function() {
	return $('#searchPanel');
};
SoftphoneModel.prototype.SoftPhone_IncomingCall = function() {
	return $('#incomingCall');
};
SoftphoneModel.prototype.SoftPhone_TransferedCall = function() {
	return $('#transferedCall');
};
SoftphoneModel.prototype.SoftPhone_OutgoingCall = function() {
	return $('#outgoingCall');
};
SoftphoneModel.prototype.SoftPhone_WaitingCalls = function() {
	return $('#waitingCalls');
};
SoftphoneModel.prototype.SoftPhone_NumberPad = function() {
	return $('#numberPad');
};
SoftphoneModel.prototype.SoftPhone_ActionBar = function() {
	return $('#actionBar');
};
SoftphoneModel.prototype.SoftPhone_CallActions = function() {
	return $('#callActions');
};
SoftphoneModel.prototype.SoftPhone_CallWrapUp = function() {
	return $('#callWrapUp');
};
SoftphoneModel.prototype.SoftPhone_ShowOnCallEnd = function() {
	return $('.showOnCallEnd');
};
SoftphoneModel.prototype.SoftPhone_ShowOnCallEndIfNotIL = function() {
	return $('.showOnCallEndIfNotIL');
};
SoftphoneModel.prototype.SoftPhone_ShowOnCallEndIfIL = function() {
	return $('.showOnCallEndIfIL');
};
SoftphoneModel.prototype.SoftPhone_CallHistory = function() {
	return $('#callHistory');
};
SoftphoneModel.prototype.SoftPhone_CallHistoryHead = function() {
	return $('#callHistoryHead');
};
SoftphoneModel.prototype.SoftPhone_CallInfoLittle = function() {
	return $('.callInfoLittle');
};
SoftphoneModel.prototype.ActionBar_NumberPad = function() {
	return $('#imgNumberPad');
};
SoftphoneModel.prototype.ActionBar_Dial = function() {
	return $('#imgDial');
};
SoftphoneModel.prototype.ActionBar_Answer = function() {
	return $('#imgAnswer');
};
SoftphoneModel.prototype.ActionBar_Ringing = function() {
	return $('#ringing');
};
SoftphoneModel.prototype.ActionBar_Transfer = function() {
	return $('#imgTransfer');
};
SoftphoneModel.prototype.ActionBar_OneStepTransfer = function() {
	return $('#imgOneStepTransfer');
};
SoftphoneModel.prototype.ActionBar_CompleteTransfer = function() {
	return $('#imgCompleteTransfer');
};
SoftphoneModel.prototype.ActionBar_Hold = function() {
	return $('#imgHold');
};
SoftphoneModel.prototype.ActionBar_HangUp = function() {
	return $('#imgHangUp');
};
SoftphoneModel.prototype.ImageConnectionState = function() {
	return $('#imgConnectionState');
};
SoftphoneModel.prototype.ActionBar_CallHistory = function() {
	return $('#ShowCallHistory');
};
SoftphoneModel.prototype.NotInConsole = function() {
	return $('.notInConsole'); 
};
SoftphoneModel.prototype.IsOnCall = function() {
	return this.HiddenCallId().val() != ''; 
};
SoftphoneModel.prototype.IsOnWrapUp = function() {
	return this.HiddenCallWrapUpCallId().val() != ''; 
};
SoftphoneModel.prototype.CallInfo = function() {
	return $('#divCallInfo'); 
};
SoftphoneModel.prototype.setConnectionStateGreen = function() {
	this.ImageConnectionState().attr('src', $('#imgConStateConnectedCDC').attr('src'));
	this.ImageConnectionState().attr('alt', Translate('app.connection.stop', 'stop'));
	this.ImageConnectionState().attr('title', Translate('app.connection.stop', 'stop'));
};
SoftphoneModel.prototype.setConnectionStateRed = function() {
	this.ImageConnectionState().attr('src', $('#imgConStateDisconnected').attr('src'));
	this.ImageConnectionState().attr('alt', Translate('app.connection.start', 'start'));
	this.ImageConnectionState().attr('title', Translate('app.connection.start', 'start'));
};
SoftphoneModel.prototype.setConnectionStateYellow = function() {
	this.ImageConnectionState().attr('src', $('#imgConStateConnectedWS').attr('src'));
	this.ImageConnectionState().attr('alt', Translate('app.connection.stop', 'stop'));
	this.ImageConnectionState().attr('title', Translate('app.connection.stop', 'stop'));
};
SoftphoneModel.prototype.ShowRingingPhone = function() {
	try {
		this.ActionBar_Ringing().show();
		$('#ringing').cycle({
			fx: 'none',
			timeout: 100
		});
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneModel.ShowRingingPhone caused an exception:', e);
	}
};
SoftphoneModel.prototype.HideRingingPhone = function() {
	try {
		this.ActionBar_Ringing().hide();
		$('#ringing').cycle('destroy');
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneModel.HideRingingPhone caused an exception:', e);
	}
};
/*
SoftphoneModel.prototype. = function() {
	return $('#'); 
};*/
//methods
SoftphoneModel.prototype.Hint = function (type, subtype, replaceParam1) {
	try {
		var hint;
		var css;
		var timeout = false;
		this.PanelHint().attr('class', 'softphoneblock');//reset css
		if (type ==  'specify') {
			if (subtype == 'disposition') {
				hint = Translate('hint.specify.disposition', 'You have to specify a disposition!');
				css = 'required';
				timeout = true;
			}
		}
		else if (type ==  'wrongversion') {
			if (subtype == 'webservice') {
				hint = Translate('hint.wrongversion.webservice', 'The OpenCTI Service URL is wrong. Version {0} is required.')
					.replace('{0}', replaceParam1);
				css = 'required';
				timeout = false;
			}
		}
		else if (type ==  'general') {
			if (subtype == 'leadconversion') {
				hint = Translate('hint.general.leadconversion', 'The assigned lead has been converted, please reassign the contact.')
					.replace('{0}', replaceParam1);
				css = 'required';
				timeout = true;
			}
			else if (subtype == 'savefailed') {
				hint = Translate('hint.general.savefailed', 'The last call could not be saved. Please try again.')
					.replace('{0}', replaceParam1);
				css = 'required';
				timeout = true;
			}
		}
		
		if (hint) {
			this.PanelHint().html(hint);
			if (css) { this.PanelHint().addClass(css); }
			this.PanelHint().show();
			openCTISFInteraction.AutoSize();
		}
		if (timeout) {
			setTimeout(function() {
				softphoneModel.PanelHint().hide();
				openCTISFInteraction.AutoSize();
			}, 5000);
		}
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneModel.Hint caused an exception:', e);
	}
};
SoftphoneModel.prototype.FillWrapUpStatus = function() {
	this.DropDownListWrapUpStatus().find('option').remove();
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL1 != '') {
		this.DropDownListWrapUpStatus().append($('<option>', {
			value: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPVALUE1,
			text: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL1
		}));
	}
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL2 != '') {
		this.DropDownListWrapUpStatus().append($('<option>', {
			value: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPVALUE2,
			text: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL2
		}));
	}
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL3 != '') {
		this.DropDownListWrapUpStatus().append($('<option>', {
			value: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPVALUE3,
			text: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL3
		}));
	}
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL4 != '') {
		this.DropDownListWrapUpStatus().append($('<option>', {
			value: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPVALUE4,
			text: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL4
		}));
	}
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL5 != '') {
		this.DropDownListWrapUpStatus().append($('<option>', {
			value: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPVALUE5,
			text: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL5
		}));
	}
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL6 != '') {
		this.DropDownListWrapUpStatus().append($('<option>', {
			value: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPVALUE6,
			text: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL6
		}));
	}
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL7 != '') {
		this.DropDownListWrapUpStatus().append($('<option>', {
			value: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPVALUE7,
			text: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL7
		}));
	}
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL8 != '') {
		this.DropDownListWrapUpStatus().append($('<option>', {
			value: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPVALUE8,
			text: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL8
		}));
	}
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL9 != '') {
		this.DropDownListWrapUpStatus().append($('<option>', {
			value: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPVALUE9,
			text: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL9
		}));
	}
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL10 != '') {
		this.DropDownListWrapUpStatus().append($('<option>', {
			value: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPVALUE10,
			text: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL10
		}));
	}
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL11 != '') {
		this.DropDownListWrapUpStatus().append($('<option>', {
			value: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPVALUE11,
			text: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL11
		}));
	}
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL12 != '') {
		this.DropDownListWrapUpStatus().append($('<option>', {
			value: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPVALUE12,
			text: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL12
		}));
	}
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL13 != '') {
		this.DropDownListWrapUpStatus().append($('<option>', {
			value: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPVALUE13,
			text: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL13
		}));
	}
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL14 != '') {
		this.DropDownListWrapUpStatus().append($('<option>', {
			value: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPVALUE14,
			text: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL14
		}));
	}
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL15 != '') {
		this.DropDownListWrapUpStatus().append($('<option>', {
			value: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPVALUE15,
			text: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPLABEL15
		}));
	}
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPMISSEDCALLLABEL != '') {
		this.DropDownListWrapUpStatus().append($('<option>', {
			value: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPMISSEDCALLVALUE,
			text: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPMISSEDCALLLABEL
		}));
	}
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPNOANSWERLABEL != '') {
		this.DropDownListWrapUpStatus().append($('<option>', {
			value: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPNOANSWERVALUE,
			text: mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPNOANSWERLABEL
		}));
	}
};
SoftphoneModel.prototype.FillLines = function() {
	this.DropDownListLines().find('option').remove();
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINELABEL1 != '') {
		this.DropDownListLines().append($('<option>', {
			value: mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE1,
			text: mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINELABEL1
		}));
	}
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINELABEL2 != '') {
		this.DropDownListLines().append($('<option>', {
			value: mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE2,
			text: mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINELABEL2
		}));
	}
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINELABEL3 != '') {
		this.DropDownListLines().append($('<option>', {
			value: mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE3,
			text: mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINELABEL3
		}));
	}
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINELABEL4 != '') {
		this.DropDownListLines().append($('<option>', {
			value: mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE4,
			text: mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINELABEL4
		}));
	}
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINELABEL5 != '') {
		this.DropDownListLines().append($('<option>', {
			value: mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE5,
			text: mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINELABEL5
		}));
	}
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINELABEL6 != '') {
		this.DropDownListLines().append($('<option>', {
			value: mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE6,
			text: mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINELABEL6
		}));
	}
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINELABEL7 != '') {
		this.DropDownListLines().append($('<option>', {
			value: mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE7,
			text: mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINELABEL7
		}));
	}
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINELABEL8 != '') {
		this.DropDownListLines().append($('<option>', {
			value: mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE8,
			text: mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINELABEL8
		}));
	}
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINELABEL9 != '') {
		this.DropDownListLines().append($('<option>', {
			value: mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE9,
			text: mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINELABEL9
		}));
	}
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINELABEL10 != '') {
		this.DropDownListLines().append($('<option>', {
			value: mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINEVALUE10,
			text: mirageOpenCTISettings.ADAPTER_SETTINGS_OUTLINELABEL10
		}));
	}
	if (this.DropDownListLines().find('option').size() > 1) {
		this.PanelLines().show();
	}
	else {
		this.PanelLines().hide();
	}
	openCTISFInteraction.AutoSize();
};
SoftphoneModel.prototype.ShowTransfer = function(number) {
	softphoneModel.SoftPhone_SearchPanel().show();
	if (number) {
		softphoneModel.TextSearchValue().val(number);
	}
	else{
		softphoneModel.TextSearchValue().focus();
	}
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_SHOWONESTEPTRANSFERBUTTON) {
		softphoneModel.ActionBar_OneStepTransfer().show();
	}
};
SoftphoneModel.prototype.DontSaveCall = function() {
	/*if (softphoneModel.CheckBoxDontSave().prop('checked')) {
		mirageLogger.LogDebug('SoftphoneModel.DontSaveCall will return true (prop)');
		return true;
	}
	else if (softphoneModel.CheckBoxDontSave().attr('checked')) {
		mirageLogger.LogDebug('SoftphoneModel.DontSaveCall will return true (attr)');
		return true;
	}
	else {
		mirageLogger.LogDebug('SoftphoneModel.DontSaveCall will return false');
		return false;
	}*/
	return $('#chkDontSave:checked').length == 1;
};