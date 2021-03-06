###
 * jquery-ticker.js
 *
 * @author     Naoki Sekiguchi
 * @license    MIT
 * @require    jquery.js
 * @since      2014-08-20
###

(($, window) ->
  'use strict'
  DEBUG = false

  $.fn.ticker = (options) ->
    opt = options ? {}
    return @each((i, element) ->
      opt.element = $(element)
      $(element).data('ticker', new Ticker(opt))
    )

  Ticker = () ->
    # extend default options
    @options = {}
    $.extend(@options, @defaultOptions, arguments[0])
    @element = @options.element
    # initialize
    @initialize()
    return @

  Ticker.prototype =
    defaultOptions:
      element: {}
      duration: 500
      wrapperClassName: 'ticker-wrapper'
      innerClassName: 'ticker-inner'
      content: '.ticker-item'
      hoverStop: true
      velocityJs: false

    initialize: () ->
      self = @
      opt = @options
      @element.css(
        overflow: 'hidden'
      )
      @content = @element.find(opt.content)
      if !@content[0]
        console.error('\"content\" parameter element was not found')
        return @

      @wrapper = $('<div class="' + opt.wrapperClassName + '" />')
      @wrapper.css(
        overflow: 'hidden'
        width: 9999
      )
      @inner = $('<div class="' + opt.innerClassName + '" />')
      @inner.css(
        cssFloat: 'left'
        display: 'inline-block'
        minWidth: $(window).width()
      )
      @inner.append(@content)
      @inner2 = @inner.clone()
      if (DEBUG)
        @inner.addClass('inner1')
        @inner2.addClass('inner2')

      @wrapper.append(@inner, @inner2)
      @element.empty().append(@wrapper)

      @start()

    start: () ->
      self = @
      # Constant variables in animation function
      @boxIndex = 0
      boxWidth = @getWholeWidth(@content)
      @baseDuration = @options.duration * boxWidth / 20

      # Initial animation
      @animate()
      # add event
      if @options.hoverStop is true
        @wrapper.hover(() ->
          self.stop()
        , $.proxy(@animate, @))
      return @

    stop: () ->
      if @options.velocityJs is true
        @inner.velocity('stop')
        @inner2.velocity('stop')
      else
        @inner.stop()
        @inner2.stop()
      return @

    animate: () ->
      self = @
      # Animation target box is alternately changed
      box = if @boxIndex is 0 then @inner else @inner2
      boxWidth = box.outerWidth()
      boxMarginL = parseInt(box.css('margin-left'), 10) or 0
      # Compute remaining distance
      distance = if boxMarginL is 0 then boxWidth else boxWidth + boxMarginL
      # Compute animation duration
      duration = Math.floor(@baseDuration * (distance / boxWidth))
      # Animation
      prop =
        'margin-left': '-=' + distance + 'px'
      opt =
        duration: duration
        easing: 'linear'
        complete: () ->
          # Change target box
          self.boxIndex = if self.boxIndex is 0 then 1 else 0
          box.appendTo(self.wrapper).css(
            'margin-left': 0
          )
          # Recursive Processing
          self.animate()
      if @options.velocityJs is true
        return box.velocity(prop, opt)
      else
        return box.animate(prop, opt)

    getWholeWidth: ($box) ->
      width = 0
      $box.each((i, box) ->
        width += $(box).outerWidth()
      )
      return width

  return
)(jQuery, @)
