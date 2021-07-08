$.fn.speedBarChart = function(createOptions) {

	var chartOptions = createOptions;
	
    var chartTag = chartOptions.chartTag;
    
    delete chartOptions['chartTag'];

	var canvasRps = null;
	var canvasTps = null;
	var canvasActiveTransaction = null;
	var canvasActiveTransactionBg = null;
	
	var ctxRps = null;
	var ctxTps = null;
	var ctxActiveTransactionBg = null;
	
	//rps
	var rpsDataArr = [];
	var rpsCoordObjArr = [];
	var rpsImg = $("#speedbar-rps")[0];
	var rpsImgWidth = $("#speedbar-rps").width();
	var rpsImgHeight = $("#speedbar-rps").height();
	//rps
	
	//tps
	var tpsDataArr = [];
	var tpsCoordObjArr = [];
	var tpsImg1 = $("#speedbar-tps-green")[0];
	var tpsImg2 = $("#speedbar-tps-yellow")[0];
	var tpsImg3 = $("#speedbar-tps-red")[0];
	
	var tpsImg1Width = $("#speedbar-tps-green").width();
	var tpsImg1Height = $("#speedbar-tps-green").height();
	//tps	
	
	//activeTransaction
	var activeTransactionDataArr = [];
	var activeTransactionCoordObjArr = [];
	var activeTransactionDemo = null;
	var activeTransactionBgImg = ('N' == createOptions.darkmodeYn)? $("#speedbar-bg-white")[0] : $("#speedbar-bg-dark")[0];
	//activeTransaction
	
	function speedBarChart() {
		
		initAppendTag.call(this);
		
		initFunc.call(this);
	}
	
	function initAppendTag() {
		
		chartTag.append($("#tmpSpeedBar").html());		
		
		if('Y' == chartOptions.remarkYn) chartTag.find('.legend').show();
		else							 chartTag.find('.legend').hide();
		
		setTimeout(function() {
			canvasRps = $("<canvas/>").attr({width: chartTag.find(".rps").width(), height: chartTag.find(".rps").height()});
			canvasTps = $("<canvas/>").attr({width: chartTag.find(".tps").width(), height: chartTag.find(".tps").height()});
			
			chartTag.find('.rps').append(canvasRps);
			chartTag.find('.tps').append(canvasTps);
			
			ctxRps = canvasRps[0].getContext('2d');
			ctxTps = canvasTps[0].getContext('2d');
			
			initMakeActiveTransactionTag.call(this);
			initActiveTransactionAnimationEffect.call(this);
		}.bind(this), 0)
	}
	
	//rps
	function initMakeRpsCoordObj() {
		
		if(0 == rpsDataArr.length) {
			chartTag.find('.transaction').find('#rpsCnt').text('0');
			return;
		}
		
		var rpsStartTerm = 400;
		
		if(1 < rpsDataArr.length) rpsDataArr.shift();
		
		var coordObj = {
			timestamp: Date.now(),
			coordArr: [],
		};
		
		var orgCnt = rpsDataArr[0].cnt;
		var drawCnt = (orgCnt > 12)? 12 : orgCnt;
		
		for(var i = 0; i < drawCnt; i++) {
			coordObj.coordArr.push({startXCoord: 0, startDrawTime: null, term: (rpsStartTerm / drawCnt)});
		}
		
		rpsCoordObjArr.push(coordObj);
		
		chartTag.find('.transaction').find('#rpsCnt').text(orgCnt);
	}
	
	function initRemoveRpsCoordObj() {
			
		if(0 == rpsCoordObjArr.length) return;
		
		var currentTime = Date.now();
		
		rpsDataArr = rpsDataArr.filter(function(rpsData) {
			return rpsData.timestamp + (chartOptions.dataIntervalSeconds * 1000) * 2 >= currentTime;
		});
		
		rpsCoordObjArr = rpsCoordObjArr.filter(function(rpsCoordObj) {
			return rpsCoordObj.timestamp + 1000 >= currentTime;
		});
	}
	
	function rpsRequestAnimationFrame(progress) {
	
		if(!canvasRps) return;
		
		ctxRps.clearRect(0, 0, ctxRps.canvas.width, ctxRps.canvas.height);
		
		var currentTime = Date.now();
		
		var tmpRpsCoordObjArr = rpsCoordObjArr.filter(function(rpsCoordObj) {
			return rpsCoordObj.timestamp + 1000 > currentTime;
		});
		
		if(0 == tmpRpsCoordObjArr.length) return;
		
		var rpsCoordObj = tmpRpsCoordObjArr[0];
		
		for(var i = 0; i < rpsCoordObj.coordArr.length; i++) {
			
			var coord = rpsCoordObj.coordArr[i];
			
			if(coord.startXCoord >= ctxRps.canvas.width) continue;

			if(null != coord.startDrawTime) {
				coord.startXCoord += progress * ((ctxRps.canvas.width + rpsImgWidth - (chartTag.find(".activeTransactions").width() / 2)) / 400);
			}
			
			if(0 == i || (rpsCoordObj.coordArr[i - 1].startDrawTime && rpsCoordObj.coordArr[i - 1].startDrawTime + coord.term <= currentTime)) {
				
				if(null == coord.startDrawTime) {
					coord.startDrawTime = currentTime;
					coord.startXCoord = -rpsImgWidth;
				}
				
				ctxRps.beginPath();
				ctxRps.save();
				
				//ctxRps.drawImage(rpsImg, coord.startXCoord, (ctxRps.canvas.height / 2) - (rpsImgHeight / 2));
				
				ctxRps.moveTo(coord.startXCoord, ctxRps.canvas.height / 2);
				ctxRps.lineTo(coord.startXCoord + rpsImgWidth, ctxRps.canvas.height / 2);
				ctxRps.lineWidth = rpsImgHeight;
				ctxRps.lineCap = 'round';
				
				var grd = ctxRps.createLinearGradient(coord.startXCoord, 0, coord.startXCoord + rpsImgWidth, 0);
				
				grd.addColorStop(0.0, 	Chart.helpers.color('#42c4e1').alpha(0.0).rgbString());
				grd.addColorStop(0.1, 	Chart.helpers.color('#42c4e1').alpha(0.1).rgbString());
				grd.addColorStop(0.2, 	Chart.helpers.color('#42c4e1').alpha(0.2).rgbString());
				grd.addColorStop(0.3, 	Chart.helpers.color('#42c4e1').alpha(0.3).rgbString());
				grd.addColorStop(0.4, 	Chart.helpers.color('#42c4e1').alpha(0.4).rgbString());
				grd.addColorStop(0.5, 	Chart.helpers.color('#42c4e1').alpha(0.5).rgbString());
				grd.addColorStop(0.6, 	Chart.helpers.color('#42c4e1').alpha(0.6).rgbString());
				grd.addColorStop(0.7, 	Chart.helpers.color('#42c4e1').alpha(0.7).rgbString());
				grd.addColorStop(0.8, 	Chart.helpers.color('#42c4e1').alpha(0.8).rgbString());
				grd.addColorStop(0.9, 	Chart.helpers.color('#42c4e1').alpha(0.9).rgbString());
				grd.addColorStop(1.0, 	Chart.helpers.color('#42c4e1').alpha(1.0).rgbString());
				
				ctxRps.strokeStyle = grd;
				ctxRps.stroke();
				
				ctxRps.restore();
				ctxRps.closePath();
			}
		}
	}
	//rps
	
	//tps
	function initMakeTpsCoordObj() {
		
		if(0 == tpsDataArr.length) {
			chartTag.find('.transaction').find('#tpsCnt').text('0');
			return;
		}
		
		var tpsStartTerm = 400;
		
		if(1 < tpsDataArr.length) tpsDataArr.shift();
		
		var coordObj = {
			timestamp: Date.now(),
			coordArr: [],
		};

		var drawCnt1 = 0;
		var drawCnt2 = 0;
		var drawCnt3 = 0;
		
		if(12 < tpsDataArr[0].cnt) { 
			drawCnt1 = Math.ceil((tpsDataArr[0].cnt1 * 12) / tpsDataArr[0].cnt);
			drawCnt2 = Math.ceil((tpsDataArr[0].cnt2 * 12) / tpsDataArr[0].cnt);
			drawCnt3 = Math.ceil((tpsDataArr[0].cnt3 * 12) / tpsDataArr[0].cnt);
		}else{
			drawCnt1 = tpsDataArr[0].cnt1;
			drawCnt2 = tpsDataArr[0].cnt2;
			drawCnt3 = tpsDataArr[0].cnt3;				
		}
		
		for(var i = 0; i < drawCnt1; i++) {
			coordObj.coordArr.push({startXCoord: 0, startDrawTime: null, term: null, type: 1});
		}
		
		for(var i = 0; i < drawCnt2; i++) {
			coordObj.coordArr.push({startXCoord: 0, startDrawTime: null, term: null, type: 2});
		}
		
		for(var i = 0; i < drawCnt3; i++) {
			coordObj.coordArr.push({startXCoord: 0, startDrawTime: null, term: null, type: 3});
		}
		
		coordObj.coordArr = shuffle(coordObj.coordArr);
		
		coordObj.coordArr.forEach(function(coord, index) {
			coord.term = (tpsStartTerm / coordObj.coordArr.length);
		});
		
		tpsCoordObjArr.push(coordObj);
		
		chartTag.find('.transaction').find('#tpsCnt').text(tpsDataArr[0].cnt);
	}
	
	function initRemoveTpsCoordObj() {
		
		if(0 == tpsCoordObjArr.length) return;
		
		var currentTime = Date.now();
		
		tpsDataArr = tpsDataArr.filter(function(tpsData) {
			return tpsData.timestamp + (chartOptions.dataIntervalSeconds * 1000) * 2 >= currentTime;
		});
		
		tpsCoordObjArr = tpsCoordObjArr.filter(function(tpsCoordObj) {
			return tpsCoordObj.timestamp + 1000 >= currentTime;
		});
	}
	
	function tpsRequestAnimationFrame(progress) {
	
		if(!canvasTps) return;
		
		ctxTps.clearRect(0, 0, ctxTps.canvas.width, ctxTps.canvas.height);
		
		var currentTime = Date.now();
		
		var tmpTpsCoordObjArr = tpsCoordObjArr.filter(function(tpsCoordObj) {
			return tpsCoordObj.timestamp + 1000 > currentTime;
		});
		
		if(0 == tmpTpsCoordObjArr.length) return;
		
		var tpsCoordObj = tmpTpsCoordObjArr[0];
		
		for(var i = 0; i < tpsCoordObj.coordArr.length; i++) {
			
			var coord = tpsCoordObj.coordArr[i];
			
			if(coord.startXCoord >= ctxTps.canvas.width) continue;

			if(null != coord.startDrawTime) {
				coord.startXCoord += progress * ((ctxTps.canvas.width + tpsImg1Width - (chartTag.find(".activeTransactions").width() / 2)) / 400);
			}
			
			if(0 == i || (tpsCoordObj.coordArr[i - 1].startDrawTime && tpsCoordObj.coordArr[i - 1].startDrawTime + coord.term <= currentTime)) {
				
				if(null == coord.startDrawTime) {
					coord.startDrawTime = currentTime;
					coord.startXCoord = (chartTag.find(".activeTransactions").width() / 2) - tpsImg1Width;
				}
				
				ctxTps.beginPath();
				ctxTps.save();
				
				//ctxTps.drawImage((1 == coord.type)? tpsImg1 : (2 == coord.type)? tpsImg2 : tpsImg3, coord.startXCoord, (ctxTps.canvas.height / 2) - (tpsImg1Height / 2));
				
				var tmpColor = (1 == coord.type)? '#62d36f' : (2 == coord.type)? '#efc402' : '#ed3137';  
						
				ctxTps.moveTo(coord.startXCoord, ctxTps.canvas.height / 2);
				ctxTps.lineTo(coord.startXCoord + tpsImg1Width, ctxTps.canvas.height / 2);
				ctxTps.lineWidth = tpsImg1Height;
				ctxTps.lineCap = 'round';
				
				var grd = ctxTps.createLinearGradient(coord.startXCoord, 0, coord.startXCoord + tpsImg1Width, 0);
				
				grd.addColorStop(0.0, 	Chart.helpers.color(tmpColor).alpha(0.0).rgbString());
				grd.addColorStop(0.1, 	Chart.helpers.color(tmpColor).alpha(0.1).rgbString());
				grd.addColorStop(0.2, 	Chart.helpers.color(tmpColor).alpha(0.2).rgbString());
				grd.addColorStop(0.3, 	Chart.helpers.color(tmpColor).alpha(0.3).rgbString());
				grd.addColorStop(0.4, 	Chart.helpers.color(tmpColor).alpha(0.4).rgbString());
				grd.addColorStop(0.5, 	Chart.helpers.color(tmpColor).alpha(0.5).rgbString());
				grd.addColorStop(0.6, 	Chart.helpers.color(tmpColor).alpha(0.6).rgbString());
				grd.addColorStop(0.7, 	Chart.helpers.color(tmpColor).alpha(0.7).rgbString());
				grd.addColorStop(0.8, 	Chart.helpers.color(tmpColor).alpha(0.8).rgbString());
				grd.addColorStop(0.9, 	Chart.helpers.color(tmpColor).alpha(0.9).rgbString());
				grd.addColorStop(1.0, 	Chart.helpers.color(tmpColor).alpha(1.0).rgbString());
				
				ctxTps.strokeStyle = grd;
				ctxTps.stroke();
				
				ctxTps.restore();
				ctxTps.closePath();
			}
		}
	}
	//tps
	
	//activeTransaction
	function initMakeActiveTransactionTag() {

		//bg
		canvasActiveTransactionBg = $("<canvas/>").css({position: 'absolute', 'left': 0}).attr({width: chartTag.find(".activeTransactions").width(), height: chartTag.find(".activeTransactions").height()});
		
		chartTag.find('.activeTransactions').append(canvasActiveTransactionBg);
		
		//circle
		activeTransactionDemo = Sketch.create({
            container: chartTag.find(".activeTransactions")[0],
            retina: 'auto',
            autopause: false,
        });
		
        canvasActiveTransaction = $(activeTransactionDemo.canvas);
        
        canvasActiveTransaction.css({position: 'absolute', left: 0})
                               .attr({width: chartTag.find(".activeTransactions").width(), height: chartTag.find(".activeTransactions").height()})
                               .width(chartTag.find(".activeTransactions").width()).height(chartTag.find(".activeTransactions").height());

        //bg draw
		ctxActiveTransactionBg = canvasActiveTransactionBg[0].getContext('2d');

		ctxActiveTransactionBg.drawImage(activeTransactionBgImg, 0, 0, ctxActiveTransactionBg.canvas.width, ctxActiveTransactionBg.canvas.height);        
	}
	
	function initMakeActiveTransactionCoordObj() {
		
		if(0 == activeTransactionDataArr.length) return;
		
		if(1 < activeTransactionDataArr.length) activeTransactionDataArr.shift();
		
		activeTransactionCoordObjArr.push({
			timestamp: Date.now(),
			dataObj: {
				cnt1: activeTransactionDataArr[0].cnt1, 
				cnt2: activeTransactionDataArr[0].cnt2,
				cnt3: activeTransactionDataArr[0].cnt3,
			}				
		});
	}
	
	function initRemoveActiveTransactionData() {
		
		if(0 == activeTransactionCoordObjArr.length) return;
		
		var currentTime = Date.now();
		
		activeTransactionDataArr = activeTransactionDataArr.filter(function(activeTransactionData) {
			return activeTransactionData.timestamp + (chartOptions.dataIntervalSeconds * 1000) * 2 >= currentTime;
		});
		
		activeTransactionCoordObjArr = activeTransactionCoordObjArr.filter(function(activeTransactionCoordObj) {
			return activeTransactionCoordObj.timestamp + 1000 >= currentTime;
		});
	}
	
	function initActiveTransactionAnimationEffect() {
		
        var MAX_PARTICLES = 100;
        
        var COLOURS = ['#62d36f', '#efc402', '#ed3137'];

        var particles = [];
        var pool = [];

        activeTransactionDemo.spawn = function(x, y, type) {
            
            var tmpCnt = 0;

            if(0 < activeTransactionCoordObjArr.length) {
            	if(0 == type) 	   tmpCnt = activeTransactionCoordObjArr[0].dataObj.cnt1; 
            	else if(1 == type) tmpCnt = activeTransactionCoordObjArr[0].dataObj.cnt2;
            	else if(2 == type) tmpCnt = activeTransactionCoordObjArr[0].dataObj.cnt3;
            }
            
            if(0 == tmpCnt) return;
        	
            var particle, theta, force;

            if(particles.length >= MAX_PARTICLES) pool.push(particles.shift());

            particle = pool.length ? pool.pop() : new Particle();

            var maxBgCircleParticleSizeRatio = (tmpCnt >= 90)? 0.20 : (tmpCnt >= 60)? 0.15 : 0.10;
            particle.init(x, y, random(5, chartTag.find(".activeTransactions").height() * maxBgCircleParticleSizeRatio)); //원의 크기

            particle.wander = random( 0.5, 2.0 );
            particle.color = COLOURS[type];
            
            particle.drag = (tmpCnt >= 90)? random(0.9, 0.99) : (tmpCnt >= 60)? random(0.8, 0.89) : random(0.7, 0.79);

            theta = random(TWO_PI);
            force = random(2, 8);

            particle.vx = sin(theta) * force;
            particle.vy = cos(theta) * force;

            particles.push(particle);
        };

        activeTransactionDemo.update = function() {

            var i, particle;

            for(i = particles.length - 1; i >= 0; i--) {

                particle = particles[i];

                if(particle.alive) particle.move();
                else 			   pool.push(particles.splice(i, 1)[0]);
            }
        };

        activeTransactionDemo.draw = function() {
        	
        	activeTransactionDemo.setTransform(1, 0, 0, 1, 0, 0);
        	
            for(var i = particles.length - 1; i >= 0; i--) {
                particles[i].draw( activeTransactionDemo );
            }        
            
            for(var type = 0; type < 3; type++) {
            	
                var tmpCnt = 0;

                if(0 < activeTransactionCoordObjArr.length) {
                	tmpCnt = (0 == type)? activeTransactionCoordObjArr[0].dataObj.cnt1 : (1 == type)? activeTransactionCoordObjArr[0].dataObj.cnt2 : activeTransactionCoordObjArr[0].dataObj.cnt3;   
                }
            	
                activeTransactionDemo.beginPath();
                
                activeTransactionDemo.strokeStyle = COLOURS[type];
                activeTransactionDemo.fillStyle = COLOURS[type];
                
                var arcCoordX = (chartTag.find(".activeTransactions").width() / 6) * ((0 == type)? 1.5 : (1 == type)? 3.0 : 4.5);
                
                var bgCircleSizeRatio = (tmpCnt >= 90)? 0.25 : (tmpCnt >= 60)? 0.20 : 0.15;
                activeTransactionDemo.arc(arcCoordX, chartTag.find(".activeTransactions").height() / 2, chartTag.find(".activeTransactions").height() * bgCircleSizeRatio, 0, 2 * Math.PI); //원의크기
                activeTransactionDemo.stroke();
                activeTransactionDemo.fill();

                activeTransactionDemo.font = "13px Arial";
                activeTransactionDemo.textAlign = 'center';
                
                activeTransactionDemo.fillStyle = "#ffffff";
                activeTransactionDemo.fillText(tmpCnt, arcCoordX, (chartTag.find(".activeTransactions").height() / 2) + 5.0); //text 위치
                
                activeTransactionDemo.closePath();
            }
        };
	}
	
	function activeTransactionRequestAnimationFrame(progress) {
		
		if(!activeTransactionDemo) return;
		
		activeTransactionDemo.spawn((chartTag.find(".activeTransactions").width() / 6) * 1.5, chartTag.find(".activeTransactions").height() / 2, 0);
		activeTransactionDemo.spawn((chartTag.find(".activeTransactions").width() / 6) * 3.0, chartTag.find(".activeTransactions").height() / 2, 1);
		activeTransactionDemo.spawn((chartTag.find(".activeTransactions").width() / 6) * 4.5, chartTag.find(".activeTransactions").height() / 2, 2);
	}
	//activeTransaction
	
	function initFunc() {
		
		this.setInterval = function(standardTime) { 
			this.resizeFunc();
			
			initMakeRpsCoordObj.call(this);
			initRemoveRpsCoordObj.call(this);
			
			initMakeTpsCoordObj.call(this);
			initRemoveTpsCoordObj.call(this);

			initMakeActiveTransactionCoordObj.call(this);
			initRemoveActiveTransactionData.call(this);
		};
		
		this.addData = function(dataArr) {
			
			var dataObj = dataArr[0];
			
			var timestamp = Date.now();

			rpsDataArr.push({timestamp: timestamp, cnt: dataObj.rps});
			tpsDataArr.push({timestamp: timestamp, cnt: dataObj.tps, cnt1: dataObj.tpsShort, cnt2: dataObj.tpsMiddle, cnt3: dataObj.tpsLong});
			activeTransactionDataArr.push({timestamp: timestamp, cnt1: dataObj.activeShort, cnt2: dataObj.activeMiddle, cnt3: dataObj.activeLong});
		};
		
		var start = null;
		
		this.requestAnimationFrame = function(timestamp) {
		
			if(!start) start = timestamp;

			var progress = timestamp - start;
			
			if(progress > 0) {
				
				start = timestamp;
				
				rpsRequestAnimationFrame(progress);
				
				tpsRequestAnimationFrame(progress);
				
				activeTransactionRequestAnimationFrame(progress);
			}
		};
		
		this.resizeFunc = function() {
			
			setTimeout(function() {
				
				canvasRps.attr({width: chartTag.find(".rps").width(), height: chartTag.find(".rps").height()});
				
				canvasTps.attr({width: chartTag.find(".tps").width(), height: chartTag.find(".tps").height()});
				
				canvasActiveTransaction.attr({width: chartTag.find(".activeTransactions").width(), height: chartTag.find(".activeTransactions").height()}).width(chartTag.find(".activeTransactions").width()).height(chartTag.find(".activeTransactions").height());
				
				canvasActiveTransactionBg.attr({width: chartTag.find(".activeTransactions").width(), height: chartTag.find(".activeTransactions").height()}).width(chartTag.find(".activeTransactions").width()).height(chartTag.find(".activeTransactions").height());
				
				ctxActiveTransactionBg.drawImage(activeTransactionBgImg, 0, 0, ctxActiveTransactionBg.canvas.width, ctxActiveTransactionBg.canvas.height);
				
			}, 0);
		};
		
		this.filterData = function() {
			rpsDataArr = [];
			rpsCoordObjArr = [];
			tpsDataArr = [];
			tpsCoordObjArr = [];
			activeTransactionDataArr = [];
			activeTransactionCoordObjArr = [];
			
			chartTag.find('.transaction').find('#rpsCnt').text('0');
			chartTag.find('.transaction').find('#tpsCnt').text('0');
		};
		
		this.unload = function() {

			if(activeTransactionDemo) 
				activeTransactionDemo.destroy();
			
			rpsDataArr = null;
			rpsCoordObjArr = null;
			tpsDataArr = null;
			tpsCoordObjArr = null;
			activeTransactionDataArr = null;
			activeTransactionCoordObjArr = null;			
		};		
	}
	
	return new speedBarChart();
}