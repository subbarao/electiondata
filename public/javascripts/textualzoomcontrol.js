	function TextualZoomControl() {
	}
	
	TextualZoomControl.prototype = new GControl();

// 	Creates a one DIV for each of the buttons and places them in a container
// 	DIV which is returned as our control element.
	TextualZoomControl.prototype.initialize = function(map) {
		var container = document.createElement("div");

// "Zoom In" button
		var zoomInDiv = document.createElement("div");
		this.setButtonStyle_(zoomInDiv);
		container.appendChild(zoomInDiv);
		zoomInDiv.appendChild(document.createTextNode("Zoom In"));
		// The "true" argument in the zoomIn() method allows continuous zooming
		GEvent.addDomListener(zoomInDiv, "click", function() {map.zoomIn(null,null,true);} );

// "Zoom Out" button
		var zoomOutDiv = document.createElement("div");
		this.setButtonStyle_(zoomOutDiv);
		zoomOutDiv.style.borderTop = 0+'px';
		container.appendChild(zoomOutDiv);
		zoomOutDiv.appendChild(document.createTextNode("Zoom Out"));
		// The "true" argument in the zoomOut() method allows continuous zooming
		GEvent.addDomListener(zoomOutDiv, "click", function() {map.zoomOut(null,true);} );

// 		We add the control to to the map container and return the element 
// 		for the map class to position properly.

		map.getContainer().appendChild(container);
		return container;
	}


// 	The control will appear in the top left corner of the map with 7 pixels of padding.
	TextualZoomControl.prototype.getDefaultPosition = function() {
		return new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(15, 7));
	}

// Sets the proper CSS for the given button element.
	TextualZoomControl.prototype.setButtonStyle_ = function(button) {
		button.style.textDecoration = "none";
		button.style.color = "black";
		button.style.backgroundColor = "white";
//		button.style.font = "12px Verdana bold";
		button.style.fontFamily = "Verdana";
		button.style.fontSize = "12px";
		button.style.fontWeight= "bold";
		button.style.border = "1px solid gray";
		button.style.padding = "0px";
		button.style.marginBottom = "0px";
		button.style.textAlign = "center";
		button.style.width = "7em";
		button.style.height = "15px";
		button.style.cursor = "pointer";
	}

