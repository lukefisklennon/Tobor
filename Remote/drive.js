var enabled = false;
var x = 0;
var y = 0;

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
	emit({x:0,y:0});
};

window.ondevicemotion = function(e) {
	y = e.accelerationIncludingGravity.x/6;
	x = e.accelerationIncludingGravity.y/6;
	if (x > 1) x = 1;
	if (y > 1) y = 1;
};

setInterval(function() {
	if (enabled) {
		emit({x:x,y:y});
	};
},100);

surface = document.getElementById("drive");
surface.addEventListener("touchstart",enable,false);
surface.addEventListener("touchend",disable,false);
