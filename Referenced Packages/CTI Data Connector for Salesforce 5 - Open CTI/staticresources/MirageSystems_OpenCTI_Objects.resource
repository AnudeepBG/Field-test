function OpenCTIObject() {
	this.Head = new OpenCTIObject_Head();
	this.Actions = new Array();
	this.ActionsChanged = false;
}

function OpenCTIObject_Head () {
	this.Version = '';//web service
	this.OCTIVersion = '';
	this.Username = '';
	this.CDCStatus = mirageOpenCTISettings.CDCSTATUS_OFFLINE;
	this.OCTISettings = new Array();
}

function OpenCTIObject_Setting () {
	this.Name = '';
	this.Value = '';
}

function OpenCTIObject_Action () {
	this.Perform = '';
	this.Call = new OpenCTIObject_Call();
}

function OpenCTIObject_Call () {
	this.CallId = '';
	this.CallerNumber = new OpenCTIObject_Number();
	this.DialedNumber = new OpenCTIObject_Number();
	this.Subject = '';
	this.Comment = '';
	this.Disposition = '';
	this.WhoId = '';
	this.WhoName = '';
	this.WhoType = '';
	this.WhatId = '';
	this.WhatName = '';
	this.WhatType = '';
	this.IsOnTransfer = false;
	this.IsOnOneStepTransfer = '';
	this.TransferedTo = '';
	this.Historicised = false;
	this.Answered = false;
	this.AnsweredAt = '';
	this.OnHold = false;
	this.CallStart = '';
	this.CallEnd = '';
	this.Duration = 0;
	this.CallDirection = '';
	this.CallerText = '';
	this.ActivityId = '';
	this.CallInfo = new Array();
	this.DoNotSave = false;
	this.SFSearchDone = false;
	this.IsWaiting = false;
	this.DialedSFNumber = '';
	this.SaveInitiated = false;
	
	this.Params = new Array();
	this.IsInternal = false;
}

function OpenCTIObject_Number () {
	this.CountryCode = '';
	this.AreaCode = '';
	this.LocalNumber = '';
	this.Number = '';
	this.NumberChanged = false;
	this.FormatedNumbers = new Array();
}
