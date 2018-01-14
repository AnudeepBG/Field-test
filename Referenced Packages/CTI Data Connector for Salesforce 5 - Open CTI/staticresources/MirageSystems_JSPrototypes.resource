if (typeof String.prototype.startsWith != 'function') {
	String.prototype.startsWith = function (str) {
		return this.slice(0, str.length) == str;
	};
}
if (typeof String.prototype.endsWith != 'function') {
	String.prototype.endsWith = function (str) {
		return this.slice(-str.length) == str;
	};
}
if (typeof String.prototype.isStrYes != 'function') {
	String.prototype.isStrYes = function () {
		return this.toLowerCase() == 'y' || this == '1' || this.toLowerCase() == 't' || this.toLowerCase() == 'true' || this.toLowerCase() == 'yes' || this.toLowerCase() == 'j' || this.toLowerCase() == 'ja';
	};
}
if (typeof String.prototype.onlyNumeric != 'function') {
	String.prototype.onlyNumeric = function () {
		return this.replace(/\D/g,'');
	};
}
if (typeof String.prototype.HTMLEncode != 'function') {
	String.prototype.HTMLEncode = function () {
		return this.replace('%', '%25').replace('+', '%2B').replace('#', '%23').replace('!', '%21').replace('"', '%22').replace('\'', '%27').replace('$', '%24')
				.replace(')', '%29').replace('(', '%28').replace('*', '%2A').replace(',', '%2C').replace('-', '%2D').replace('.', '%2E').replace('~', '%7E')
				.replace('/', '%2F').replace(':', '%3A').replace(';', '%3B').replace('<', '%3C').replace('>', '%3E').replace('?', '%3F').replace('{', '%7B')
				.replace('@', '%40').replace(']', '%5D').replace('\\', '%5C').replace('[', '%5B').replace('^', '%5E').replace('_', '%5F').replace('}', '%7D')
				.replace('|', '%7C').replace('&', '%26').replace('=', '%3D');
	};
}
if (typeof String.prototype.removeStart != 'function') {
	String.prototype.removeStart = function (str) {
		if (this.startsWith(str)) {
			return this.slice(str.length);
		}
		else {
			return this;
		}
	};
}
if (!Object.keys) {
  Object.keys = (function () {
    var hasOwnProperty = Object.prototype.hasOwnProperty,
        hasDontEnumBug = !({toString: null}).propertyIsEnumerable('toString'),
        dontEnums = [
          'toString',
          'toLocaleString',
          'valueOf',
          'hasOwnProperty',
          'isPrototypeOf',
          'propertyIsEnumerable',
          'constructor'
        ],
        dontEnumsLength = dontEnums.length;

    return function (obj) {
      if (typeof obj !== 'object' && typeof obj !== 'function' || obj === null) throw new TypeError('Object.keys called on non-object');

      var result = [];

      for (var prop in obj) {
        if (hasOwnProperty.call(obj, prop)) result.push(prop);
      }

      if (hasDontEnumBug) {
        for (var i=0; i < dontEnumsLength; i++) {
          if (hasOwnProperty.call(obj, dontEnums[i])) result.push(dontEnums[i]);
        }
      }
      return result;
    };
  })();
}
if (typeof Number.prototype.toHHMMSS != 'function') {
	Number.prototype.toHHMMSS = function () {
	    var sec_num = parseInt(this, 10); // don't forget the second param
	    var hours   = Math.floor(sec_num / 3600);
	    var minutes = Math.floor((sec_num - (hours * 3600)) / 60);
	    var seconds = sec_num - (hours * 3600) - (minutes * 60);
	
	    if (hours   < 10) {hours   = "0"+hours;}
	    if (minutes < 10) {minutes = "0"+minutes;}
	    if (seconds < 10) {seconds = "0"+seconds;}
	    var time    = hours+':'+minutes+':'+seconds;
	    return time;
	}
}
if (typeof Array.prototype.Move != 'function') {
	Array.prototype.Move = function(from, to) {
	    this.splice(to, 0, this.splice(from, 1)[0]);
	};
}
if (typeof Array.prototype.MoveTo != 'function') {
	Array.prototype.MoveTo = function(item, to) {
		for (var i=0;i<this.length;i++) {
			if (this[i] == item) {
				this.splice(to, 0, this.splice(i, 1)[0]);
			}
		}
	};
}