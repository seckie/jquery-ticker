
/*
 * jquery-ticker.js
 *
 * @author     Naoki Sekiguchi
 * @license    MIT
 * @require    jquery.js
 * @since      2014-08-20
 */
(function($, window, document) {
  'use strict';
  var DEBUG, Ticker;
  DEBUG = false;
  $.fn.ticker = function(options) {
    var opt;
    opt = options != null ? options : {};
    return this.each(function(i, element) {
      opt.element = $(element);
      return $(element).data('ticker', new Ticker(opt));
    });
  };
  Ticker = function() {
    this.options = {};
    $.extend(this.options, this.defaultOptions, arguments[0]);
    this.element = this.options.element;
    this.initialize();
    return this;
  };
  Ticker.prototype = {
    defaultOptions: {
      element: {},
      duration: 500,
      wrapperClassName: 'ticker-wrapper',
      innerClassName: 'ticker-inner',
      content: '.ticker-item',
      hoverStop: true
    },
    initialize: function() {
      var opt, self;
      self = this;
      opt = this.options;
      this.element.css({
        overflow: 'hidden'
      });
      this.content = this.element.find(opt.content);
      this.wrapper = $('<div class="' + opt.wrapperClassName + '" />');
      this.wrapper.css({
        overflow: 'hidden',
        width: 9999
      });
      this.inner = $('<div class="' + opt.innerClassName + '" />');
      this.inner.css({
        cssFloat: 'left',
        display: 'inline-block',
        minWidth: $(window).width()
      });
      this.inner.append(this.content);
      this.inner2 = this.inner.clone();
      if (DEBUG) {
        this.inner.addClass('inner1');
        this.inner2.addClass('inner2');
      }
      this.wrapper.append(this.inner, this.inner2);
      this.element.empty().append(this.wrapper);
      return this.start();
    },
    start: function() {
      var boxWidth, self;
      self = this;
      this.boxIndex = 0;
      boxWidth = this.getWholeWidth(this.content);
      this.baseDuration = this.options.duration * boxWidth / 20;
      this.animate();
      if (this.options.hoverStop === true) {
        this.wrapper.hover(function() {
          self.inner.stop();
          return self.inner2.stop();
        }, $.proxy(this.animate, this));
      }
      return this;
    },
    animate: function() {
      var box, boxMarginL, boxWidth, distance, duration, self;
      self = this;
      box = this.boxIndex === 0 ? this.inner : this.inner2;
      boxWidth = box.outerWidth();
      boxMarginL = parseInt(box.css('margin-left'), 10) || 0;
      distance = boxMarginL === 0 ? boxWidth : boxWidth + boxMarginL;
      duration = Math.floor(this.baseDuration * (distance / boxWidth));
      box.animate({
        'margin-left': '-=' + distance + 'px'
      }, duration, 'linear', function() {
        self.boxIndex = self.boxIndex === 0 ? 1 : 0;
        box.appendTo(self.wrapper).css({
          'margin-left': 0
        });
        return self.animate();
      });
      return this;
    },
    getWholeWidth: function($box) {
      var width;
      width = 0;
      $box.each(function(i, box) {
        return width += $(box).outerWidth();
      });
      return width;
    }
  };
})(jQuery, this, this.document);
