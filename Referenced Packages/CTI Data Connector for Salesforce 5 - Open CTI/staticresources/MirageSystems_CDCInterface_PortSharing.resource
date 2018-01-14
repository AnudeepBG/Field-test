CDCInterface.prototype.PortSharingCall = function () {
	try{
		var obj = this;
		this.numberOfRequests++;
		
		$.ajax({
			type:		'POST',
			url: 		mirageOpenCTISettings.ICDC_WEBSERVICEURL,
		  	data: 		this.username,
		  	dataType:	'text'
		})
		.done(function (data, status, jqXHR) {
			try {
				if ((typeof data != 'undefined') &&
					(data != '')) {
					if (data == 'authentication required') {
						mirageLogger.LogInfo('CDCInterface.PortSharingCall.done: authentication required!');
						obj.StopRequesting();
						softphoneController.RequestUsername();
					}
					else if (data == 'username invalid') {
						mirageLogger.LogInfo('CDCInterface.PortSharingCall.done: username ' + obj.Username() + ' is invalid!');
						obj.StopRequesting();
						softphoneController.RequestUsername(true);
					}
					else {
						obj.WebServiceUrl(data);
					}
				}
				else {
					mirageLogger.LogError('CDCInterface.PortSharingCall.done: no data');
				}
			}
			catch (e) {
				mirageLogger.LogError('CDCInterface.PortSharingCall.done caused an exception:', e);
			}
		})
		.fail(function (jqXHR, status, error) {
			try {
				mirageLogger.LogWarn('CDCInterface.PortSharingCall.fail: Port sharing request failed with status \'' + status + '\' and error: ' + error);
			}
			catch (e) {
				mirageLogger.LogError('CDCInterface.PortSharingCall.fail caused an exception:', e);
			}
		});
	}
	catch (e) {
		mirageLogger.LogError('CDCInterface.PortSharingCall caused an exception:', e);
	}
};