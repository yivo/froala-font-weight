###!
# froala-font-weight 1.0.3 | https://github.com/yivo/froala-font-weight | MIT License
###

((factory) ->

  __root__ = 
    # The root object for Browser or Web Worker
    if typeof self is 'object' and self isnt null and self.self is self
      self

    # The root object for Server-side JavaScript Runtime
    else if typeof global is 'object' and global isnt null and global.global is global
      global

    else
      Function('return this')()

  # Asynchronous Module Definition (AMD)
  if typeof define is 'function' and typeof define.amd is 'object' and define.amd isnt null
    define ['jquery', 'froala-editor'], ($) ->
      factory(__root__, $)

  # Server-side JavaScript Runtime compatible with CommonJS Module Spec
  else if typeof module is 'object' and module isnt null and typeof module.exports is 'object' and module.exports isnt null
    factory(__root__, require('jquery'), require('froala-editor'))

  # Browser, Web Worker and the rest
  else
    factory(__root__, $)

  # No return value
  return

)((__root__, $) ->
  {FroalaEditor} = $
  
  $.extend FroalaEditor.DEFAULTS,
    fontWeight: do -> (i * 100 for i in [1..9])
    fontWeightDefault: undefined
  
  parseFontWeight = (weight) ->
    switch weight
      when 'bold' then 700
      when 'normal' then 400
      else parseInt(weight, 10) or 400
  
  guessDefaultFontWeight = do ->
    weight = undefined
    run    = false
    ->
      unless run
        run    = true
        $el    = $('<div class="fr-element"/>')
        weight = $el.hide().appendTo('body').css('font-weight')
        $el.remove()
        weight ||= $('html,body').css('font-weight')
        weight = parseFontWeight(weight)
      weight
  
  FroalaEditor.PLUGINS.fontWeight = (editor) ->
  
    apply = (weight) ->
      if editor.commands.applyProperty?
        editor.commands.applyProperty('font-weight', weight)
      else
        editor.format.applyStyle('font-weight', weight)
      return
  
    refreshOnShow = ($btn, $dropdown) ->
      weight = parseFontWeight( $(editor.selection.element()).css('font-weight') )
  
      $dropdown.find('.fr-command.fr-active').removeClass('fr-active')
      $dropdown.find('.fr-command[data-param1="' + weight + '"]').addClass('fr-active')
      $ul     = $dropdown.find('.fr-dropdown-list')
      $active = $dropdown.find('.fr-active').parent()
  
      if $active[0]?
        $ul.parent().scrollTop($active.offset().top - $ul.offset().top - ($ul.parent().outerHeight() / 2 - $active.outerHeight() / 2))
      else
        $ul.parent().scrollTop(0)
      return
  
    refresh = ($btn) ->
      weight = parseFontWeight( $(editor.selection.element()).css('font-weight') )
      $btn.children('span').text(weight).css('font-weight', weight)
      return
  
    {apply, refreshOnShow, refresh}
  
  FroalaEditor.PLUGINS.fontWeight.VERSION = '1.0.3'
    
  FroalaEditor.RegisterCommand 'fontWeight',
    type: 'dropdown'
  
    title: 'Font Weight'
  
    displaySelection: (editor) ->
      true
  
    displaySelectionWidth: 30
  
    defaultSelection: (editor) ->
      editor.fontWeightDefault ||= guessDefaultFontWeight()
  
    html: ->
      list = []
      defaultWeight = @opts.fontWeightDefault ||= guessDefaultFontWeight()
      for weight in @opts.fontWeight
        text = if weight is defaultWeight
          "#{weight} (#{@language.translate('Normal Font Weight')})"
        else weight
        list.push [
          '<li>',
            '<a class="fr-command"',
              ' style="font-weight: ', weight, ';"',
              ' data-cmd="fontWeight"',
              ' data-param1="', weight, '"',
              ' title="', weight, '"',
              '>', text,
            '</a>'
          '</li>'
        ].join('')
  
      '<ul class="fr-dropdown-list">' + list.join('') + '</ul>'
  
    callback: (command, weight) ->
      @fontWeight.apply(weight)
      return
  
    refresh: ($el) ->
      @fontWeight.refresh($el)
      return
  
    refreshOnShow: ($btn, $dropdown) ->
      @fontWeight.refreshOnShow($btn, $dropdown)
      return
  # Nothing exported
  return
)