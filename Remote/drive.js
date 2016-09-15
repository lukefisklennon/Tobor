var panels = {all:document.getElementsByClassName("panel"),drive:document.getElementById("1"),arm:document.getElementById("2")};
var touchTypes = ["touchstart","touchmove","touchend","touchcancel"];
var arm = {last:0};

var emit = function(event,data) {
	x = new XMLHttpRequest();
	url = "?"+"event="+event
	for (d in data) {
		url += "&"+d+"="+data[d];
	};
	console.log(url);
	x.open("GET",url,true);
	x.send();
};

var highlight = function(e,w) {
	if (w) {
		e.style.backgroundColor = "#0000EE";
	} else {
		e.style.backgroundColor = "#2222FF";
	};
};

var drive = function(e) {
	if (e.type == "touchstart" || e.type == "touchmove") {
		highlight(panels.drive,true);
		x = e.changedTouches[0].pageX/panels.drive.offsetWidth;
		y = e.changedTouches[0].pageY/panels.drive.offsetHeight;
		emit("drive",{x:x,y:y})
	};
	if (e.type == "touchend" || e.type == "touchcancel") {
		highlight(panels.drive,false);
		emit("stop",{})
	};
};

var arm = function(e) {
	if (e.type == "touchstart") {
		highlight(panels.arm,true);
		x = e.changedTouches[0].pageX/panels.drive.offsetWidth;
		y = e.changedTouches[0].pageY/panels.drive.offsetHeight;
		arm.last = y;
		emit("arm",{x:x,y:0})
	};
	if (e.type == "touchmove") {
		x = e.changedTouches[0].pageX/panels.drive.offsetWidth;
		y = e.changedTouches[0].pageY/panels.drive.offsetHeight-arm.last;
		arm.last += y;
		emit("arm",{x:x,y:y})
	};
	if (e.type == "touchend" || e.type == "touchcancel") {
		highlight(panels.arm,false);
		emit("release",{})
	};
};

for (t in touchTypes) {
	panels.drive.addEventListener(touchTypes[t],drive,false);
	panels.arm.addEventListener(touchTypes[t],arm,false);
};
