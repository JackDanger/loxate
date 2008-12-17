// http://www.quirksmode.org/js/cookies.html
function setToken(email, token, should_expire) {
	if (should_expire) {
		var date = new Date();
		date.setTime(date.getTime() - 90000);
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = email+"="+token+expires+"; path=/";
}

function getToken(email) {
	var nameEQ = email + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}

function deleteToken(email) {
	createCookie(email,"",true);
}
