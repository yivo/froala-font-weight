((root, factory) ->

  # AMD
  if typeof define is 'function' and define.amd
    define ['jquery'], ($) ->
      factory(root, $)

  # CommonJS
  else if typeof module is 'object' && typeof module.exports is 'object'
    factory(root, require('jquery'))

  # Browser and the rest
  else
    factory(root, root.$)

  # No return value
  return

)(this, (__root__, $) ->
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
    weight = false
    ->
      unless weight
        weight = $('<div class="fr-element"/>').css('font-weight') or $('html,body').css('font-weight')
        weight = parseFontWeight(weight)
      weight
  
  FroalaEditor.PLUGINS.fontWeight = (editor) ->
  
    apply = (weight) ->
      editor.commands.applyProperty('font-weight', weight)
      return
  
    refreshOnShow = ($btn, $dropdown) ->
      weight = parseFontWeight( $(editor.selection.element()).css('font-weight') )
  
      $dropdown.find('.fr-command.fr-active').removeClass('fr-active')
      $dropdown.find('.fr-command[data-param1="' + weight + '"]').addClass('fr-active')
      $ul = $dropdown.find('.fr-dropdown-list')
      $active = $dropdown.find('.fr-active').parent()
  
      if $active.length
        $ul.parent().scrollTop($active.offset().top - $ul.offset().top - ($ul.parent().outerHeight() / 2 - $active.outerHeight() / 2))
      else
        $ul.parent().scrollTop(0)
      return
  
    refresh = ($btn) ->
      weight = parseFontWeight( $(editor.selection.element()).css('font-weight') )
      $btn.find('> span').text(weight)
      return
  
    {apply, refreshOnShow, refresh}
  
  FroalaEditor.RegisterCommand 'fontWeight',
    type: 'dropdown'
  
    title: 'Font Weight'
  
    displaySelection: (editor) ->
      true
  
    displaySelectionWidth: 30
  
    defaultSelection: ->
      guessDefaultFontWeight()
  
    html: ->
      list = []
      defaultWeight = @opts.fontWeightDefault or guessDefaultFontWeight()
      for weight in @opts.fontWeight
        list.push '<li><a
          class="fr-command"
          data-cmd="fontWeight"
          data-param1="' + weight + '"
          title="' + weight + '">' +
          (if weight == defaultWeight
            "#{weight} (#{@language.translate('Normal Font Weight')})"
          else weight) +
        "</a></li>"
  
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
  
  # No global variable export
  return
)