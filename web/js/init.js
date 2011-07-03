/* Copyright (c) 2007 Paul Bakaus (paul.bakaus@googlemail.com) and Brandon Aaron (brandon.aaron@gmail.com || http://brandonaaron.net)
 * Dual licensed under the MIT (http://www.opensource.org/licenses/mit-license.php)
 * and GPL (http://www.opensource.org/licenses/gpl-license.php) licenses.
 *
 * $LastChangedDate: 2007-10-06 20:11:15 +0200 (Sa, 06 Okt 2007) $
 * $Rev: 3581 $
 *
 * Version: @VERSION
 *
 * Requires: jQuery 1.2+
 */

(function($){
	
$.dimensions = {
	version: '@VERSION'
};

// Create innerHeight, innerWidth, outerHeight and outerWidth methods
$.each( [ 'Height', 'Width' ], function(i, name){
	
	// innerHeight and innerWidth
	$.fn[ 'inner' + name ] = function() {
		if (!this[0]) return;
		
		var torl = name == 'Height' ? 'Top'    : 'Left',  // top or left
		    borr = name == 'Height' ? 'Bottom' : 'Right'; // bottom or right
		
		return num( this, name.toLowerCase() ) + num(this, 'padding' + torl) + num(this, 'padding' + borr);
	};
	
	// outerHeight and outerWidth
	$.fn[ 'outer' + name ] = function(options) {
		if (!this[0]) return;
		
		var torl = name == 'Height' ? 'Top'    : 'Left',  // top or left
		    borr = name == 'Height' ? 'Bottom' : 'Right'; // bottom or right
		
		options = $.extend({ margin: false }, options || {});
		
		return num( this, name.toLowerCase() )
				+ num(this, 'border' + torl + 'Width') + num(this, 'border' + borr + 'Width')
				+ num(this, 'padding' + torl) + num(this, 'padding' + borr)
				+ (options.margin ? (num(this, 'margin' + torl) + num(this, 'margin' + borr)) : 0);
	};
});

// Create scrollLeft and scrollTop methods
$.each( ['Left', 'Top'], function(i, name) {
	$.fn[ 'scroll' + name ] = function(val) {
		if (!this[0]) return;
		
		return val != undefined ?
		
			// Set the scroll offset
			this.each(function() {
				this == window || this == document ?
					window.scrollTo( 
						name == 'Left' ? val : $(window)[ 'scrollLeft' ](),
						name == 'Top'  ? val : $(window)[ 'scrollTop'  ]()
					) :
					this[ 'scroll' + name ] = val;
			}) :
			
			// Return the scroll offset
			this[0] == window || this[0] == document ?
				self[ (name == 'Left' ? 'pageXOffset' : 'pageYOffset') ] ||
					$.boxModel && document.documentElement[ 'scroll' + name ] ||
					document.body[ 'scroll' + name ] :
				this[0][ 'scroll' + name ];
	};
});

$.fn.extend({
	position: function() {
		var left = 0, top = 0, elem = this[0], offset, parentOffset, offsetParent, results;
		
		if (elem) {
			// Get *real* offsetParent
			offsetParent = this.offsetParent();
			
			// Get correct offsets
			offset       = this.offset();
			parentOffset = offsetParent.offset();
			
			// Subtract element margins
			offset.top  -= num(elem, 'marginTop');
			offset.left -= num(elem, 'marginLeft');
			
			// Add offsetParent borders
			parentOffset.top  += num(offsetParent, 'borderTopWidth');
			parentOffset.left += num(offsetParent, 'borderLeftWidth');
			
			// Subtract the two offsets
			results = {
				top:  offset.top  - parentOffset.top,
				left: offset.left - parentOffset.left
			};
		}
		
		return results;
	},
	
	offsetParent: function() {
		var offsetParent = this[0].offsetParent;
		while ( offsetParent && (!/^body|html$/i.test(offsetParent.tagName) && $.css(offsetParent, 'position') == 'static') )
			offsetParent = offsetParent.offsetParent;
		return $(offsetParent);
	}
});

function num(el, prop) {
	return parseInt($.css(el.jquery?el[0]:el,prop))||0;
};

})(jQuery);
(function($) {
	
	//If the UI scope is not available, add it
	$.ui = $.ui || {};
	
	//Add methods that are vital for all mouse interaction stuff (plugin registering)
	$.extend($.ui, {
		plugin: {
			add: function(module, option, set) {
				var proto = $.ui[module].prototype;
				for(var i in set) {
					proto.plugins[i] = proto.plugins[i] || [];
					proto.plugins[i].push([option, set[i]]);
				}
			},
			call: function(instance, name, arguments) {
				var set = instance.plugins[name]; if(!set) return;
				for (var i = 0; i < set.length; i++) {
					if (instance.options[set[i][0]]) set[i][1].apply(instance.element, arguments);
				}
			}	
		},
		cssCache: {},
		css: function(name) {
			if ($.ui.cssCache[name]) return $.ui.cssCache[name];
			
			var tmp = $("<div class='ui-resizable-gen'>").addClass(name).css(
				{position:'absolute', top:'-5000px', left:'-5000px', display:'block'}
			).appendTo('body');
			
			//Opera and Safari set width and height to 0px instead of auto
			//Safari returns rgba(0,0,0,0) when bgcolor is not set
			$.ui.cssCache[name] = !!(
				(/^[1-9]/.test(tmp.css('height')) || /^[1-9]/.test(tmp.css('width')) || 
				!/none/.test(tmp.css('backgroundImage')) || !/transparent|rgba\(0, 0, 0, 0\)/.test(tmp.css('backgroundColor')))
			);
			try { $('body').get(0).removeChild(tmp.get(0));	} catch(e){}
			return $.ui.cssCache[name];
		},
		disableSelection: function(e) {
			if (!e) return;
			e.unselectable = "on";
			e.onselectstart = function() {	return false; };
			if (e.style) e.style.MozUserSelect = "none";
		},
		enableSelection: function(e) {
			if (!e) return;
			e.unselectable = "off";
			e.onselectstart = function() { return true; };
			if (e.style) e.style.MozUserSelect = "";
		}
	});
	
	/********************************************************************************************************/

	$.fn.extend({
		mouseInteraction: function(o) {
			return this.each(function() {
				new $.ui.mouseInteraction(this, o);
			});
		},
		removeMouseInteraction: function(o) {
			return this.each(function() {
				if($.data(this, "ui-mouse"))
					$.data(this, "ui-mouse").destroy();
			});
		}
	});
	
	/********************************************************************************************************/
	
	$.ui.mouseInteraction = function(element, options) {
	
		var self = this;
		this.element = element;
		$.data(this.element, "ui-mouse", this);
		this.options = $.extend({}, options);
		
		$(element).bind('mousedown.draggable', function() { return self.click.apply(self, arguments); });
		if($.browser.msie) $(element).attr('unselectable', 'on'); //Prevent text selection in IE
		
	};
	
	$.extend($.ui.mouseInteraction.prototype, {
		
		destroy: function() { $(this.element).unbind('mousedown.draggable'); },
		trigger: function() { return this.click.apply(this, arguments); },
		click: function(e) {
			
			if(
				   e.which != 1 //only left click starts dragging
				|| $.inArray(e.target.nodeName.toLowerCase(), this.options.dragPrevention) != -1 // Prevent execution on defined elements
				|| (this.options.condition && !this.options.condition.apply(this.options.executor || this, [e, this.element])) //Prevent execution on condition
			) return true;
			
			var self = this;
			var initialize = function() {
				self._MP = { left: e.pageX, top: e.pageY }; // Store the click mouse position
				$(document).bind('mouseup.draggable', function() { return self.stop.apply(self, arguments); });
				$(document).bind('mousemove.draggable', function() { return self.drag.apply(self, arguments); });
			};

			if(this.options.delay) {
				if(this.timer) clearInterval(this.timer);
				this.timer = setTimeout(initialize, this.options.delay);
			} else {
				initialize();
			}
			
			return false;
			
		},
		stop: function(e) {			
			
			var o = this.options;
			if(!this.initialized) return $(document).unbind('mouseup.draggable').unbind('mousemove.draggable');

			if(this.options.stop) this.options.stop.call(this.options.executor || this, e, this.element);
			$(document).unbind('mouseup.draggable').unbind('mousemove.draggable');
			this.initialized = false;
			return false;
			
		},
		drag: function(e) {

			var o = this.options;
			if ($.browser.msie && !e.button) return this.stop.apply(this, [e]); // IE mouseup check
			
			if(!this.initialized && (Math.abs(this._MP.left-e.pageX) >= o.distance || Math.abs(this._MP.top-e.pageY) >= o.distance)) {
				if(this.options.start) this.options.start.call(this.options.executor || this, e, this.element);
				this.initialized = true;
			} else {
				if(!this.initialized) return false;
			}

			if(o.drag) o.drag.call(this.options.executor || this, e, this.element);
			return false;
			
		}
	});

 })(jQuery);
(function($) {

	$.fn.extend({
		slider: function(options) {
			var args = Array.prototype.slice.call(arguments, 1);

			if ( options == "value" )
				return $.data(this[0], "ui-slider").value(arguments[1]);

			return this.each(function() {
				if (typeof options == "string") {
					var slider = $.data(this, "ui-slider");
					slider[options].apply(slider, args);

				} else if(!$.data(this, "ui-slider"))
					new $.ui.slider(this, options);
			});
		}
	});

	$.ui.slider = function(element, options) {

		//Initialize needed constants
		var self = this;
		this.element = $(element);
		$.data(element, "ui-slider", this);
		this.element.addClass("ui-slider");

		//Prepare the passed options
		this.options = $.extend({}, options);
		var o = this.options;
		$.extend(o, {
			axis: o.axis || (element.offsetWidth < element.offsetHeight ? 'vertical' : 'horizontal'),
			maxValue: !isNaN(parseInt(o.maxValue)) ? parseInt(o.maxValue) :  100,
			minValue: parseInt(o.minValue) || 0,
			startValue: parseInt(o.startValue) || 'none'		
		});

		//Prepare the real maxValue
		o.realMaxValue = o.maxValue - o.minValue;

		//Calculate stepping based on steps
		o.stepping = parseInt(o.stepping) || (o.steps ? o.realMaxValue/o.steps : 0);

		$(element).bind("setData.slider", function(event, key, value){
			self.options[key] = value;
		}).bind("getData.slider", function(event, key){
			return self.options[key];
		});

		//Initialize mouse and key events for interaction
		this.handle = o.handle ? $(o.handle, element) : $('> *', element);
		$(this.handle)
			.mouseInteraction({
				executor: this,
				delay: o.delay,
				distance: o.distance || 0,
				dragPrevention: o.prevention ? o.prevention.toLowerCase().split(',') : ['input','textarea','button','select','option'],
				start: this.start,
				stop: this.stop,
				drag: this.drag,
				condition: function(e, handle) {
					if(!this.disabled) {
						if(this.currentHandle) this.blur(this.currentHandle);
						this.focus(handle,1);
						return !this.disabled;
					}
				}
			})
			.wrap('<a href="javascript:void(0)"></a>')
			.parent()
				.bind('focus', function(e) { self.focus(this.firstChild); })
				.bind('blur', function(e) { self.blur(this.firstChild); })
				.bind('keydown', function(e) {
					if(/(37|39)/.test(e.keyCode))
						self.moveTo((e.keyCode == 37 ? '-' : '+')+'='+(self.options.stepping ? self.options.stepping : (self.options.realMaxValue / self.size)*5),this.firstChild);
				})
		;

		//Position the node
		if(o.helper == 'original' && (this.element.css('position') == 'static' || this.element.css('position') == '')) this.element.css('position', 'relative');

		//Prepare dynamic properties for later use
		if(o.axis == 'horizontal') {
			this.size = this.element.outerWidth();
			this.properties = ['left', 'width'];
		} else {
			this.size = this.element.outerHeight();
			this.properties = ['top', 'height'];
		}

		//Bind the click to the slider itself
		this.element.bind('click', function(e) { self.click.apply(self, [e]); });

		//Move the first handle to the startValue
		if(!isNaN(o.startValue)) this.moveTo(o.startValue, 0);

		//If we only have one handle, set the previous handle to this one to allow clicking before selecting the handle
		if(this.handle.length == 1) this.previousHandle = this.handle;


		if(this.handle.length == 2 && o.range) this.createRange();

	};

	$.extend($.ui.slider.prototype, {
		plugins: {},
		createRange: function() {
			this.rangeElement = $('<div></div>')
				.addClass('ui-slider-range')
				.css({ position: 'absolute' })
				.css(this.properties[0], parseInt($(this.handle[0]).css(this.properties[0])) + this.handleSize(0)/2)
				.css(this.properties[1], parseInt($(this.handle[1]).css(this.properties[0])) - parseInt($(this.handle[0]).css(this.properties[0])))
				.appendTo(this.element);
		},
		updateRange: function() {
				this.rangeElement.css(this.properties[0], parseInt($(this.handle[0]).css(this.properties[0])) + this.handleSize(0)/2);
				this.rangeElement.css(this.properties[1], parseInt($(this.handle[1]).css(this.properties[0])) - parseInt($(this.handle[0]).css(this.properties[0])));
		},
		getRange: function() {
			return this.rangeElement ? this.convertValue(parseInt(this.rangeElement.css(this.properties[1]))) : null;
		},
		ui: function(e) {
			return {
				instance: this,
				options: this.options,
				handle: this.currentHandle,
				value: this.value(),
				range: this.getRange()
			};
		},
		propagate: function(n,e) {
			$.ui.plugin.call(this, n, [e, this.ui()]);
			this.element.triggerHandler(n == "slide" ? n : "slide"+n, [e, this.ui()], this.options[n]);
		},
		destroy: function() {
			this.element
				.removeClass("ui-slider ui-slider-disabled")
				.removeData("ul-slider")
				.unbind(".slider");
			this.handles.removeMouseInteraction();
		},
		enable: function() {
			this.element.removeClass("ui-slider-disabled");
			this.disabled = false;
		},
		disable: function() {
			this.element.addClass("ui-slider-disabled");
			this.disabled = true;
		},
		focus: function(handle,hard) {
			this.currentHandle = $(handle).addClass('ui-slider-handle-active');
			if(hard) this.currentHandle.parent()[0].focus();
		},
		blur: function(handle) {
			$(handle).removeClass('ui-slider-handle-active');
			if(this.currentHandle && this.currentHandle[0] == handle) { this.previousHandle = this.currentHandle; this.currentHandle = null; };
		},
		value: function(handle) {
			if(this.handle.length == 1) this.currentHandle = this.handle;
			return ((parseInt($(handle != undefined ? this.handle[handle] || handle : this.currentHandle).css(this.properties[0])) / (this.size - this.handleSize())) * this.options.realMaxValue) + this.options.minValue;
		},
		convertValue: function(value) {
			return (value / (this.size - this.handleSize())) * this.options.realMaxValue;
		},
		translateValue: function(value) {
			return ((value - this.options.minValue) / this.options.realMaxValue) * (this.size - this.handleSize());
		},
		handleSize: function(handle) {
			return $(handle != undefined ? this.handle[handle] : this.currentHandle)['outer'+this.properties[1].substr(0,1).toUpperCase()+this.properties[1].substr(1)]();	
		},
		click: function(e) {

			// This method is only used if:
			// - The user didn't click a handle
			// - The Slider is not disabled
			// - There is a current, or previous selected handle (otherwise we wouldn't know which one to move)
			var pointer = [e.pageX,e.pageY];
			var clickedHandle = false; this.handle.each(function() { if(this == e.target) clickedHandle = true;  });
			if(clickedHandle || this.disabled || !(this.currentHandle || this.previousHandle)) return;

			//If a previous handle was focussed, focus it again
			if(this.previousHandle) this.focus(this.previousHandle, 1);

			//Move focussed handle to the clicked position
			this.offset = this.element.offset();
			this.moveTo(this.convertValue(e[this.properties[0] == 'top' ? 'pageY' : 'pageX'] - this.offset[this.properties[0]] - this.handleSize()/2));

		},
		start: function(e, handle) {

			var o = this.options;

			this.offset = this.element.offset();
			this.handleOffset = this.currentHandle.offset();
			this.clickOffset = { top: e.pageY - this.handleOffset.top, left: e.pageX - this.handleOffset.left };
			this.firstValue = this.value();

			this.propagate('start', e);
			return false;

		},
		stop: function(e) {
			this.propagate('stop', e);
			if(this.firstValue != this.value()) this.propagate('change', e);
			return false;
		},
		drag: function(e, handle) {

			var o = this.options;
			var position = { top: e.pageY - this.offset.top - this.clickOffset.top, left: e.pageX - this.offset.left - this.clickOffset.left};

			var modifier = position[this.properties[0]];			
			if(modifier >= this.size - this.handleSize()) modifier = this.size - this.handleSize();
			if(modifier <= 0) modifier = 0;

			if(o.stepping) {
				var value = this.convertValue(modifier);
				value = Math.round(value / o.stepping) * o.stepping;
				modifier = this.translateValue(value);	
			}

			if(this.rangeElement) {
				if(this.currentHandle[0] == this.handle[0] && modifier >= this.translateValue(this.value(1))) modifier = this.translateValue(this.value(1));
				if(this.currentHandle[0] == this.handle[1] && modifier <= this.translateValue(this.value(0))) modifier = this.translateValue(this.value(0));
			}	

			this.currentHandle.css(this.properties[0], modifier);
			if(this.rangeElement) this.updateRange();
			this.propagate('slide', e);
			return false;

		},
		moveTo: function(value, handle) {

			var o = this.options;
			if(handle == undefined && !this.currentHandle && this.handle.length != 1) return false; //If no handle has been passed, no current handle is available and we have multiple handles, return false
			if(handle == undefined && !this.currentHandle) handle = 0; //If only one handle is available, use it
			if(handle != undefined) this.currentHandle = this.previousHandle = $(this.handle[handle] || handle);

			if(value.constructor == String) value = /\-\=/.test(value) ? this.value() - parseInt(value.replace('-=', '')) : this.value() + parseInt(value.replace('+=', ''));
			if(o.stepping) value = Math.round(value / o.stepping) * o.stepping;
			value = this.translateValue(value);

			if(value >= this.size - this.handleSize()) value = this.size - this.handleSize();
			if(value <= 0) value = 0;
			if(this.rangeElement) {
				if(this.currentHandle[0] == this.handle[0] && value >= this.translateValue(this.value(1))) value = this.translateValue(this.value(1));
				if(this.currentHandle[0] == this.handle[1] && value <= this.translateValue(this.value(0))) value = this.translateValue(this.value(0));
			}

			this.currentHandle.css(this.properties[0], value);
			if(this.rangeElement) this.updateRange();

			this.propagate('start', null);
			this.propagate('stop', null);
			this.propagate('change', null);

		}
	});

})(jQuery);