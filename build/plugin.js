(function() {
  (function(root, factory) {

    /* AMD */
    if (typeof define === 'function' && define.amd) {
      define(['jquery'], function($) {
        return factory(root, $);
      });

      /* CommonJS */
    } else if (typeof module === 'object' && typeof module.exports === 'object') {
      factory(root, require('jquery'));

      /* Browser and the rest */
    } else {
      factory(root, root.$);
    }

    /* No return value */
  })(this, function(__root__, $) {
    var FroalaEditor, guessDefaultFontWeight, parseFontWeight;
    FroalaEditor = $.FroalaEditor;
    $.extend(FroalaEditor.DEFAULTS, {
      fontWeight: (function() {
        var i, j, results;
        results = [];
        for (i = j = 1; j <= 9; i = ++j) {
          results.push(i * 100);
        }
        return results;
      })(),
      fontWeightDefault: void 0
    });
    parseFontWeight = function(weight) {
      switch (weight) {
        case 'bold':
          return 700;
        case 'normal':
          return 400;
        default:
          return parseInt(weight, 10) || 400;
      }
    };
    guessDefaultFontWeight = (function() {
      var weight;
      weight = false;
      return function() {
        if (!weight) {
          weight = $('<div class="fr-element"/>').css('font-weight') || $('html,body').css('font-weight');
          weight = parseFontWeight(weight);
        }
        return weight;
      };
    })();
    FroalaEditor.PLUGINS.fontWeight = function(editor) {
      var apply, refresh, refreshOnShow;
      apply = function(weight) {
        editor.commands.applyProperty('font-weight', weight);
      };
      refreshOnShow = function($btn, $dropdown) {
        var $active, $ul, weight;
        weight = parseFontWeight($(editor.selection.element()).css('font-weight'));
        $dropdown.find('.fr-command.fr-active').removeClass('fr-active');
        $dropdown.find('.fr-command[data-param1="' + weight + '"]').addClass('fr-active');
        $ul = $dropdown.find('.fr-dropdown-list');
        $active = $dropdown.find('.fr-active').parent();
        if ($active.length) {
          $ul.parent().scrollTop($active.offset().top - $ul.offset().top - ($ul.parent().outerHeight() / 2 - $active.outerHeight() / 2));
        } else {
          $ul.parent().scrollTop(0);
        }
      };
      refresh = function($btn) {
        var weight;
        weight = parseFontWeight($(editor.selection.element()).css('font-weight'));
        $btn.find('> span').text(weight);
      };
      return {
        apply: apply,
        refreshOnShow: refreshOnShow,
        refresh: refresh
      };
    };
    FroalaEditor.RegisterCommand('fontWeight', {
      type: 'dropdown',
      title: 'Font Weight',
      displaySelection: function(editor) {
        return true;
      },
      displaySelectionWidth: 30,
      defaultSelection: function() {
        return guessDefaultFontWeight();
      },
      html: function() {
        var defaultWeight, j, len, list, ref, weight;
        list = [];
        defaultWeight = this.opts.fontWeightDefault || guessDefaultFontWeight();
        ref = this.opts.fontWeight;
        for (j = 0, len = ref.length; j < len; j++) {
          weight = ref[j];
          list.push('<li><a class="fr-command" data-cmd="fontWeight" data-param1="' + weight + '" title="' + weight + '">' + (weight === defaultWeight ? weight + " (" + (this.language.translate('Normal Font Weight')) + ")" : weight) + "</a></li>");
        }
        return '<ul class="fr-dropdown-list">' + list.join('') + '</ul>';
      },
      callback: function(command, weight) {
        this.fontWeight.apply(weight);
      },
      refresh: function($el) {
        this.fontWeight.refresh($el);
      },
      refreshOnShow: function($btn, $dropdown) {
        this.fontWeight.refreshOnShow($btn, $dropdown);
      }
    });

    /* No global variable export */
  });

}).call(this);
