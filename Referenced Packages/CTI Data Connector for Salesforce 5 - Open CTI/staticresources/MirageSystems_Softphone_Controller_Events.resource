SoftphoneController.prototype.OnIncomingCall = function (call) {
	if (call) {
		mirageLogger.LogDebug('SoftphoneController.OnIncomingCall for call: ' + call.CallId);
		if (!call.CallStart) {
			call.CallStart = mirageTools.getDateTime();
			this.SaveCallObject(call);
		}
	}
	else {
		mirageLogger.LogWarn('SoftphoneController.OnIncomingCall: call is undefined');
	}
	if (softphoneModel.LabelCalledNumber().text() == '') {
		softphoneModel.PanelCalledNumber().hide();
	}

	softphoneModel.SoftPhone_IncomingCall().show();
	softphoneModel.SoftPhone_TransferedCall().hide();
	softphoneModel.SoftPhone_OutgoingCall().hide();
	softphoneModel.SoftPhone_SearchPanel().hide();
	
	softphoneModel.ActionBar_NumberPad().hide();
	softphoneModel.ActionBar_Dial().hide();
	softphoneModel.ActionBar_Answer().hide();
	softphoneModel.ShowRingingPhone();
	softphoneModel.ActionBar_Transfer().hide();
	softphoneModel.ActionBar_OneStepTransfer().hide();
	softphoneModel.ActionBar_CompleteTransfer().hide();
	softphoneModel.ActionBar_Hold().hide();
	softphoneModel.ActionBar_HangUp().show();

	openCTISFInteraction.OnIncomingCall();
	
	$('.callHistoryEdit').addClass('invisible');
	openCTISFInteraction.AutoSize();
};
SoftphoneController.prototype.OnOutgoingCall = function (call) {
	if (call) {
		mirageLogger.LogDebug('SoftphoneController.OnOutgoingCall for call: ' + call.CallId);
		if (!call.CallStart) {
			call.CallStart = mirageTools.getDateTime();
			this.SaveCallObject(call);
		}
	}
	else {
		mirageLogger.LogWarn('SoftphoneController.OnOutgoingCall: call is undefined');
	}
	softphoneModel.SoftPhone_IncomingCall().hide();
	softphoneModel.SoftPhone_TransferedCall().hide();
	softphoneModel.SoftPhone_OutgoingCall().show();
	softphoneModel.SoftPhone_SearchPanel().hide();
	
	softphoneModel.ActionBar_NumberPad().hide();
	softphoneModel.ActionBar_Dial().hide();
	softphoneModel.ActionBar_Answer().hide();
	softphoneModel.HideRingingPhone();
	softphoneModel.ActionBar_Transfer().hide();
	softphoneModel.ActionBar_OneStepTransfer().hide();
	softphoneModel.ActionBar_CompleteTransfer().hide();
	softphoneModel.ActionBar_Hold().hide();
	softphoneModel.ActionBar_HangUp().show();
	$('.callHistoryEdit').addClass('invisible');
	openCTISFInteraction.AutoSize();
};
SoftphoneController.prototype.OnCallEnd = function (call) {
	this.StopCallDuration();
	softphoneModel.LabelCallAditionalInfo().val('');
	softphoneModel.SoftPhone_CallInfoLittle().hide();
	if (call) {
		mirageLogger.LogDebug('SoftphoneController.OnCallEnd for call: ' + call.CallId);
		if (!call.CallEnd) {
			call.CallEnd = mirageTools.getDateTime();
			this.SaveCallObject(call);
		}
		openCTISFInteraction.OnEndCall(call);
		
		if ((call.WhoId) &&
			(openCTISFInteraction.getTypeOfId(call.WhoId) == 'Lead')) {
			mirageLogger.LogDebug('SoftphoneController.OnCallEnd check lead: ' + call.WhoId);
			CheckLeadConversion(call.WhoId, call.CallId, false);
		}
	}
	else {
		//OnCallEnd is also called to clean up
		//mirageLogger.LogWarn('SoftphoneController.OnCallEnd: call is undefined');
	}
	softphoneModel.TextSearchValue().val('');

	if (!softphoneModel.IsOnWrapUp()) {
		softphoneModel.SoftPhone_SearchPanel().show();
		softphoneModel.ActionBar_NumberPad().show();
		softphoneModel.ActionBar_Dial().show();
	}
	softphoneModel.SoftPhone_IncomingCall().hide();
	softphoneModel.SoftPhone_TransferedCall().hide();
	softphoneModel.SoftPhone_OutgoingCall().hide();
	softphoneModel.SoftPhone_CallActions().hide();
	
	softphoneModel.LabelCallingNumber().text('');
	softphoneModel.LabelCallingName().text('');
	softphoneModel.LabelCalledNumber().text('');
	softphoneModel.HiddenCallId().val('');
	softphoneModel.HiddenLastAction().val('');
	softphoneModel.CallInfo().empty();
	
	softphoneModel.ActionBar_Answer().hide();
	softphoneModel.HideRingingPhone();
	softphoneModel.ActionBar_Transfer().hide();
	softphoneModel.ActionBar_OneStepTransfer().hide();
	softphoneModel.ActionBar_CompleteTransfer().hide();
	softphoneModel.ActionBar_Hold().hide();
	softphoneModel.ActionBar_HangUp().hide();

	softphoneModel.SoftPhone_ShowOnCallEnd().show();
	if (openCTISFInteraction.UseInteractionLog()) {
		softphoneModel.SoftPhone_ShowOnCallEndIfNotIL().hide();
		softphoneModel.SoftPhone_ShowOnCallEndIfIL().show();
	}
	else {
		softphoneModel.SoftPhone_ShowOnCallEndIfNotIL().show();
		softphoneModel.SoftPhone_ShowOnCallEndIfIL().hide();
	}
	
	if (call) {	this.HandleAutoOpenTask(call); }
	$('.callHistoryEdit').removeClass('invisible');
	openCTISFInteraction.AutoSize();
};
SoftphoneController.prototype.OnAnswer = function (call) {
	if (call) {
		mirageLogger.LogDebug('SoftphoneController.OnAnswer for call: ' + call.CallId);
		//softphoneModel.SoftPhone_InfoPanel().show();
		softphoneModel.SoftPhone_CallInfoLittle().show();
		if (!call.Answered) {
			call.Answered = true;
			call.OnHold = false;
			call.AnsweredAt = mirageTools.getDateTime();
			this.SaveCallObject(call);

			openCTISFInteraction.OnBeginCall(call);
		}
		if (call.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_OUTGOING) {
			if (call.DialedNumber) {
				softphoneModel.LabelOutgoingNumber().text(call.DialedNumber.Number);
			}
		}
		else {
			if (call.CallerNumber) {
				softphoneModel.LabelCallingNumber().text(call.CallerNumber.Number);
			}
			if (call.DialedNumber) {
				softphoneModel.LabelCalledNumber().text(call.DialedNumber.Number);
			}
		}
		this.StartCallDuration(call);
	}
	else {
		mirageLogger.LogWarn('SoftphoneController.OnAnswer: call is undefined');
	}
	softphoneModel.ActionBar_NumberPad().hide();
	softphoneModel.ActionBar_Dial().hide();
	softphoneModel.ActionBar_Answer().hide();
	softphoneModel.HideRingingPhone();
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_SHOWTRANSFERBUTTON) {
		if (call.IsOnTransfer) {
			softphoneModel.ActionBar_CompleteTransfer().show();
		}
		else {
			softphoneModel.ActionBar_Transfer().show();
		}
	}
	if (mirageOpenCTISettings.ADAPTER_SETTINGS_SHOWONESTEPTRANSFERBUTTON) {
		softphoneModel.ActionBar_OneStepTransfer().show();
	}
	softphoneModel.SoftPhone_SearchPanel().hide();
	softphoneModel.ActionBar_Hold().show();
	softphoneModel.ActionBar_HangUp().show();
	openCTISFInteraction.AutoSize();
};
SoftphoneController.prototype.OnHold = function (call) {
	if (call) {
		mirageLogger.LogDebug('SoftphoneController.OnHold for call: ' + call.CallId);
		if (!call.OnHold) {
			call.OnHold = true;
			this.SaveCallObject(call);
		}
		//this.ReadCallWrapUp(call);
	}
	else {
		mirageLogger.LogWarn('SoftphoneController.OnHold: call is undefined');
	}
	this.StopCallDuration();
	softphoneModel.ActionBar_Hold().hide();
	softphoneModel.ActionBar_Answer().show();
	softphoneModel.HideRingingPhone();
	openCTISFInteraction.AutoSize();
};
SoftphoneController.prototype.Action_NumberPad = function () {
	softphoneModel.SoftPhone_NumberPad().toggle();
	openCTISFInteraction.AutoSize();
};
SoftphoneController.prototype.Action_Dial = function () {
	if (softphoneModel.TextSearchValue().val() != '') {
		openCTIInterface.Dial(softphoneModel.TextSearchValue().val(), softphoneModel.DropDownListLines().val(), '', '', '');
	}
	else {
		softphoneModel.TextSearchValue().focus();
	}
};
SoftphoneController.prototype.Action_Answer = function () {
	openCTIInterface.Answer(softphoneModel.HiddenCallId().val());
};
SoftphoneController.prototype.Action_Transfer = function () {
	if (softphoneModel.TextSearchValue().val()) {
		openCTIInterface.Transfer(softphoneModel.HiddenCallId().val(), softphoneModel.TextSearchValue().val());
	}
	else {
		softphoneModel.ShowTransfer();
	}
};
SoftphoneController.prototype.Action_CompleteTransfer = function () {
	openCTIInterface.CompleteTransfer(softphoneModel.HiddenCallId().val());
};
SoftphoneController.prototype.Action_OneStepTransfer = function () {
	if (softphoneModel.TextSearchValue().val()) {
		openCTIInterface.OneStepTransfer(softphoneModel.HiddenCallId().val(), softphoneModel.TextSearchValue().val());
	}
	else {
		softphoneModel.ShowTransfer();
	}
};
SoftphoneController.prototype.Action_Pause = function () {
	openCTIInterface.Pause(softphoneModel.HiddenCallId().val());
};
SoftphoneController.prototype.Action_Resume = function () {
	openCTIInterface.Resume(softphoneModel.HiddenCallId().val());
};
SoftphoneController.prototype.Action_HangUp = function () {
	openCTIInterface.HangUp(softphoneModel.HiddenCallId().val());
};
SoftphoneController.prototype.Action_CallHistory = function () {
	softphoneModel.SoftPhone_CallHistory().toggle();
	var vis = softphoneModel.SoftPhone_CallHistory().is(':visible');
	mirageTools.setLocalStorageValue(mirageOpenCTISettings.STORAGEKEY_CALLHISTORYVISIBLE, vis); 
	openCTISFInteraction.AutoSize();
};
SoftphoneController.prototype.Action_Assign = function () {
	this.AssignObject(null, null, true);
};
SoftphoneController.prototype.CallWrapUp_Save = function (callback, force) {
	try {
		if (softphoneModel.HiddenCallWrapUpCallId().val()) {
			mirageLogger.LogDebug('SoftphoneController.CallWrapUp_Save for call: ' + softphoneModel.HiddenCallWrapUpCallId().val() + ' force: ' + force + ' setting ' + mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPREQUIRED);
			if ((!force) && 
				(!softphoneModel.DropDownListWrapUpStatus().val()) &&
				(mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPENABLE) &&
				(mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPREQUIRED) &&
				//(!softphoneModel.CheckBoxDontSave().prop('checked'))) {
				(!softphoneModel.DontSaveCall())) {
				softphoneModel.Hint('specify', 'disposition');
			}
			else {
				softphoneModel.LabelCallDuration().text('');
				
				var callId = softphoneModel.HiddenCallWrapUpCallId().val();
				var call = openCTIObjectWorker.CallById(callId);
				if (call) {
					this.ReadCallWrapUp(call);
					this.SaveCall(call, false, false, callback);
					softphoneModel.HiddenCallWrapUpCallId().val('');
					this.CloseWrapUp();
				}
				else {
					if (callback) { callback(); }
				}
			}
		}
		else {
			this.CloseWrapUp();
			if (callback) { callback(); }
		}
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.CallWrapUp_Save caused an exception:', e);
	}
};
SoftphoneController.prototype.ReadCallWrapUp = function (call) {
	try {
		var changed = false;
		if ((softphoneModel.HiddenCallWrapUpCallId().val()) &&
			(call.CallId == softphoneModel.HiddenCallWrapUpCallId().val())) {
			mirageLogger.LogDebug('SoftphoneController.ReadCallWrapUp for call: ' + call.CallId);
			if (call.Subject != softphoneModel.TextCallSubject().val()) {
				call.Subject = softphoneModel.TextCallSubject().val();
				changed = true;
			}
			if (call.Comment != softphoneModel.TextCallDescription().val()) {
				call.Comment = softphoneModel.TextCallDescription().val();
				changed = true;
			}
			if (call.Disposition != softphoneModel.DropDownListWrapUpStatus().val()) {
				call.Disposition = softphoneModel.DropDownListWrapUpStatus().val();
				changed = true;
			}
			/*if (call.DoNotSave != softphoneModel.CheckBoxDontSave().prop('checked')) {
				call.DoNotSave = softphoneModel.CheckBoxDontSave().prop('checked');
				changed = true;
			}*/
			if (call.DoNotSave != softphoneModel.DontSaveCall()) {
				call.DoNotSave = softphoneModel.DontSaveCall();
				changed = true;
			}
			if (changed) {
				this.SaveCallObject(call);
			}
		}
		else {
			mirageLogger.LogDebug('SoftphoneController.ReadCallWrapUp call ' + call.CallId + ' isn\'t active in wrapup');
		}
		return changed;
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.ReadCallWrapUp caused an exception:', e);
		return false;
	}
};
SoftphoneController.prototype.WriteCallWrapUp = function (call) {
	try {
		if ((softphoneModel.HiddenCallWrapUpCallId().val()) &&
			(call.CallId == softphoneModel.HiddenCallWrapUpCallId().val())) {
			mirageLogger.LogDebug('SoftphoneController.WriteCallWrapUp for call: ' + call.CallId);
			if (call.Subject) {
				softphoneModel.TextCallSubject().val(call.Subject);
			}
			else {
				softphoneModel.TextCallSubject().val(mirageTools.CreateCallSubject(call));
			}
			softphoneModel.TextCallDescription().val(call.Comment);
			if (call.Disposition) {
				softphoneModel.DropDownListWrapUpStatus().val(call.Disposition);
			}
			else {
				//softphoneModel.DropDownListWrapUpStatus().val(softphoneModel.DropDownListWrapUpStatus().first().val());
				softphoneModel.DropDownListWrapUpStatus()[0].selectedIndex = 0;
			}
			if (call.DoNotSave) {
				softphoneModel.CheckBoxDontSave().prop('checked', true);
			}
			else {
				softphoneModel.CheckBoxDontSave().prop('checked', false);
			}
			this.setAssignedTo(call);
		}
		else {
			mirageLogger.LogDebug('SoftphoneController.WriteCallWrapUp call ' + call.CallId + ' isn\'t active in wrapup');
		}
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.WriteCallWrapUp caused an exception:', e);
	}
};
SoftphoneController.prototype.CallWrapUp_Cancel = function () {
	mirageLogger.LogDebug('SoftphoneController.CallWrapUp_Cancel for call: ' + softphoneModel.HiddenCallWrapUpCallId().val());
	softphoneModel.LabelCallDuration().text('');
	softphoneModel.HiddenCallWrapUpCallId().val('');
	this.CloseWrapUp();
};
SoftphoneController.prototype.CloseWrapUp = function () {
	mirageLogger.LogDebug('SoftphoneController.CloseWrapUp called');
	softphoneModel.CheckBoxDontSave().prop('checked', false);//reset control
	softphoneModel.SoftPhone_CallWrapUp().hide();
	//if (softphoneModel.HiddenCallWrapUpCallId().val() == softphoneModel.HiddenCallId().val()) {
	if (!softphoneModel.IsOnCall()) {
		softphoneModel.SoftPhone_SearchPanel().show();
		softphoneModel.ActionBar_NumberPad().show();
		softphoneModel.ActionBar_Dial().show();
	}
	mirageTools.setLocalStorageValue(mirageOpenCTISettings.STORAGEKEY_WRAPUP, '');
	//softphoneModel.SoftPhone_InfoPanel().hide();
	softphoneModel.SoftPhone_CallActions().hide();
	openCTISFInteraction.AutoSize();
};