(function() {
  (function(factory) {

    /* Browser and WebWorker */
    var root;
    root = (function() {
      if (typeof self === 'object' && self !== null && self.self === self) {
        return self;

        /* Server */
      } else if (typeof global === 'object' && global !== null && global.global === global) {
        return global;
      }
    })();

    /* AMD */
    if (typeof define === 'function' && typeof define.amd === 'object' && define.amd !== null) {
      define(['jquery', 'exports'], function($) {
        return factory(root, $);
      });

      /* CommonJS */
    } else if (typeof module === 'object' && module !== null && typeof module.exports === 'object' && module.exports !== null) {
      factory(root, require('jquery'));

      /* Browser and the rest */
    } else {
      factory(root, root.$);
    }

    /* No return value */
  })(function(__root__, $) {
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
      var run, weight;
      weight = void 0;
      run = false;
      return function() {
        var $el;
        if (!run) {
          run = true;
          $el = $('<div class="fr-element"/>');
          weight = $el.hide().appendTo('body').css('font-weight');
          $el.remove();
          weight || (weight = $('html,body').css('font-weight'));
          weight = parseFontWeight(weight);
        }
        return weight;
      };
    })();
    FroalaEditor.PLUGINS.fontWeight = function(editor) {
      var apply, refresh, refreshOnShow;
      apply = function(weight) {
        if (editor.commands.applyProperty != null) {
          editor.commands.applyProperty('font-weight', weight);
        } else {
          editor.format.applyStyle('font-weight', weight);
        }
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
        $btn.find('> span').text(weight).css('font-weight', weight);
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
      defaultSelection: function(editor) {
        return editor.fontWeightDefault || (editor.fontWeightDefault = guessDefaultFontWeight());
      },
      html: function() {
        var base, defaultWeight, j, len, list, ref, text, weight;
        list = [];
        defaultWeight = (base = this.opts).fontWeightDefault || (base.fontWeightDefault = guessDefaultFontWeight());
        ref = this.opts.fontWeight;
        for (j = 0, len = ref.length; j < len; j++) {
          weight = ref[j];
          text = weight === defaultWeight ? weight + " (" + (this.language.translate('Normal Font Weight')) + ")" : weight;
          list.push(['<li>', '<a class="fr-command"', ' style="font-weight: ', weight, ';"', ' data-cmd="fontWeight"', ' data-param1="', weight, '"', ' title="', weight, '"', '>', text, '</a>', '</li>'].join(''));
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
