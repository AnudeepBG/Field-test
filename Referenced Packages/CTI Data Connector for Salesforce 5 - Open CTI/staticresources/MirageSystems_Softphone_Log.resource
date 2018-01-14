//prevent older browsers from raising exceptions
if(!window.console){ window.console = {log: function(){} }; } 

function MirageLogger() {}

MirageLogger.prototype.ControlReady = false;
MirageLogger.prototype.LogCache = new Array();
MirageLogger.prototype.LogControl = function() {
	return $('#MirageLog');
};
MirageLogger.prototype.LogDebug = function(value) {
	if (mirageOpenCTISettings.LOG_LEVEL <= LOGLEVEL_DEBUG) {
		this.DoLog(mirageTools.getDateTime() + ' DEBUG: ' + value, 1);
	}
};
MirageLogger.prototype.LogInfo = function(value) {
	if (mirageOpenCTISettings.LOG_LEVEL <= LOGLEVEL_INFO) {
		this.DoLog(mirageTools.getDateTime() + ' INFO: ' + value, 2);
	}
};
MirageLogger.prototype.LogWarn = function(value) {
	if (mirageOpenCTISettings.LOG_LEVEL <= LOGLEVEL_WARN) {
		this.DoLog(mirageTools.getDateTime() + ' WARN: ' + value, 3);
	}
};
MirageLogger.prototype.LogError = function(value, exception) {
	if (mirageOpenCTISettings.LOG_LEVEL <= LOGLEVEL_ERROR) {
		this.DoLog(mirageTools.getDateTime() + ' ERROR: ' + value, 4);
	
		if (typeof exception != 'undefined') {
			var text = exception.Message;
			if ((typeof exception.fileName != 'undefined') &&
				(typeof exception.lineNumber != 'undefined')) {
				text += ' (' + exception.fileName + ' - line ' + exception.lineNumber + ')';
			}
			this.DoLog(mirageTools.getDateTime() + ' ERROR:         ' + text);
			
			if (typeof exception.stack != 'undefined') {
				this.DoLog(mirageTools.getDateTime() + ' ERRORSTACK:    ' + exception.stack);
			}
		}
	}
	if (mirageOpenCTISettings.LOG_LEVEL.LOG_ALERTERRORS) {
		if (typeof exception != 'undefined') {
			alert(value);
		}
		else {
			alert(value + ' - ' + exception.Message);
		}
	}
};
MirageLogger.prototype.DoLog = function(value, type) {
	try {
		if (typeof type == 'undefined') {
			var type = 1;
		}
		if (mirageOpenCTISettings.LOG_USECACHE) {
			this.LogCache.push(value);
		}
		if(mirageOpenCTISettings.LOG_USECONSOLE) {
			if (mirageOpenCTISettings.LOG_USECACHE) {
				while (this.LogCache.length > 0) {
					switch (type) {
						case 1:
							console.log(this.LogCache[0]);
							break;
						case 2:
							console.info(this.LogCache[0]);
							break;
						case 3:
							console.warn(this.LogCache[0]);
							break;
						case 4:
							console.error(this.LogCache[0]);
							break;
					}
					this.LogCache.shift();//remove 1st element
				}
			}
			else {
				switch (type) {
					case 1:
						console.log(logText);
						break;
					case 2:
						console.info(logText);
						break;
					case 3:
						console.warn(logText);
						break;
					case 4:
						console.error(logText);
						break;
				}
			}
		}
		if ((mirageOpenCTISettings.LOG_USECONTROL) && (this.ControlReady)) {
			if (mirageOpenCTISettings.LOG_USECACHE) {
				while (this.LogCache.length > 0) {
					this.LogControl().append(this.LogCache[0]);
					this.LogCache.shift();//remove 1st element
				}
			}
			else {
				this.LogControl().append(value);
			}
		}
	}
	catch (e) {
	}
};