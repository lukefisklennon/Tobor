var enabled = false;
var x = 0;
var y = 0;
var maxSpeed = 1024;

var emit = function(data) {
	xh = new XMLHttpRequest();
	url = "";
	for (d in data) {
		url += "&"+d+"="+data[d];
	};
	//console.log(url);
	//xh.open("GET",url,true);
	xh.open("GET","&"+"x="+x+"&y="+y,true);
	xh.send();
};

var highlight = function(e,w) {
	if (w) {
		e.style.backgroundColor = "#0000EE";
	} else {
		e.style.backgroundColor = "#2222FF";
	};
};

var enable = function() {
	enabled = true;
	highlight(surface,true);
};

var disable = function() {
	enabled = false;
	highlight(surface,false);
	x = 0;
	y = 0;
	emit();
};

window.ondevicemotion = function(e) {
	y = Math.round((e.accelerationIncludingGravity.x/3)*maxSpeed);
	x = Math.round((e.accelerationIncludingGravity.y/3)*maxSpeed);
	if (x > maxSpeed) x = maxSpeed;
	if (y > maxSpeed) y = maxSpeed;
};

setInterval(function() {
	if (enabled) {
		emit();
	};
},100);

surface = document.getElementById("drive");
surface.addEventListener("touchstart",enable,false);
surface.addEventListener("touchend",disable,false);
