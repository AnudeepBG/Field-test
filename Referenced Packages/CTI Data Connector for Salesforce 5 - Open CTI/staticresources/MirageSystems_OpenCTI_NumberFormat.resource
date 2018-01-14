//  00 49 7525 920790
function getFormat1(internationalprefix, nrCountryCode, nrAreaCode, nrLocalNumber)
{
	return internationalprefix + nrCountryCode + nrAreaCode + nrLocalNumber;
}
//  49 7525 920790
function getFormat2(nrCountryCode, nrAreaCode, nrLocalNumber)
{
	return nrCountryCode + nrAreaCode + nrLocalNumber;
}
//  00 49 7525 920790 or 0 7525 920790
function getFormat3(localCountryCode, longdistanceprefix, internationalprefix, nrCountryCode, nrAreaCode, nrLocalNumber)
{
	var result = '';
	
	if (nrCountryCode != localCountryCode)
	{
		// Number from other country
		result = internationalprefix + nrCountryCode;
	}
	else
	{
		result = longdistanceprefix;
	}
	result = result + nrAreaCode + nrLocalNumber;

	return result;
}
//	00 49 0 7525 920790
function getFormat4(longdistanceprefix, internationalprefix, nrCountryCode, nrAreaCode, nrLocalNumber)
{
	return internationalprefix + nrCountryCode + longdistanceprefix + nrAreaCode + nrLocalNumber;
}
// 49 0 7525 920790
function getFormat5(longdistanceprefix, nrCountryCode, nrAreaCode, nrLocalNumber)
{
	return nrCountryCode + longdistanceprefix + nrAreaCode + nrLocalNumber;
}
function FormatPhoneNumber(localCountryCode, longdistanceprefix, internationalprefix, nrCountryCode, nrAreaCode, nrLocalNumber) {
	//hier wird die Nummer formatiert
	
	//document.getElementById('result').innerHTML = number + ' - ' + longdistancerule + ' - ' + internationalprefix + ' - ' + countrycode + '<br>xxx';
	document.getElementById('result').innerHTML = getNumberQueryString(localCountryCode, longdistanceprefix, internationalprefix, nrCountryCode, nrAreaCode, nrLocalNumber);
}
function callFormatPhoneNumber() {
	FormatPhoneNumber(document.getElementById('localCountryCode').value,
		document.getElementById('longdistanceprefix').value,
		document.getElementById('internationalprefix').value,
		document.getElementById('nrCountryCode').value,
		document.getElementById('nrAreaCode').value,
		document.getElementById('nrLocalNumber').value);
}
function PrepareNumberForDial(number, line) {
	try {
		if (mirageOpenCTISettings.ADAPTER_SETTINGS_TRUNCATEPHONENUMBERAT) {
			var idx = number.toLowerCase().indexOf(mirageOpenCTISettings.ADAPTER_SETTINGS_TRUNCATEPHONENUMBERAT.toLowerCase());
			if (idx > -1) {
				number = number.substr(0, idx);
			}
		}
		if (line) {
			number = line + number;
		}
	}
	catch (e) {
		mirageLogger.LogError('PrepareNumberForDial caused an exception:', e);
	}
	return number;
}