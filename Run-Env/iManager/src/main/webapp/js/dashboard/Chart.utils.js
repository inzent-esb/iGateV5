function getYAxisTicksInfo(pMaxValue, pTickCount){
	
	var yAxisTicksInfo = {maxValue: null, stepSize: null};
		
	yAxisTicksInfo.maxValue = (pMaxValue < 10)? 10 : pMaxValue;
	yAxisTicksInfo.stepSize = yAxisTicksInfo.maxValue / (pTickCount - 1);
	
	return yAxisTicksInfo;
}

function convertValue(pValue, unitType, p_div_unit) {
	
	pValue = Number(pValue);
	
	if('PERCENT' == unitType) {
		return ((0 === pValue)? pValue : pValue.toFixed(2)) + " %";	
	}
	
	var div_unit = ('BYTE' == unitType)? 1024 : 1000;
	
	var unitArr = (p_div_unit)? p_div_unit : ['', 'K', 'M', 'G', 'T', 'P'];
	
	var dividedCnt = 0;
	
	while(true) {
	
		if(pValue < div_unit) break; 
		
		pValue = pValue / div_unit;
		
		dividedCnt = dividedCnt + 1;
	}
	
	return ((0 === pValue)? pValue : pValue.toFixed(2)) + (('' == unitArr[dividedCnt])? '' : ' ' + unitArr[dividedCnt]) + ((1024 == div_unit)? 'B' : '');
}

function randomNumber(min, max) {
	return Math.floor(Math.random() * (max - min + 1)) + min;
}

function shuffle(a) {
	
	var j, x, i;
    
	for(i = a.length - 1; i > 0; i--) {
		j = Math.floor(Math.random() * (i + 1));
        x = a[i];
        a[i] = a[j];
        a[j] = x;
    }
	
    return a;
}

function getDate(date) {
	var formatDate = makeFormat(date.getFullYear(), 4) + '-' + makeFormat(date.getMonth() + 1, 2) + '-' + makeFormat(date.getDate(), 2) + ' ' + makeFormat(date.getHours(), 2) + ':' + makeFormat(date.getMinutes(), 2) + ':' + makeFormat(date.getSeconds(), 2);
	return formatDate;
}

function makeFormat(n, digits) {
	var zero = '';
	n = n.toString();

	if (n.length < digits) {
		for (var i = 0; i < digits - n.length; i++){
			zero += '0';
		}
	}
  
	return zero + n;
}

function getCanvasMousePos(canvas, evt) {
	var rect = canvas.getBoundingClientRect();
	
	return {
		x: evt.clientX - rect.left,
		y: evt.clientY - rect.top
	};
}

//----------------------------------------
//Circular Queue
//----------------------------------------
function circularQueue(size) {
	
	this.rear = 0;
	this.front = 0;
	this.maxSize = size + 1;
	this.circular_Queue = new Array(this.maxSize);
	
	this.isEmpty = function() {
		return this.rear == this.front;
	};
	
	this.isFull = function() {
		return (this.rear + 1) % this.maxSize == this.front;
	};
	
	this.enQueue = function(obj) {
		if(this.isFull()) {
			console.log('full')
		}else{
            this.rear = (this.rear + 1) % this.maxSize;
            this.circular_Queue[this.rear] = obj; 
		}
	};
	
	this.deQueue = function() {
		if(this.isEmpaty()) {
			console.log('empty')
		}else{
            this.front = (this.front + 1) % this.maxSize;
            return this.circular_Queue[this.front];
		}
	};
}

// ----------------------------------------
// Particle (Speed bar)
// ----------------------------------------
function Particle( x, y, radius ) {
    this.init( x, y, radius );
}

Particle.prototype = {

    init: function( x, y, radius ) {

        this.alive = true;

        this.radius = radius || 10;
        this.wander = 0.15;
        this.theta = random( TWO_PI );
        this.drag = 0.92;
        this.color = '#fff';

        this.x = x || 0.0;
        this.y = y || 0.0;

        this.vx = 0.0;
        this.vy = 0.0;
    },

    move: function() {

        this.x += this.vx;
        this.y += this.vy;

        this.vx *= this.drag;
        this.vy *= this.drag;

        this.theta += random( -0.5, 0.5 ) * this.wander;
        this.vx += sin( this.theta ) * 0.1;
        this.vy += cos( this.theta ) * 0.1;

        this.radius *= 0.96;
        this.alive = this.radius > 0.5;
    },

    draw: function( ctx ) {
        ctx.beginPath();
        ctx.arc( this.x, this.y, this.radius, 0, TWO_PI );
        ctx.fillStyle = this.color;
        ctx.fill();
        ctx.closePath();		            
    }
};

function cloneObject(obj) {
	var clone = {};
	
    for(var i in obj) {
        if(typeof(obj[i])=="object" && obj[i] != null)
            clone[i] = cloneObject(obj[i]);
        else
            clone[i] = obj[i];
    }
    
    return clone;
}

function getUUID() {
	  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
		  var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
		  return v.toString(16);
	  });
}

function binanrySearch(dataArr, x) {
	var start = 0;
    var end = dataArr.length - 1;
          
    while(start <= end) {
        var mid = Math.floor((start + end) / 2);

        if(Math.floor(dataArr[mid].x / 1000) * 1000 == x) 		return {dataInfo: dataArr[mid], idx: mid};
        else if (Math.floor(dataArr[mid].x / 1000) * 1000 < x)  start = mid + 1;
        else											   		end = mid - 1;
    }
   
    return null;
}

(function (window) {
	
	if (!Array.prototype.findIndex) {
	  Object.defineProperty(Array.prototype, 'findIndex', {
	    value: function(predicate) {
	      'use strict';
	      if (this == null) {
	        throw new TypeError('Array.prototype.findIndex called on null or undefined');
	      }
	      if (typeof predicate !== 'function') {
	        throw new TypeError('predicate must be a function');
	      }
	      var list = Object(this);
	      var length = list.length >>> 0;
	      var thisArg = arguments[1];
	      var value;

	      for (var i = 0; i < length; i++) {
	        value = list[i];
	        if (predicate.call(thisArg, value, i, list)) {
	          return i;
	        }
	      }
	      return -1;
	    },
	    enumerable: false,
	    configurable: false,
	    writable: false
	  });
	}
	
	try {
		new MouseEvent('test');
		return false;
	} catch (e) {

	}

	var MouseEventPolyfill = function (eventType, params) {
		params = params || { bubbles: false, cancelable: false };
		var mouseEvent = document.createEvent('MouseEvent');
		mouseEvent.initMouseEvent(eventType,
				params.bubbles,
				params.cancelable,
				window,
				0,
				params.screenX || 0,
				params.screenY || 0,
				params.clientX || 0,
				params.clientY || 0,
				params.ctrlKey || false,
				params.altKey || false,
				params.shiftKey || false,
				params.metaKey || false,
				params.button || 0,
				params.relatedTarget || null
			);

			return mouseEvent;
	};

	MouseEventPolyfill.prototype = Event.prototype;

	window.MouseEvent = MouseEventPolyfill;
})(window);


