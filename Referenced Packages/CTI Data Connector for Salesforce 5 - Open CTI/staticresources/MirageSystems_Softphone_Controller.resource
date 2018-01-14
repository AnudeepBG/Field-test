//constructor
function SoftphoneController() {
	try {
		this.durationInterval = null;
		
		var obj = this;
		obj.InitView();
	    openCTISFInteraction.InitSoftphone(mirageOpenCTISettings.ADAPTER_SETTINGS_SOFTPHONE_WIDTH,
	    	mirageOpenCTISettings.ADAPTER_SETTINGS_SOFTPHONE_HEIGHT,
	    	function() {
				//obj.InitView();
				obj.InitEvents();
			});
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.constructor caused an exception:', e);
	}
}

//methods
SoftphoneController.prototype.InitView = function () {
	try {
		//softphoneModel.SoftPhone_InfoPanel().hide();
		softphoneModel.SoftPhone_SearchPanel().show();
		softphoneModel.SoftPhone_IncomingCall().hide();
		softphoneModel.SoftPhone_TransferedCall().hide();
		softphoneModel.SoftPhone_OutgoingCall().hide();
		softphoneModel.SoftPhone_NumberPad().hide();
		softphoneModel.SoftPhone_ActionBar().show();
		softphoneModel.SoftPhone_CallActions().hide();
		softphoneModel.SoftPhone_CallWrapUp().hide();
		softphoneModel.SoftPhone_CallHistory().hide();
		softphoneModel.SoftPhone_ShowOnCallEnd().hide();
		softphoneModel.SoftPhone_ShowOnCallEndIfIL().hide();
		softphoneModel.PanelHint().hide();
		
		softphoneModel.ActionBar_NumberPad().show();
		softphoneModel.ActionBar_Dial().show();
		softphoneModel.ActionBar_Answer().hide();
		softphoneModel.HideRingingPhone();
		softphoneModel.ActionBar_Transfer().hide();
		softphoneModel.ActionBar_OneStepTransfer().hide();
		softphoneModel.ActionBar_CompleteTransfer().hide();
		softphoneModel.ActionBar_Hold().hide();
		softphoneModel.ActionBar_HangUp().hide();

		softphoneModel.HeaderOCTI().attr('alt', 'Softphone ' + mirageOpenCTISettings.VERSION);
		softphoneModel.HeaderOCTI().attr('title', 'Softphone ' + mirageOpenCTISettings.VERSION);
		
		if (openCTISFInteraction.isInConsole) {
			softphoneModel.NotInConsole().hide();
			$('#mirageSystemsOpenCTI').removeClass('mirageSystemsOpenCTI');
			$('#mirageSystemsOpenCTI').addClass('mirageSystemsOpenCTIConsole');
			if (openCTISFInteraction.UseInteractionLog()) {
				$('#divCallDescription').hide();
			}
		}
		
		/*if (mirageOpenCTISettings.ADAPTER_SETTINGS_AUTOASSIGN_OBJECT) {
			softphoneModel.ButtonAssignObject().hide();
		}*/
		$('#softphone').removeClass('invisible');
		$('#initializing').addClass('invisible');
		
		if (!mirageOpenCTISettings.ADAPTER_SETTINGS_BTNDONOTSAVE) {
			softphoneModel.CheckBoxDontSave().addClass('invisible');
			softphoneModel.LabelDontSave().addClass('invisible');
		}
		var vis = mirageTools.getLocalStorageValue(mirageOpenCTISettings.STORAGEKEY_CALLHISTORYVISIBLE);
		if (IsStrYes(vis)) {
    		softphoneModel.SoftPhone_CallHistory().show();
    	}
    	else {
    		softphoneModel.SoftPhone_CallHistory().hide();
    	}
		
		if (IsStrYes(mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPENABLE)) {
			softphoneModel.DropDownListWrapUpStatus().show();
		}
		else {
			softphoneModel.DropDownListWrapUpStatus().hide();
		}
		
		openCTISFInteraction.AutoSize();
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.InitView caused an exception:', e);
	}
};
SoftphoneController.prototype.InitEvents = function () {
	try {
		var obj = this;
		$('.numberPadKey').mousedown(function(){
			$(this).addClass('noShadow');
		});
		$('.numberPadKey').mouseup(function(){
			softphoneModel.TextSearchValue().val(softphoneModel.TextSearchValue().val() + $(this).text());
			$(this).removeClass('noShadow');
			doSearch();
		});
		$('.numberPadKey').mouseout(function(){
			$(this).removeClass('noShadow');
		});
	
		$('#mirageSystemsOpenCTI').mouseover(function(){
			openCTISFInteraction.AutoSize();
		});
		
		softphoneModel.ActionBar_NumberPad().click(function(){
			obj.Action_NumberPad();
		});
		softphoneModel.ActionBar_Dial().click(function(){
			obj.Action_Dial();
			softphoneModel.SoftPhone_NumberPad().hide();
		});
		softphoneModel.ActionBar_Answer().click(function(){
			obj.Action_Answer();
		});
		softphoneModel.ActionBar_Ringing().click(function(){
			obj.Action_Answer();
		});
		softphoneModel.ActionBar_Transfer().click(function(){
			obj.Action_Transfer();
		});
		softphoneModel.ActionBar_CompleteTransfer().click(function(){
			obj.Action_CompleteTransfer();
		});
		softphoneModel.ActionBar_OneStepTransfer().click(function(){
			obj.Action_OneStepTransfer();
		});
		softphoneModel.ActionBar_Hold().click(function(){
			obj.Action_Pause();
		});
		softphoneModel.ActionBar_HangUp().click(function(){
			obj.Action_HangUp();
		});
		softphoneModel.ActionBar_CallHistory().click(function(){
			obj.Action_CallHistory();
		});
			
		softphoneModel.ButtonCallWrapUpSave().click(function(){
			/* MK 2015-04-30 if lead was converted save fails...show hint
			obj.CallWrapUp_Save();*/
			var call = openCTIObjectWorker.CallById(softphoneModel.HiddenCallWrapUpCallId().val());
			call.SaveInitiated = true;
			obj.SaveCallObject(call);
			
			if ((call.WhoId) &&
				(openCTISFInteraction.getTypeOfId(call.WhoId) == 'Lead')) {
				mirageLogger.LogDebug('SoftphoneController.ButtonCallWrapUpSave check lead: ' + call.WhoId);
				CheckLeadConversion(call.WhoId, call.CallId, true);
			}
			else {
				obj.CallWrapUp_Save();
			}
		});
		softphoneModel.ButtonCallWrapUpCancel().click(function(){
			obj.CallWrapUp_Cancel();
		});
		softphoneModel.LabelAssignObject().click(function(){
			obj.Action_Assign();
		});
	
		softphoneModel.TextCallDescription().change(function(){
			obj.StoreCallInfo();
		});
		softphoneModel.TextCallSubject().change(function(){
			obj.StoreCallInfo();
		});
		softphoneModel.CheckBoxDontSave().click(function(){
			obj.StoreCallInfo();
		});
		softphoneModel.DropDownListWrapUpStatus().change(function(){
			obj.StoreCallInfo();
		});
		softphoneModel.LabelCallingName().click(function(){
			var call = openCTIObjectWorker.CallById(softphoneModel.HiddenCallId().val());
			if (call) {
				if (call.WhoId != '') {
					openCTISFInteraction.OpenObjectIfNec(call.WhoId);
				}
				else if (call.WhatId != '') {
					openCTISFInteraction.OpenObjectIfNec(call.WhatId);
				}
			}
		});
		softphoneModel.ImageConnectionState().click(function() {
			try {
				var state = parseInt(openCTIInterface.ConnectionStateControl().attr('state'));
				mirageLogger.LogDebug('SoftphoneController.ImageConnectionState.click process state ' + state);
				switch (state) {
					case mirageOpenCTISettings.ICDC_CONNECTIONSTATE_STOPED:
						var callback = function () {
							openCTIInterface.erroneousRequests = 0;
							openCTIInterface.nullResponses = 0;
							openCTIInterface.autoStartDueToNullResponses = 0;
							openCTIInterface.StartRequesting(true);
						};
						mirageOpenCTISettings.ReadSettings(callback);
						break;
					case mirageOpenCTISettings.ICDC_CONNECTIONSTATE_STARTED:
					default:
						openCTIInterface.StopRequesting();
						break;
				}
			}
			catch (e) {
				mirageLogger.LogError('SoftphoneController.ImageConnectionState.click caused an exception:', e);
			}
		});
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.InitEvents caused an exception:', e);
	}
};
SoftphoneController.prototype.InitResultList = function () {
	try {
		//account list
		if (softphoneModel.AccountListLength() > 0) {
			softphoneModel.AccountResultHeader().removeClass('invisible');
			
			if (softphoneModel.HiddenSelectedList().val() == 'acc') {
				softphoneModel.AccountResultList().removeClass('invisible');
				softphoneModel.ContactResultList().addClass('invisible');
				softphoneModel.ContactResultHeader().addClass('shadow');
			}
			
			softphoneModel.AccountResultHeader().click(function (){
				softphoneModel.ContactResultList().addClass('invisible');
				softphoneModel.AccountResultList().removeClass('invisible');
				softphoneModel.AccountResultHeader().removeClass('shadow');
				softphoneModel.ContactResultHeader().addClass('shadow');
				softphoneModel.HiddenSelectedList().val('acc');
			});
		}
		else {
			softphoneModel.AccountResultHeader().addClass('invisible');
			softphoneModel.AccountResultList().addClass('invisible');
		}
		
		//contact list
		if (softphoneModel.ContactListLength() > 0) {
			softphoneModel.ContactResultHeader().removeClass('invisible');
			
			if (softphoneModel.HiddenSelectedList().val() == 'con') {
				softphoneModel.ContactResultList().removeClass('invisible');
				softphoneModel.AccountResultList().addClass('invisible');
				softphoneModel.AccountResultHeader().addClass('shadow');
			}
			
			softphoneModel.ContactResultHeader().click(function (){
				softphoneModel.ContactResultList().removeClass('invisible');
				softphoneModel.AccountResultList().addClass('invisible');
				softphoneModel.AccountResultHeader().addClass('shadow');
				softphoneModel.ContactResultHeader().removeClass('shadow');
				softphoneModel.HiddenSelectedList().val('con');
			});
		}
		else {
			softphoneModel.ContactResultHeader().addClass('invisible');
			softphoneModel.ContactResultList().addClass('invisible');
		}
		
		if ((softphoneModel.AccountListLength() > 0) ||
			(softphoneModel.ContactListLength() > 0)) {
			softphoneModel.ResultLists().removeClass('invisible');
		}
		else {
			softphoneModel.ResultLists().addClass('invisible');
		}
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.InitResultList caused an exception:', e);
	}
};
SoftphoneController.prototype.RequestUsername = function (waswrong) {
	softphoneModel.PanelAuthenticate().removeClass('invisible');
	softphoneModel.PanelSoftPhone().addClass('invisible');
	softphoneModel.HintAuthentication().addClass('invisible');
	
	if (typeof waswrong != 'undefined') {
		softphoneModel.Hint('wrong', 'username');
	}
	
	softphoneModel.ButtonAuthenticate().click = function () {
		this.UsernameSpecified();
	};
};
SoftphoneController.prototype.UsernameSpecified = function () {
	if (softphoneModel.TextUsername().val() == '') {
		softphoneModel.Hint('specify', 'username');
	}
	else {
		softphoneModel.PanelAuthenticate().addClass('invisible');
		softphoneModel.PanelSoftPhone().removeClass('invisible');
	
		openCTIInterface.Username(softphoneModel.TextUsername().val()); 
		openCTIInterface.StartRequesting();
	}
};
SoftphoneController.prototype.StopCallDuration = function () {
	try {
		mirageLogger.LogDebug('SoftphoneController.StopCallDuration called');
		clearInterval(this.durationInterval);
		this.durationInterval = null;
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.StopCallDuration caused an exception:', e);
	}
};
SoftphoneController.prototype.StartCallDuration = function (call) {
	try {
		mirageLogger.LogDebug('SoftphoneController.StartCallDuration called for call: ' + call.CallId);
		//softphoneModel.SoftPhone_InfoPanel().show();
		if (!this.durationInterval) {
			mirageLogger.LogDebug('SoftphoneController.StartCallDuration do start for call: ' + call.CallId);
			softphoneModel.LabelCallDuration().text('');
			var start = new Date;
			var interval = 1000;
			var delta = call.Duration;
			var obj = this;
			var durCall = call;//MK 2015-04-21
			this.durationInterval = setInterval(function() {
				var tmp = new Date();
				var s = ((new Date - start) / 1000) + delta;
				durCall.Duration = parseInt(s);
				var hours = Math.floor(s / (60 * 60));
		   
			    var divisor_for_minutes = s % (60 * 60);
			    var minutes = Math.floor(divisor_for_minutes / 60);
			 
			    var divisor_for_seconds = divisor_for_minutes % 60;
			    var seconds = Math.ceil(divisor_for_seconds);
			    
			    if (hours < 10) {
			    	hours = '0' + hours;
			    }
			    if (minutes < 10) {
			    	minutes = '0' + minutes;
			    }
			    if (seconds < 10) {
			    	seconds = '0' + seconds;
			    }
			    if (hours != '00') {
			    	softphoneModel.LabelCallDuration().text(hours + ':' + minutes + ':' + seconds);
			    }
			    else {
			    	softphoneModel.LabelCallDuration().text(minutes + ':' + seconds);
			    }
			    //substract function duration from 1 sec
			    interval = 1000 - (new Date - tmp);
			    if (interval < 0) { interval = 0; }
			}, interval);
		}
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.StopCallDuration caused an exception:', e);
	}
};
SoftphoneController.prototype.ShowCallWrapUp = function (call, calledFromLSEvent, calledFromCH) {
	try {
		var type = typeof call;
		if ((type === 'number') ||
			(type === 'string')) {
			call = openCTIObjectWorker.CallById(call);
		}
		mirageLogger.LogDebug('SoftphoneController.ShowCallWrapUp for call: ' + call.CallId);
		
		if (call) {
			var obj = this;
			var tmpCall = call;
			var afterSave = function () {
				if (!calledFromLSEvent) {
					mirageTools.setLocalStorageValue(mirageOpenCTISettings.STORAGEKEY_WRAPUP, tmpCall.CallId);
				}
				if (tmpCall.Answered) {
					softphoneModel.HiddenCallWrapUpCallId().val(tmpCall.CallId);
		
					if (!tmpCall.DoNotSave) {
						softphoneModel.CheckBoxDontSave().removeProp('checked');
						softphoneModel.CheckBoxDontSave().removeAttr('checked');
					}
					obj.WriteCallWrapUp(tmpCall);
					if (tmpCall.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_OUTGOING) {
						softphoneModel.SoftPhone_CallActions().hide();
					}
					else {
						/*not implemented
						softphoneModel.SoftPhone_CallActions().show();*/
					}
					if (softphoneModel.IsOnCall()) {
						softphoneModel.SoftPhone_ShowOnCallEnd().hide();
						softphoneModel.SoftPhone_ShowOnCallEndIfNotIL().hide();
						softphoneModel.SoftPhone_ShowOnCallEndIfIL().hide();
					}
					else {
						softphoneModel.SoftPhone_ShowOnCallEnd().show();
						if (openCTISFInteraction.UseInteractionLog()) {
							softphoneModel.SoftPhone_ShowOnCallEndIfNotIL().hide();
							softphoneModel.SoftPhone_ShowOnCallEndIfIL().show();
						}
						else {
							softphoneModel.SoftPhone_ShowOnCallEndIfNotIL().show();
							softphoneModel.SoftPhone_ShowOnCallEndIfIL().hide();
						}
					}
					softphoneModel.SoftPhone_CallWrapUp().show();
					openCTISFInteraction.AutoSize();
				}
			};
			if ((softphoneModel.IsOnWrapUp()) &&
				(softphoneModel.HiddenCallWrapUpCallId().val() != call.CallId)) {
				mirageLogger.LogDebug('SoftphoneController.ShowCallWrapUp save current wrapup ' + softphoneModel.HiddenCallWrapUpCallId().val() + ' new call is ' + call.CallId);
				//this.CallWrapUp_Save(afterSave);
				var oldCall = openCTIObjectWorker.CallById(softphoneModel.HiddenCallWrapUpCallId().val());
				this.ReadCallWrapUp(oldCall);
				this.CloseWrapUp();
				this.HandleCallAutoSave(oldCall, false, false, afterSave);
			}
			else {
				afterSave();
			}
		}
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.ShowCallWrapUp caused an exception:', e);
	}
};
SoftphoneController.prototype.RemoveAssignment = function (id) {
	try {
		var call = openCTIObjectWorker.CallById(softphoneModel.HiddenCallWrapUpCallId().val());

		if (call.WhoId == id) {
			call.WhoId = '';
			call.WhoName = '';
			call.WhoType = '';
		}
		if (call.WhatId == id) {
			call.WhatId = '';
			call.WhatName = '';
			call.WhatType = '';
		}
		this.SaveCallObject(call);
		
		this.setAssignedTo(call);
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.RemoveAssignment(' + id + ') caused an exception:', e);
	}
	finally {
		openCTISFInteraction.AutoSize();
	}
};
SoftphoneController.prototype.setAssignedTo = function (call) {
	try {
		mirageLogger.LogDebug('SoftphoneController.setAssignedTo called for ' + call.CallId);
		softphoneModel.PanelCallWrapUpAssignedTo().empty();
		var assign = function (id, text) {
			softphoneModel.PanelCallWrapUpAssignedTo().append($('<div/>', {
					class:	'assigned'
				})
				.append($('<span/>', {
					class: 'assigned'
				}).text(text))
				.append($('<span/>', {
					class: 'remove_assigned',
					onclick: 'softphoneController.RemoveAssignment(\'' + id + '\')'
				}).text(Translate('wrapup.remove_assignment', 'Rem'))));
		}
		if (call.WhoId) {
			assign(call.WhoId, (call.WhoName ? call.WhoName : call.WhoType));
		}
		if (call.WhatId) {
			assign(call.WhatId, (call.WhatName ? call.WhatName : call.WhatType));
		}
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.setAssignedTo caused an exception:', e);
	}
	finally {
		openCTISFInteraction.AutoSize();
	}
};
SoftphoneController.prototype.CreateListElementFromCall = function (obj, waitingCall, div) {
	try {
		var call = obj;
		if (waitingCall) {
			call = obj.Call;
		}
		//mirageLogger.LogDebug('SoftphoneController.CreateListElementFromCall for call: ' + call.CallId  + ' waitingCall: ' + waitingCall);
		var number = '';
		if (call.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_OUTGOING) {
			number = call.DialedNumber.Number;
		}
		else {
			number = call.CallerNumber.Number;
		}
		var objectId = '';
		var objectName = '';
		if (call.WhoId) {
			objectId = call.WhoId;
			objectName = call.WhoName; 
		}
		else if (call.WhatId) {
			objectId = call.WhatId;
			objectName = call.WhatName;
		}
		var onclick;
		if (waitingCall) {
			onclick = 'softphoneController.AnswerWaitingCall(\'' + call.CallId + '\')';
		}
		else if (objectName) {
			onclick = 'openCTISFInteraction.OpenObject(\'' + objectId + '\')';
		}
		else {
			onclick = 'openCTIInterface.Dial(\'' + number + '\', \'' + objectId + '\', \'' + objectName + '\')';
		}
		var text = '';
		var classes = 'callNumber';
		if (objectName) {
			text = objectName;
		}
		else {
			text = number;
			classes += ' dial';
		}
		//add
		if (!div) {
			if (waitingCall) {
				div = $('<div/>', {
					id:		call.CallId,
					action:	obj.Perform
				});
			}
			else {
				div = $('<div/>', {
					id:		call.CallId
				});
			}
		}
		else {
			div.empty();
		}
		var divCallerInfo = $('<div/>', {
			class:	'callerInfo'
		})
		.append($('<span/>', {
			class:	classes,
			onclick:	onclick
		})
		.text(text));
		div.append(divCallerInfo);
		
		var classes = 'historyCall';
		if (waitingCall) {
			classes = 'waitingCall';
			div.append($('<div/>', {
				class:	'callTimeInfo'
			})
			.append($('<span/>', {
					class:	'callInfoStart'
				})
				.text(openCTIObjectWorker.getDateTimeString(call.CallStart)))
			);
		}
		else {
			if (call.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_OUTGOING) {
				classes += ' outgoing';
			}
			else {
				classes += ' incoming';
			}
			var time;
			if (call.Answered) {
				time = openCTIObjectWorker.getDateTimeString(call.AnsweredAt);
			}
			else {
				time = openCTIObjectWorker.getDateTimeString(call.CallStart);
				classes += ' missed';
			}
			div.append($('<div/>', {
				class:	'callTimeInfo'
			})
			.append($('<span/>')
				.text(time))
			);
			/* MK 2015-05-04
			if (((call.Answered) ||
				(call.ActivityId)) &&
				(!call.DoNotSave)) {*/
			if (!call.DoNotSave) {
				var onclick = '';
				/* MK 2015-04-08 call function that seperates
				if (call.ActivityId) {
					onclick = 'openCTISFInteraction.OpenTaskInEditMode(\'' + call.ActivityId + '\')';
				}
				else {
					onclick = 'softphoneController.ShowCallWrapUp(\'' + call.CallId + '\', false, true)';
				}*/
				onclick = 'softphoneController.CallHistoryEdit(\'' + call.CallId + '\')';
				
				var txt = '';
				if (call.ActivityId) {
					txt = Translate('call.history.edit', 'Edit');
				}
				else {
					txt = Translate('call.history.save', 'Save');
				}
				div.append($('<div/>', {
					class:	'callOption'
				})
				.append($('<span/>', {
						onclick:	onclick,
						class: 'activeLink'
					}).text(txt)
				));
			}
		}
		
		div.addClass(classes);
		
		return div;
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.CreateListElementFromCall caused an exception:', e);
		return null;
	}
};
SoftphoneController.prototype.CallHistoryEdit = function (callID) {
	try {
		mirageLogger.LogDebug('SoftphoneController.CallHistoryEdit called for: ' + callID);
		var call = openCTIObjectWorker.CallById(callID);
		
		if (call) {
			if (call.ActivityId) {
				mirageLogger.LogDebug('SoftphoneController.CallHistoryEdit open task ' + call.ActivityId);
				openCTISFInteraction.OpenTaskInEditMode(call.ActivityId);
			}
			else {
				mirageLogger.LogDebug('SoftphoneController.CallHistoryEdit open wrap up');
				this.ShowCallWrapUp(call.CallId, false, true);
			}
		}
		else {
			mirageLogger.LogWarn('SoftphoneController.CallHistoryEdit no object found');
		}
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.CallHistoryEdit caused an exception:', e);
		return null;
	}
};
SoftphoneController.prototype.UpdateCallHistory = function (newCall) {
	try {
		mirageLogger.LogDebug('SoftphoneController.UpdateCallHistory called');
		if (newCall) {
			mirageLogger.LogDebug('SoftphoneController.UpdateCallHistory add call to history: ' + newCall.CallId);
			openCTIObjectWorker.HistoriciseCall(newCall);
		}
	
		for (var i=0; i<callHistory.length; i++) {
			var call = callHistory[i];
			var div = null;
			for (var j=0; j< softphoneModel.SoftPhone_CallHistory().children().size(); j++) {
				if (call.CallId == $(softphoneModel.SoftPhone_CallHistory().children()[j]).attr('id')) {
					div = $(softphoneModel.SoftPhone_CallHistory().children()[j]);
					break;
				}
			}
			
			if (div != null) {
				//mirageLogger.LogDebug('SoftphoneController.UpdateCallHistory update call in history list: ' + call.CallId);
				this.CreateListElementFromCall(call, false, div);
			}
			else if ((call.CallerNumber) ||
					(call.DialedNumber)) {
				//mirageLogger.LogDebug('SoftphoneController.UpdateCallHistory add call to history list: ' + call.CallId);
				var div = this.CreateListElementFromCall(call);
				
				if ($('.historyCall').size() == 0) {
					div.appendTo(softphoneModel.SoftPhone_CallHistory());
				}
				else {
					div.insertBefore($('.historyCall')[0]);
				}
			}
			
			//remove
			while (softphoneModel.SoftPhone_CallHistory().children().size() > mirageOpenCTISettings.ADAPTER_SETTINGS_HISTORY_LENGTH) {
				softphoneModel.SoftPhone_CallHistory().children().last().remove();
			}
		}
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.UpdateCallHistory caused an exception:', e);
	}
	finally {
		openCTISFInteraction.AutoSize();
	}
};
SoftphoneController.prototype.ClearWaitingList = function (openCTIObject) {
	try {
		//clear waiting calls if nec
		var obj = this;
		softphoneModel.SoftPhone_WaitingCalls().children().each(function () {
			mirageLogger.LogDebug('SoftphoneController.ClearWaitingList check call from list: ' + $(this).attr('id'));
			var found = false;
			for (var i = 0; i < openCTIObject.Actions.length; i++) {
				var action = openCTIObject.Actions[i];
				mirageLogger.LogDebug('SoftphoneController.ClearWaitingList call ' + action.Call.CallId + ' performs ' + action.Perform);
				
				if (action.Call.CallId == $(this).attr('id')) {
					//show only when calling
					if (action.Call.CallId == softphoneModel.HiddenCallId().val()) {
						//remove from waiting list
					}
					else if ((action.Perform == mirageOpenCTISettings.ICDC_ACTION_DIALINGCALL) ||
						(action.Perform == mirageOpenCTISettings.ICDC_ACTION_DIALINGCALL_ACK)) {
						found = true;
					}
					else if ((action.Perform == mirageOpenCTISettings.ICDC_ACTION_HOLDCALL) ||
						(action.Perform == mirageOpenCTISettings.ICDC_ACTION_HOLDCALL_ACK)) {
						found = true;
					}
					else if (((action.Perform == mirageOpenCTISettings.ICDC_ACTION_HANGUP) ||
						(action.Perform == mirageOpenCTISettings.ICDC_ACTION_HANGUP_ACK))) {
						this.HandleCallAutoSave(action.Call);
					}
					break;
				}
			}
			if (!found) {
				mirageLogger.LogDebug('SoftphoneController.ClearWaitingList remove call from list: ' + $(this).attr('id'));
				$(this).remove();
			}
		});
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.ClearWaitingList caused an exception:', e);
	}
	finally {
		openCTISFInteraction.AutoSize();
	}
};
SoftphoneController.prototype.UpdateWaitingList = function (action) {
	try {
		var found = false;
		var obj = this;
		action.Call.IsWaiting = true;
		action.Call.CallStart = mirageTools.getDateTime();
		softphoneModel.SoftPhone_WaitingCalls().children().each(function () {
			if (action.Call.CallId == $(this).attr('id')) {
				mirageLogger.LogDebug('SoftphoneController.UpdateWaitingList update call in list: ' + action.Call.CallId);
				found = true;
				$(this).attr('action', action.Perform);
				obj.CreateListElementFromCall(action, true, $(this));//update
			}
		});
		
		if (!found) {
			mirageLogger.LogDebug('SoftphoneController.UpdateWaitingList add call to list: ' + action.Call.CallId);
			var div = this.CreateListElementFromCall(action, true);
			div.appendTo(softphoneModel.SoftPhone_WaitingCalls());
		}
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.UpdateWaitingList caused an exception:', e);
	}
	finally {
		openCTISFInteraction.AutoSize();
	}
};
SoftphoneController.prototype.HandleCallAutoSave = function (call, force, openTask, callback) {
	mirageLogger.LogDebug('SoftphoneController.HandleCallAutoSave for call ' + call.CallId + '(' + call.CallDirection + ') and settngs inc=' + 
		mirageOpenCTISettings.ADAPTER_SETTINGS_AUTOSAVE_INCOMINGCALLS + ', out=' + 
		mirageOpenCTISettings.ADAPTER_SETTINGS_AUTOSAVE_OUTGOINGCALLS + ', int=' + 
		mirageOpenCTISettings.ADAPTER_SETTINGS_AUTOSAVE_INTERNALCALLS + ' and missed call settngs inc=' + 
		mirageOpenCTISettings.ADAPTER_SETTINGS_AUTOSAVE_UNSUCCESSFUL_INCOMINGCALLS + ', out=' + 
		mirageOpenCTISettings.ADAPTER_SETTINGS_AUTOSAVE_UNSUCCESSFUL_OUTGOINGCALLS + ', int=' + 
		mirageOpenCTISettings.ADAPTER_SETTINGS_AUTOSAVE_UNSUCCESSFUL_INTERNALCALLS);
	
	if ((call.CallEnd) && (!call.Answered)) {
		mirageLogger.LogDebug('SoftphoneController.HandleCallAutoSave its a missed call');
		//missed call
		if (((call.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_INCOMING) &&
			(!call.IsInternal) &&
			(mirageOpenCTISettings.ADAPTER_SETTINGS_AUTOSAVE_UNSUCCESSFUL_INCOMINGCALLS)) ||
			
			((call.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_OUTGOING) &&
			(!call.IsInternal) &&
			(mirageOpenCTISettings.ADAPTER_SETTINGS_AUTOSAVE_UNSUCCESSFUL_OUTGOINGCALLS)) ||
			
			((call.IsInternal) &&
			(mirageOpenCTISettings.ADAPTER_SETTINGS_AUTOSAVE_UNSUCCESSFUL_INTERNALCALLS))) {
			mirageLogger.LogInfo('SoftphoneController.HandleCallAutoSave: save missed call ' + call.CallId);
			call.Subject = mirageTools.CreateCallSubject(call, true);
			if (call.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_INCOMING) {
				if (mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPMISSEDCALLVALUE) {
					call.Disposition = mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPMISSEDCALLVALUE;
				}
				else {
					call.Disposition = Translate('call.missed', 'Missed Call');
				}
			}
			else {
				if (mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPNOANSWERVALUE) {
					call.Disposition = mirageOpenCTISettings.ADAPTER_SETTINGS_WRAPUPNOANSWERVALUE;
				}
				else {
					call.Disposition = Translate('call.noanswer', 'No Answer');
				}
			}
			var obj = this;
			var autoSaveCallback = function () {
				obj.UpdateCallHistory(call);
				if (callback) { callback(); }
			};
			call.SaveInitiated = true;
			this.SaveCall(call, autoSaveCallback);
		}
		else {
			mirageLogger.LogInfo('SoftphoneController.HandleCallAutoSave: don\'t save missed call ' + call.CallId);
			//don't save, check if call was saved before it became a misssed call
			if (call.ActivityId) {
				mirageLogger.LogInfo('SoftphoneController.HandleCallAutoSave: remove task ' + call.ActivityId + ' for call ' + call.CallId);
				RemoveTask(call.ActivityId, call.CallId);
			}
			if (callback) { callback(); }
		}
	}
	else {
		mirageLogger.LogDebug('SoftphoneController.HandleCallAutoSave its an answered call');
		if (((call.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_INCOMING) &&
			(!call.IsInternal) &&
			(mirageOpenCTISettings.ADAPTER_SETTINGS_AUTOSAVE_INCOMINGCALLS)) ||
			
			((call.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_OUTGOING) &&
			(!call.IsInternal) &&
			(mirageOpenCTISettings.ADAPTER_SETTINGS_AUTOSAVE_OUTGOINGCALLS)) ||
			
			((call.IsInternal) &&
			(mirageOpenCTISettings.ADAPTER_SETTINGS_AUTOSAVE_INTERNALCALLS))) {
			mirageLogger.LogInfo('SoftphoneController.HandleCallAutoSave: save call ' + call.CallId);
			if (softphoneModel.IsOnWrapUp()) {
				this.ReadCallWrapUp(call);
			}
			else {
				if (!call.Subject) { call.Subject = mirageTools.CreateCallSubject(call, false); }
			}
			this.SaveCall(call, force, openTask, callback);
		}
		else {
			mirageLogger.LogInfo('SoftphoneController.HandleCallAutoSave: don\'t save call ' + call.CallId);
			if (callback) { callback(); }
		}
	}
};
SoftphoneController.prototype.ProcessCDCResponse = function (openCTIObject, status) {
	try {
		if (openCTIObject) {	
			if (openCTIObject.Head) {
				if (openCTIObject.Head.CDCStatus == mirageOpenCTISettings.CDCSTATUS_ONLINE) {
					softphoneModel.setConnectionStateGreen();
				}
				else if (openCTIObject.Head.CDCStatus == mirageOpenCTISettings.CDCSTATUS_TIMEOUT) {
					softphoneModel.setConnectionStateYellow();
				}
				var versionString = 'Softphone ' + mirageOpenCTISettings.VERSION;
				if (openCTIObject.Head.OCTIVersion) {
					versionString += ' - TLC ' + openCTIObject.Head.OCTIVersion;
				}
				softphoneModel.HeaderOCTI().attr('alt', versionString);
				softphoneModel.HeaderOCTI().attr('title', versionString);
			}
			
			if (openCTIObject.ActionsChanged) {
				openCTIObject.ActionsChanged = false;
				this.ClearWaitingList(openCTIObject);
				if ((openCTIObject.Actions) &&
					(openCTIObject.Actions.length > 0)) {
					for (var i=0;i<openCTIObject.Actions.length;i++) {
						var action = openCTIObject.Actions[i];
						//mirageLogger.LogDebug('Check action "' + action.Perform + '" for callID: ' + action.Call.CallId);
						
						if (action.Call.Historicised) {
							mirageLogger.LogInfo('Call ' + action.Call.CallId + ' is already historicised.');
						}
						else if ((softphoneModel.HiddenCallId().val() == '') ||
							(action.Call.CallId == softphoneModel.HiddenCallId().val())) {
							if (action.Perform != softphoneModel.HiddenLastAction().val()) {
								mirageLogger.LogInfo('Process action "' + action.Perform + '" for callID: ' + action.Call.CallId);
								softphoneModel.HiddenLastAction().val(action.Perform);
	
								switch (action.Perform) {
									case mirageOpenCTISettings.ICDC_ACTION_DIALINGCALL:
									case mirageOpenCTISettings.ICDC_ACTION_DIALINGCALL_ACK:
										softphoneModel.HiddenCallId().val(action.Call.CallId);
										if (action.Perform == mirageOpenCTISettings.ICDC_ACTION_DIALINGCALL) {
											openCTIInterface.Acknowledge(action);
											
											if ((action.Call.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_OUTGOING) &&
												((action.Call.WhoId) ||
												(action.Call.WhatId))) {
												var obj = this;
												var tmp = action.Call.CallId;
												var callback = function () {
													var tmpCall = openCTIObjectWorker.CallById(tmp);
													obj.ShowCallInfo();
													obj.HandleCallAutoSave(tmpCall, true, false);
												};
												openCTISFInteraction.ReadCallerInfo(action.Call, callback);
											}
											else {
												this.SFSearch(action.Call);
											}
										}
										else {
											if ((action.Call.CallDirection != mirageOpenCTISettings.ICDC_CALLTYPE_OUTGOING) &&
												(action.Call.CallerNumber.NumberChanged)) {
												action.Call.CallerNumber.NumberChanged = false;
												this.SFSearch(action.Call);
											}
										}
										if (action.Call.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_OUTGOING) {
											if (!softphoneModel.SoftPhone_OutgoingCall().hasClass('ringingCall')) {
												softphoneModel.SoftPhone_OutgoingCall().addClass('ringingCall');
											}
										}
										else {
											if (!softphoneModel.SoftPhone_IncomingCall().hasClass('ringingCall')) {
												softphoneModel.SoftPhone_IncomingCall().addClass('ringingCall');
											}
										}
										
										if (action.Call.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_OUTGOING) {
											this.OnOutgoingCall(action.Call);
										}
										else {
											this.OnIncomingCall(action.Call);
										}
										this.ShowCallInfo(action.Call);
										break;
									case mirageOpenCTISettings.ICDC_ACTION_ANSWERCALL:
									case mirageOpenCTISettings.ICDC_ACTION_ANSWERCALL_ACK:
										if (action.Perform == mirageOpenCTISettings.ICDC_ACTION_ANSWERCALL) {
											openCTIInterface.Acknowledge(action);
										}
										if (action.Call.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_OUTGOING) {
											if (softphoneModel.SoftPhone_OutgoingCall().hasClass('ringingCall')) {
												softphoneModel.SoftPhone_OutgoingCall().removeClass('ringingCall');
											}
										}
										else {
											if (softphoneModel.SoftPhone_IncomingCall().hasClass('ringingCall')) {
												softphoneModel.SoftPhone_IncomingCall().removeClass('ringingCall');
											}
											if (action.Call.CallerNumber.NumberChanged) {
												action.Call.CallerNumber.NumberChanged = false;
												this.SFSearch(action.Call);
											}
										}
										
										//answered call in a new window
										if (softphoneModel.HiddenCallId().val() == '') {
											softphoneModel.HiddenCallId().val(action.Call.CallId);
											if (action.Call.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_OUTGOING) {
												this.OnOutgoingCall(action.Call);
											}
											else {
												this.OnIncomingCall(action.Call);
											}
											this.ShowCallInfo(action.Call);
											softphoneModel.ActionBar_Hold().show();
											softphoneModel.ActionBar_Answer().hide();
										}
										
										//answered or resumed
										this.OnAnswer(action.Call);
										this.ShowCallWrapUp(action.Call);
										break;
									case mirageOpenCTISettings.ICDC_ACTION_TRANSFERCALL:
									case mirageOpenCTISettings.ICDC_ACTION_TRANSFERCALL_ACK:
										if (action.Perform == mirageOpenCTISettings.ICDC_ACTION_TRANSFERCALL) {
											openCTIInterface.Acknowledge(action);
										}
										
										break;
									case mirageOpenCTISettings.ICDC_ACTION_HOLDCALL:
									case mirageOpenCTISettings.ICDC_ACTION_HOLDCALL_ACK:
										if (action.Perform == mirageOpenCTISettings.ICDC_ACTION_HOLDCALL) {
											openCTIInterface.Acknowledge(action);
										}
										//answered call in a new window
										if (softphoneModel.HiddenCallId().val() == '') {
											softphoneModel.HiddenCallId().val(action.Call.CallId);
											this.ShowCallInfo(action.Call);
										}
										if ((action.Call.OnHold) &&
											(action.Perform == mirageOpenCTISettings.ICDC_ACTION_HOLDCALL_ACK)) {
											//if holded call is waiting
											if (action.Call.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_OUTGOING) {
												this.OnOutgoingCall(action.Call);
											}
											else {
												this.OnIncomingCall(action.Call);
											}
											this.ShowCallInfo(action.Call);
										}

										this.OnHold(action.Call);
										
										if (softphoneModel.HiddenAnswerOnHoldCallId().val()) {
											var obj = this;
											var call = action.Call;
											var callback = function () {
												var id = softphoneModel.HiddenAnswerOnHoldCallId().val();
												softphoneModel.HiddenAnswerOnHoldCallId().val('');
												obj.SwitchCall(id, call);
											};
											this.CallWrapUp_Save(callback, true);
										}
										else {
											this.HandleCallAutoSave(action.Call, false, false);
										}
										break;
									case mirageOpenCTISettings.ICDC_ACTION_HANGUPCALL:
										this.OnCallEnd(action.Call);
										if (action.Perform == mirageOpenCTISettings.ICDC_ACTION_HANGUPCALL) {
											openCTIInterface.Acknowledge(action);
											openCTIInterface.Terminate(action.Call.CallId);
											if (!action.Call.Answered) {
												this.HandleCallAutoSave(action.Call);
											}
										}
										this.UpdateCallHistory(action.Call);
										break;
									case mirageOpenCTISettings.ICDC_ACTION_HANGUPCALL_ACK:
										this.OnCallEnd();
										this.UpdateCallHistory();
										break;
								}
							}
							else {
								if ((action.Call.CallDirection != mirageOpenCTISettings.ICDC_CALLTYPE_OUTGOING) &&
									(action.Call.CallerNumber.NumberChanged)) {
									action.Call.CallerNumber.NumberChanged = false;
									this.SFSearch(action.Call);
								}
							}
						}
						else {
							if (!action.Call.IsWaiting) {
								this.SFSearch(action.Call);
								this.UpdateWaitingList(action);
							}
						}
					}
				}
				else {
					//mirageLogger.LogDebug('No actions to perform');
					//if a call is active it should be removed when not in wrapup state
					if ((softphoneModel.HiddenCallWrapUpCallId().val() == '') &&
						(softphoneModel.HiddenCallId().val() != '')) {
						this.OnCallEnd();
					}
				}
			}
			else {
				//nothing changed
			}
		}
		else {
			//openCTIObject is null
		}
		if (status == 'refresh') {
			this.UpdateCallHistory();
		}
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.ProcessCDCResponse caused an exception:', e);
	}
};
/*SoftphoneController.prototype.Click2Dial = function (response) {
	if (response.result) {
    	mirageLogger.LogDebug('SoftphoneController.Click2Dial called with: ' + response.result);
    	var dialed = JSON.parse(response.result);
    	
    	//dialed.number;//dialed number
    	//dialed.object;//Account, Contact...
    	//dialed.objectName;//Name of the object
    	//dialed.objectId;//Id of the object
    	
    	if (dialed != null) {
    		//check types
    		var supportedTypes = new Array('account', 'contact', 'lead', 'opportunity', 'case', 'campaign');
    		if ($.inArray(dialed.object.toLowerCase(), supportedTypes) >= 0) {
    			openCTIInterface.Dial(dialed.number, softphoneModel.DropDownListLines().val(), dialed.objectId, dialed.objectName, dialed.object);
    		}
    		else {
    			openCTIInterface.Dial(dialed.number, softphoneModel.DropDownListLines().val(), '', '', '');
    		}
    	}
	}
};*/
SoftphoneController.prototype.SFSearch = function (call) {
	try {
		if (call) {
			if (!call.SFSearchDone) {
				call.SFSearchDone = true;
				mirageLogger.LogDebug('SoftphoneController.SFSearch for call: ' + call.CallId);
				//search
				var obj = this;
				var searchCallback = function (response) {
					if (response.result) {
						/*//assign
						if (mirageOpenCTISettings.ADAPTER_SETTINGS_AUTOASSIGN_OBJECT) {
							this.Action_Assign();
						}*/
						obj.SFSearchCallback(response, call);
					}
					else {
						mirageLogger.LogError('SoftphoneController.SFSearch failed: ' + response.error);
					}
				};
				openCTISFInteraction.Search(call, searchCallback);
			}
			else {
				mirageLogger.LogDebug('SoftphoneController.SFSearch already handled for call: ' + call.CallId);
				this.ShowCallInfo(call);
			}
		}
		else {
			mirageLogger.LogError('SoftphoneController.SFSearch failed: no call specified');
		}
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.SFSearch caused an exception:', e);
	}
};
SoftphoneController.prototype.SFSearchCallback = function (response, call) {
	if (call) {
		mirageLogger.LogDebug('SoftphoneController.SFSearchCallback for call: ' + call.CallId);
		if (response.result) {
			try {
				var res = $.parseJSON(response.result);
				//only if one hit
				var size = Object.size(res);
				if (call.IsWaiting) {
					//call.IsWaiting uses searchAndGetScreenPopUrl
					size--;//screenPopUrl mustn't count
				}
				if (size == 1) {
					var key;
					for (key in res) {
						//generate text from result data
						openCTISFInteraction.FillCallerInfo(call, res[key], key, true);
						if (call.IsWaiting) {
							var action = openCTIObjectWorker.getActionForCall(call);
							if (action) {
								this.UpdateWaitingList(action);
							}
						}
						else {
							this.ShowCallInfo(call);
						}
						break;
					}
				}
			}
			catch (e) {
				mirageLogger.LogError('SoftphoneController.SFSearchCallback error creating caller text:', e);
			}
			finally {
				this.HandleCallAutoSave(call, true, false);
			}
		}
		else {
			mirageLogger.LogError('SoftphoneController.SFSearchCallback error:', response.error);
		}
	}
};
SoftphoneController.prototype.AssignObject = function (id, name, fromWrapUp) {
	var call = null;
	if (fromWrapUp) {
		call = openCTIObjectWorker.CallById(softphoneModel.HiddenCallWrapUpCallId().val());
	}
	else {
		call = openCTIObjectWorker.CallById(softphoneModel.HiddenCallId().val());
	}
	if (call) {
		mirageLogger.LogDebug('SoftphoneController.AssignObject for call: ' + call.CallId + ' with id: ' + id + ' and name: ' + name);
		var obj = this;
		var tmp = call.CallId;
		var assigned = function () {
			var tmpCall = openCTIObjectWorker.CallById(tmp);
			mirageLogger.LogDebug('SoftphoneController.AssignObject processing callback');
			obj.ShowCallInfo(tmpCall);
			obj.setAssignedTo(tmpCall);
			obj.SaveCallObject(tmpCall);
		};
		openCTISFInteraction.AssignObject(id, name, call, assigned, fromWrapUp);
	}
};
SoftphoneController.prototype.ParseJSON = function (obj) {
	this.durationInterval = obj.durationInterval;
};
SoftphoneController.prototype.ShowCallInfo = function (call) {
	try {
		if (!call) {
			call = openCTIObjectWorker.CallById(softphoneModel.HiddenCallId().val());
		}
		if (call) {
			mirageLogger.LogDebug('SoftphoneController.ShowCallInfo for call: ' + call.CallId);
			if (call.CallId == softphoneModel.HiddenCallId().val()) {
				this.ShowCallWrapUp(call);
				//only if call is active
				if (call.CallerText) {
					softphoneModel.LabelCallingName().text(call.CallerText);
				}
				else {
					if (call.WhoId != '') {
						softphoneModel.LabelCallingName().text(call.WhoName);
					}
					else if (call.WhatId != '') {
						softphoneModel.LabelCallingName().text(call.WhatName);
					}
					else {
						softphoneModel.LabelCallingName().text('');
					}
				}
				if (softphoneModel.LabelCallingName().text()) {
					var objId;
					if (call.WhoId != '') {
						objId = call.WhoId;
					}
					else if (call.WhatId != '') {
						objId = call.WhatId;
					}
					softphoneModel.LabelCallingName().unbind();
					softphoneModel.LabelCallingName().click(function(){
						openCTISFInteraction.OpenObjectIfNec(objId);
					});
				}
				if (call.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_OUTGOING) {
					if (call.DialedNumber) {
						softphoneModel.LabelOutgoingNumber().text(call.DialedNumber.Number);
					}
					if ((call.CallerNumber) && (call.CallerNumber.Number)) {
						softphoneModel.LabelCallingNumber().text(call.CallerNumber.Number);
						softphoneModel.LabelCallAditionalInfo().text(Translate('call.caller', 'Caller ID: ') + call.CallerNumber.Number);
						//softphoneModel.SoftPhone_InfoPanel().show();
					}
				}
				else {
					if (call.CallerNumber) {
						softphoneModel.LabelCallingNumber().text(call.CallerNumber.Number);
					}
					if ((call.DialedNumber) && (call.DialedNumber.Number)) {
						//softphoneModel.LabelCalledNumber().text(call.DialedNumber.Number);
						softphoneModel.LabelCallAditionalInfo().text(Translate('call.called', 'Called ID: ') + call.DialedNumber.Number);
						//softphoneModel.SoftPhone_InfoPanel().show();
					}
				}
				if (call.CallInfo) {
					softphoneModel.CallInfo().empty();
					for (var i=0; i<call.CallInfo.length; i++) {
						var o = call.CallInfo[i];
						var key = o.key;
						var value = o.value;
		
						if (key.endsWith('__c')) {//user field
							key = key.substr(0, key.length-3);
						}
						if (value.endsWith('00:00:00')) {//time at birthdate
							value = value.substr(0, value.length-9);
						}
						
						softphoneModel.CallInfo().append(
							$('<div/>', {
								class:	'callInfo'
								})
							.append($('<label/>', {
								class: 'callInfoValue'
								})
								.text(value)
							)
							.append($('<label/>', {
								class: 'callInfoKey'
								})
								.text(key)
							)
						);
					}
				}
			}
		}
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.ShowCallInfo caused an exception:', e);
	}
	finally {
		openCTISFInteraction.AutoSize();
	}
};
SoftphoneController.prototype.SaveCall = function (call, force, openTask, callback, afterInteractionlogSaved) {
	try {
		//if ((!softphoneModel.CheckBoxDontSave().prop('checked')) ||
		if ((!softphoneModel.DontSaveCall()) ||
			(force)) {
			if (!mirageTools.IsTaskSaveLocked(call.CallId)) {
				mirageLogger.LogDebug('SoftphoneController.SaveCall for call: ' + call.CallId);
				/*if (openCTISFInteraction.UseInteractionLog()) {
					var obj = this;
					var onActive = function() {
						//call is still active so don't save
						if (callback) {
							callback();
						}
					};
					var onInactive = function() {
						obj.DoSaveCall(call, openTask, callback);
					};
					openCTISFInteraction.IsCallActive(call, onActive, onInactive);
				}
				else {
					this.DoSaveCall(call, openTask, callback, afterInteractionlogSaved);
				}*/

				this.DoSaveCall(call, openTask, callback, afterInteractionlogSaved);
			}
			else {
				if (callback) {
					callback();
				}
			}
		}
		else if (call.ActivityId) {
			mirageLogger.LogInfo('SoftphoneController.SaveCall: remove task ' + call.ActivityId + ' for call ' + call.CallId);
			RemoveTask(call.ActivityId, call.CallId);
			if (callback) {
				callback();
			}
		}
		else {
			mirageLogger.LogDebug('SoftphoneController.SaveCall don\'t save for call: ' + call.CallId);
			if (callback) {
				callback();
			}
		}
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.SaveCall caused an exception:', e);
	}
};
SoftphoneController.prototype.DoSaveCall = function (call, openTask, callback, afterInteractionlogSaved) {
	try {
		var obj = this;
		var safeCallback = function(response) {
			if (!response) {
				//save locked
				if (callback) {
					callback();
				}
			}
			else if (response.result) {
				if ((call.ActivityId) && (call.ActivityId != response.result)) {
					mirageLogger.LogError('SoftphoneController.DoSaveCall: new task id for call ' + call.CallId + ' - ' + response.result + ' differs from previous' + call.ActivityId);
					RemoveTask(response.result, '');
				}
				else {
					mirageLogger.LogInfo('SoftphoneController.DoSaveCall: task id for call ' + call.CallId + ' is: ' + response.result);
					call.ActivityId = response.result;
					if ((openCTISFInteraction.UseInteractionLog()) &&
						(!afterInteractionlogSaved)) {
						var fireOnCallLogSavedCallback = function (result) {
							if (result) {
								
							}
						};
						sforce.console.cti.fireOnCallLogSaved(call.ActivityId, fireOnCallLogSavedCallback);
					}
					CheckTask(call.ActivityId, call.CallId, mirageOpenCTISettings.SALESFORCE_STATUS_COMPLETED);
					
					obj.RefreshActivityList();
					obj.SaveCallObject(call);
					setTimeout(function(){mirageTools.OpenTaskSave(call.CallId);}, 10000);
					
					//if (call.Historicised) {
					if (openCTIObjectWorker.IsCallHistoricised(call)) {
						//update call history
						obj.UpdateCallHistory();
					}
				}
		
				if (callback) {
					callback();
				}
				if (openTask) {
					mirageLogger.LogInfo('SoftphoneController.DoSaveCall: open task ' + call.ActivityId + ' for call ' + call.CallId);
					openCTISFInteraction.OpenTaskInEditMode(call.ActivityId);
				}
			}
			else {
				mirageLogger.LogError('SoftphoneController.DoSaveCall: save task failed with ' + response.error);
				if (callback) {
					callback();
				}
			}
		}
		mirageTools.LockTaskSave(call.CallId);//prevent other tab from saving if both refresh at the same time
		setTimeout(function(){openCTISFInteraction.SaveObject(call, safeCallback);}, 500);
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.DoSaveCall caused an exception:', e);
	}
};
SoftphoneController.prototype.SaveCallObject = function (call) {
	//mirageLogger.LogDebug('SoftphoneController.SaveCallObject for call: ' + call.CallId);
	//if (call.Historicised) {
	if (openCTIObjectWorker.IsCallHistoricised(call)) {
		mirageLogger.LogDebug('SoftphoneController.SaveCallObject in history for call: ' + call.CallId);
		mirageTools.setLocalStorageObject(mirageOpenCTISettings.STORAGEKEY_CALLHISTORY, callHistory);
	}
	else {
		mirageLogger.LogDebug('SoftphoneController.SaveCallObject in status object for call: ' + call.CallId);
		mirageTools.setLocalStorageObject(mirageOpenCTISettings.STORAGEKEY_STATUSOBJECT, openCTIObject);
	}
};
SoftphoneController.prototype.RefreshActivityList = function (fromLSEvent) {
    try {
		mirageLogger.LogDebug('SoftphoneController.RefreshActivityList called');
		if (!fromLSEvent) {
			mirageTools.setLocalStorageObject(mirageOpenCTISettings.STORAGEKEY_REFRESHACTIVITYLIST, softphoneModel.HiddenCallId().val());
		}
		var checkRefreshResult = function (response) {
			if (response.result) {
				//ok
			}
			else {
				mirageLogger.LogWarn('SoftphoneController.RefreshActivityList failed with: ' + response.error);
			}
		}
		sforce.interaction.refreshRelatedList('RelatedHistoryList', checkRefreshResult);
    }
	catch (e) {
		mirageLogger.LogError('SoftphoneController.RefreshActivityList caused an exception:', e);
	}
};
SoftphoneController.prototype.TaskExists = function () {
	try {
		var call = openCTIObjectWorker.CallById(softphoneModel.HiddenExistsTaskCallId().val());
		if (call) {
			var result = softphoneModel.HiddenExistsTaskResult().val();
			mirageLogger.LogDebug('SoftphoneController.TaskExists for call: ' + call.CallId + ' returns ' + result);
			if (result == 'error') {
				//mirageLogger.LogError('SoftphoneController.TaskExists returns error:' + softphoneModel.HiddenRemoveTaskResult().val());
			}
			else if (result == 'exists not') {
				if ((call.SaveInitiated) &&
					(!call.DoNotSave)) {
					softphoneModel.Hint('general', 'savefailed');
				}
			}
			else {
				call.ActivityId = result;
				this.SaveCallObject(call);
				this.UpdateCallHistory();
			}
			softphoneModel.HiddenExistsTaskCallId().val('');
		}
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.TaskExists caused an exception:', e);
	}
};
SoftphoneController.prototype.TaskRemoved = function () {
	try {
		var call = openCTIObjectWorker.CallById(softphoneModel.HiddenRemovedTaskCallId().val());
		if (call) {
			var result = softphoneModel.HiddenRemoveTaskResult().val();
			mirageLogger.LogDebug('SoftphoneController.TaskRemoved for call: ' + call.CallId + ' returns ' + result);
			if (result == 'ok') {
				call.ActivityId = '';
				this.SaveCallObject(call);
				this.UpdateCallHistory();
			}
			else{
				mirageLogger.LogError('SoftphoneController.TaskRemoved returns error:' + softphoneModel.HiddenRemoveTaskResult().val());
			}
			softphoneModel.HiddenRemovedTaskCallId().val('');
		}
		this.RefreshActivityList();
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.TaskRemoved caused an exception:', e);
	}
};
SoftphoneController.prototype.TaskChecked = function () {
	try {
		var call = openCTIObjectWorker.CallById(softphoneModel.HiddenCheckTaskCallId().val());
		if (call) {
			var result = softphoneModel.HiddenCheckTaskResult().val();
			mirageLogger.LogDebug('SoftphoneController.TaskChecked for call: ' + call.CallId + ' returns ' + result);
			if (result == 'removed') {
				call.ActivityId = '';
				this.SaveCallObject(call);
				this.UpdateCallHistory();
			}
			else if ((result == 'correct') || (result == 'denied')) {
				//nothing
			}
			else{
				mirageLogger.LogError('SoftphoneController.TaskChecked returns error:' + softphoneModel.HiddenRemoveTaskResult().val());
			}
			softphoneModel.HiddenRemovedTaskCallId().val('');
		}
		this.RefreshActivityList();
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.TaskChecked caused an exception:', e);
	}
};
SoftphoneController.prototype.StoreCallInfo = function () {
	var call = openCTIObjectWorker.CallById(softphoneModel.HiddenCallWrapUpCallId().val());
	if (call) {
		mirageLogger.LogDebug('SoftphoneController.StoreCallInfo for call: ' + call.CallId);
		if (this.ReadCallWrapUp(call)) {
			mirageTools.setLocalStorageObject(mirageOpenCTISettings.STORAGEKEY_CALLERINFO, call);
		}
	}
};
SoftphoneController.prototype.ReadInfoCallback = function () {
	var call = openCTIObjectWorker.CallById(softphoneModel.HiddenReadInfoCallId().val());
	if (call) {
		var result = softphoneModel.HiddenReadInfoResult().val();
		mirageLogger.LogDebug('SoftphoneController.ReadInfoCallback for call: ' + call.CallId + ' returns: ' + result);
		if (result.startsWith('ok')) {
			if (result.startsWith('ok:')) {
				openCTISFInteraction.ClearIdsIfNec(call);
				result = result.substr(3);
				var info = result.split('#');
				this.AssignObject(info[0], info[1]);
			}
			else{
				mirageLogger.LogError('SoftphoneController.ReadInfoCallback returns no data');
			}
		}
		else{
			mirageLogger.LogError('SoftphoneController.ReadInfoCallback returns error:' + result);
		}
		softphoneModel.HiddenReadInfoCallId().val('');
	}
};
SoftphoneController.prototype.ReadTaskBasics = function () {
	if ((!mirageOpenCTISettings.SALESFORCE_STATUS_COMPLETED) ||
		(mirageOpenCTISettings.SALESFORCE_STATUS_COMPLETED == 'Completed') ||//Completed is default
		(!mirageOpenCTISettings.SALESFORCE_DEFAULT_PRIORITY) ||
		(mirageOpenCTISettings.SALESFORCE_DEFAULT_PRIORITY == 'low')) {//low is default
		ReadTaskBasics();//apex
	}
};
SoftphoneController.prototype.HandleAutoOpenTask = function (call, callback) {
	if (call) {
		mirageLogger.LogDebug('SoftphoneController.HandleAutoOpenTask for call: ' + call.CallId);
		if ((mirageOpenCTISettings.ADAPTER_SETTINGS_AUTO_EDIT_TASK) &&
			(call.Answered)) {
			//save could be initiated by HandleMissedCall
			if (mirageTools.IsTaskSaveLocked(call.CallId)) {
				mirageLogger.LogDebug('SoftphoneController.HandleAutoOpenTask wait for save');
				var obj = this;
				setTimeout(function(){obj.HandleCallAutoSave(call, true, true, callback);}, 1000);
			}
			else {
				this.HandleCallAutoSave(call, true, true, callback);
			}
			this.CloseWrapUp();
		}
		else {
			if (callback) { callback(); }
		}
	}
	else {
		if (callback) { callback(); }
	}
};
SoftphoneController.prototype.AnswerWaitingCall = function (id) {
	try {
		mirageLogger.LogDebug('SoftphoneController.AnswerWaitingCall for id: ' + id);
		if (id != softphoneModel.HiddenCallId().val()) {
			var activeCall = openCTIObjectWorker.CallById(softphoneModel.HiddenCallId().val());
			var waitingCall = openCTIObjectWorker.CallById(id);
			if (activeCall) {
				activeCall.IsWaiting = true;
				if (activeCall.Answered) {
					if (activeCall.OnHold) {
						this.SwitchCall(id, activeCall);
					}
					else {
						softphoneModel.HiddenAnswerOnHoldCallId().val(id);
						mirageTools.setLocalStorageValue(mirageOpenCTISettings.STORAGEKEY_ANSWERONHOLD, id);
						openCTIInterface.Pause(softphoneModel.HiddenCallId().val());
					}
				}
				else {
					this.SwitchCall(id, activeCall);
				}
			}
			else {
				this.SwitchCall(id);
			}
		}
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.AnswerWaitingCall caused an exception:', e);
	}
};
SoftphoneController.prototype.SwitchCall = function (newCallId, oldCall) {
	try {
		var call = openCTIObjectWorker.CallById(newCallId);
		call.IsWaiting = false;
		this.CallWrapUp_Cancel();
		if (oldCall) {
			mirageLogger.LogDebug('SoftphoneController.SwitchCall called for new ' + newCallId + ' and old ' + oldCall.CallId);
			this.ReadCallWrapUp(oldCall);
			var action = openCTIObjectWorker.getActionForCall(oldCall);
			if (action) {
				this.UpdateWaitingList(action);
			}
		}
		else {
			mirageLogger.LogDebug('SoftphoneController.SwitchCall called for ' + newCallId);
		}
		softphoneModel.HiddenCallId().val(newCallId);
		softphoneModel.HiddenLastAction().val('');
		openCTIObject.ActionsChanged = true;
		openCTIObjectWorker.MoveActionToTop(openCTIObjectWorker.getActionForCallId(newCallId));
		mirageTools.setLocalStorageValue(mirageOpenCTISettings.STORAGEKEY_ACTIONTOTOP, newCallId);
		this.ProcessCDCResponse(openCTIObject);
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.SwitchCall caused an exception:', e);
	}
};
SoftphoneController.prototype.ReadTaskBasicsCallback = function () {
	try {
		var result = softphoneModel.HiddenReadTaskBasicsResult().val();
		if (result.indexOf('error:') != -1) {
			mirageLogger.LogError('SoftphoneController.ReadTaskBasicsCallback returns error:' + result);
		}
		else{
			var res = result.split(';#;');
			mirageOpenCTISettings.SALESFORCE_STATUS_COMPLETED = res[0];
			mirageOpenCTISettings.SALESFORCE_DEFAULT_PRIORITY = res[1];

			mirageTools.setLocalStorageValue(mirageOpenCTISettings.STORAGEKEY_CALLSTATUS, mirageOpenCTISettings.SALESFORCE_STATUS_COMPLETED);
			mirageTools.setLocalStorageValue(mirageOpenCTISettings.STORAGEKEY_CALLPRIORITY, mirageOpenCTISettings.SALESFORCE_DEFAULT_PRIORITY);
			mirageLogger.LogDebug('SoftphoneController.ReadTaskBasicsCallback: completeed status is: ' + result);
		}
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.ReadTaskBasicsCallback caused an exception:', e);
	}
};
SoftphoneController.prototype.CheckLeadConversion_Callback = function () {
	try {
		var call = openCTIObjectWorker.CallById(softphoneModel.HiddenCheckLeadConvCallId().val());
		if (call) {
			var result = softphoneModel.HiddenCheckLeadConvResult().val();
			mirageLogger.LogDebug('SoftphoneController.CheckLeadConversion_Callback for call: ' + call.CallId + ' returns ' + result);
			if (result) {
				if ((result.startsWith('error')) ||
					(result == 'converted')) {
					call.WhoId = '';
					call.WhoName = '';
					call.WhoType = '';
					this.SaveCallObject(call);
					
					this.setAssignedTo(call);
					softphoneModel.Hint('general', 'leadconversion');
				}
				else {
					call.WhoId = result;
			        call.WhoType = openCTISFInteraction.getTypeOfId(result); 
					this.SaveCallObject(call);
				}
			}
			softphoneModel.HiddenCheckLeadConvCallId().val('');
			
			if (IsStrYes(softphoneModel.HiddenCheckLeadConvDoSave().val())) {
				this.CallWrapUp_Save();
			}
		}
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.TaskExists caused an exception:', e);
	}
};
SoftphoneController.prototype.NumberSearchCallback = function () {
	try {
		var search = softphoneModel.HiddenNumberSearchResult().val().toString();
		softphoneModel.HiddenNumberSearchResult().val('');
		mirageLogger.LogDebug('SoftphoneController.NumberSearchCallback returns ' + search);
		var call = openCTIObjectWorker.CallById(softphoneModel.HiddenNumberSearchCallId().val());
		if (call) {
			var obj = this;
			var searchCallback = function (response) {
				if (response.result) {
					/*//assign
					if (mirageOpenCTISettings.ADAPTER_SETTINGS_AUTOASSIGN_OBJECT) {
						this.Action_Assign();
					}*/
					obj.SFSearchCallback(response, call);
				}
				else {
					mirageLogger.LogError('SoftphoneController.SFSearch failed: ' + response.error);
				}
			};
			if (!search) {
				if (call.CallDirection == mirageOpenCTISettings.ICDC_CALLTYPE_OUTGOING) {
					search = call.DialedNumber.Number;
				}
				else {
					search = call.CallerNumber.Number;
				}
			}
			if (search.toLowerCase().indexOf('or') != -1) {
				var parts = search.toLowerCase().split(' or ');
				search = '';
				for (var i=0; i<parts.length; i++) {
					if (search) { search += ' OR '; }
					search += parts[i].onlyNumeric();
				}
			}
			else {
				search = search.onlyNumeric();
			}
			
			openCTISFInteraction.NumberSearch(call, search, searchCallback);
		}
	}
	catch (e) {
		mirageLogger.LogError('SoftphoneController.ReadTaskBasicsCallback caused an exception:', e);
	}
};