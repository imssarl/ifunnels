/*!
 * froala_editor v2.8.1 (https://www.froala.com/wysiwyg-editor)
 * License https://froala.com/wysiwyg-editor/terms/
 * Copyright 2014-2018 Froala Labs
 */

(function (factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['jquery'], factory);
    } else if (typeof module === 'object' && module.exports) {
        // Node/CommonJS
        module.exports = function( root, jQuery ) {
            if ( jQuery === undefined ) {
                // require('jQuery') returns a factory that requires window to
                // build a jQuery instance, we normalize how we use modules
                // that require this pattern but the window provided is a noop
                // if it's defined (how jquery works)
                if ( typeof window !== 'undefined' ) {
                    jQuery = require('jquery');
                }
                else {
                    jQuery = require('jquery')(root);
                }
            }
            return factory(jQuery);
        };
    } else {
        // Browser globals
        factory(window.jQuery);
    }
}(function ($) {

  

  // Extend defaults.
  $.extend($.FE.DEFAULTS, {
    quickInsertButtons: ['image', 'video', 'embedly', 'table', 'ul', 'ol', 'hr'],
    quickInsertTags: ['p', 'div', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'pre', 'blockquote']
  });

  $.FE.QUICK_INSERT_BUTTONS = {}

  $.FE.DefineIcon('quickInsert', {
    PATH: '<path d="M22,16.75 L16.75,16.75 L16.75,22 L15.25,22.000 L15.25,16.75 L10,16.75 L10,15.25 L15.25,15.25 L15.25,10 L16.75,10 L16.75,15.25 L22,15.25 L22,16.75 Z"/>',
    template: 'svg'
  });

  $.FE.RegisterQuickInsertButton = function (name, data) {
    $.FE.QUICK_INSERT_BUTTONS[name] = $.extend({
      undo: true
    }, data);
  }

  $.FE.RegisterQuickInsertButton('image', {
    icon: 'insertImage',
    requiredPlugin: 'image',
    title: 'Insert Image',
    undo: false,
    callback: function () {
      var editor = this;

      if (!editor.shared.$qi_image_input) {
        editor.shared.$qi_image_input = $('<input accept="image/*" name="quickInsertImage' + this.id + '" style="display: none;" type="file">');
        $('body:first').append(editor.shared.$qi_image_input);

        editor.events.$on(editor.shared.$qi_image_input, 'change', function () {
          var inst = $(this).data('inst');

          if (this.files) {
            inst.quickInsert.hide();
            inst.image.upload(this.files);
          }

          // Chrome fix.
          $(this).val('');
        }, true);
      }

      editor.$qi_image_input = editor.shared.$qi_image_input;

      if (editor.helpers.isMobile()) editor.selection.save();
      editor.events.disableBlur();
      editor.$qi_image_input.data('inst', editor).trigger('click');
    }
  })

  $.FE.RegisterQuickInsertButton('video', {
    icon: 'insertVideo',
    requiredPlugin: 'video',
    title: 'Insert Video',
    undo: false,
    callback: function () {
      var res = prompt(this.language.translate('Paste the URL of the video you want to insert.'));

      if (res) {
        this.video.insertByURL(res);
      }
    }
  })

  $.FE.RegisterQuickInsertButton('embedly', {
    icon: 'embedly',
    requiredPlugin: 'embedly',
    title: 'Embed URL',
    undo: false,
    callback: function () {
      var res = prompt(this.language.translate('Paste the URL of any web content you want to insert.'));

      if (res) {
        this.embedly.add(res);
      }
    }
  })

  $.FE.RegisterQuickInsertButton('table', {
    icon: 'insertTable',
    requiredPlugin: 'table',
    title: 'Insert Table',
    callback: function () {
      this.table.insert(2, 2);
    }
  })

  $.FE.RegisterQuickInsertButton('ol', {
    icon: 'formatOL',
    requiredPlugin: 'lists',
    title: 'Ordered List',
    callback: function () {
      this.lists.format('OL');
    }
  })

  $.FE.RegisterQuickInsertButton('ul', {
    icon: 'formatUL',
    requiredPlugin: 'lists',
    title: 'Unordered List',
    callback: function () {
      this.lists.format('UL');
    }
  })

  $.FE.RegisterQuickInsertButton('hr', {
    icon: 'insertHR',
    title: 'Insert Horizontal Line',
    callback: function () {
      this.commands.insertHR();
    }
  })

  $.FE.PLUGINS.quickInsert = function (editor) {
    var $quick_insert;

    /*
     * Set the quick insert button left and top.
     */
    function _place($tag) {

      // Quick insert's possition.
      var qiTop;
      var qiLeft;
      var qiTagAlign;

      qiTop = $tag.offset().top - editor.$box.offset().top;
      qiLeft = 0 - $quick_insert.outerWidth();

      if (editor.opts.enter != $.FE.ENTER_BR) {
        qiTagAlign = ($quick_insert.outerHeight() - $tag.outerHeight()) / 2;
      }

      // Enter key is BR. Insert an empty SPAN to get line height.
      else {
        $('<span>' + $.FE.INVISIBLE_SPACE + '</span>').insertAfter($tag)
        qiTagAlign = ($quick_insert.outerHeight() - $tag.next().outerHeight()) / 2;
        $tag.next().remove()
      }

      if (editor.opts.iframe) {
        qiTop += editor.$iframe.offset().top - editor.helpers.scrollTop();
      }

      // Reposition QI helper if visible.
      if ($quick_insert.hasClass('fr-on')) {
        if (qiTop >= 0) {
          $helper.css('top', qiTop - qiTagAlign);
        }
      }

      // Set quick insert's top and left.
      if (qiTop >= 0 && qiTop - qiTagAlign <= editor.$box.outerHeight() - $tag.outerHeight()) {
        if ($quick_insert.hasClass('fr-hidden')) {
          if ($quick_insert.hasClass('fr-on')) _showQIHelper();
          $quick_insert.removeClass('fr-hidden');
        }

        $quick_insert.css('top', qiTop - qiTagAlign);
      }
      else if ($quick_insert.hasClass('fr-visible')) {
        $quick_insert.addClass('fr-hidden');
        _hideHelper();
      }

      $quick_insert.css('left', qiLeft);
    }

    /*
     * Show quick insert.
     * Compute top, left, width and show the quick insert.
     */
    function _show($tag) {
      if (!$quick_insert) _initquickInsert();

      // Hide the quick insert helper if visible.
      if ($quick_insert.hasClass('fr-on')) {
        _hideHelper();
      }

      editor.$box.append($quick_insert);

      // Quick insert's possition.
      _place($tag);

      $quick_insert.data('tag', $tag);

      // Show the quick insert.
      $quick_insert.addClass('fr-visible');
    }

    /*
     * Check the tag where the cursor is.
     */
    function _checkTag() {
      // If editor has focus.
      if (editor.core.hasFocus()) {
        var tag = editor.selection.element();

        // Get block tag if Enter key is not BR.
        if (editor.opts.enter != $.FE.ENTER_BR && !editor.node.isBlock(tag)) {
          tag = editor.node.blockParent(tag);
        }

        if (editor.opts.enter == $.FE.ENTER_BR && !editor.node.isBlock(tag)) {
          var deep_tag = editor.node.deepestParent(tag);

          if (deep_tag) tag = deep_tag;
        }

        var _enterInBR = function () {
          return (editor.opts.enter != $.FE.ENTER_BR && editor.node.isEmpty(tag) && editor.node.isElement(tag.parentNode) && editor.opts.quickInsertTags.indexOf(tag.tagName.toLowerCase()) >= 0);
        }

        var _enterInP = function () {
          return (
            editor.opts.enter == $.FE.ENTER_BR &&
            ((tag.tagName == 'BR' && (!tag.previousSibling || tag.previousSibling.tagName == 'BR' || editor.node.isBlock(tag.previousSibling))) ||
              (editor.node.isEmpty(tag) && (!tag.previousSibling || tag.previousSibling.tagName == 'BR' || editor.node.isBlock(tag.previousSibling)) && (!tag.nextSibling || tag.nextSibling.tagName == 'BR' || editor.node.isBlock(tag.nextSibling))))
          );
        }

        if (tag && (_enterInBR() || _enterInP())) {
          // If the quick insert is not repositioned, just close the helper.
          if ($quick_insert && $quick_insert.data('tag').is($(tag)) && $quick_insert.hasClass('fr-on')) {
            _hideHelper();
          }

          // If selection is collapsed.
          else if (editor.selection.isCollapsed()) {
            _show($(tag));
          }
        }

        // Quick insert should not be visible.
        else {
          hide();
        }
      }
    }

    /*
     * Hide quick insert.
     */
    function hide() {
      if ($quick_insert) {
        // Hide the quick insert helper if visible.
        if ($quick_insert.hasClass('fr-on')) {
          _hideHelper();
        }

        // Hide the quick insert.
        $quick_insert.removeClass('fr-visible fr-on');
        $quick_insert.css('left', -9999).css('top', -9999);
      }
    }

    /*
     * Show the quick insert helper.
     */
    var $helper;

    function _showQIHelper(e) {
      if (e) e.preventDefault();

      // Hide helper.
      if ($quick_insert.hasClass('fr-on') && !$quick_insert.hasClass('fr-hidden')) {
        _hideHelper();
      }

      else {
        if (!editor.shared.$qi_helper) {
          var btns = editor.opts.quickInsertButtons;
          var btns_html = '<div class="fr-qi-helper">';
          var idx = 0;

          for (var i = 0; i < btns.length; i++) {
            var info = $.FE.QUICK_INSERT_BUTTONS[btns[i]];

            if (info) {
              if (!info.requiredPlugin || ($.FE.PLUGINS[info.requiredPlugin] && editor.opts.pluginsEnabled.indexOf(info.requiredPlugin) >= 0)) {
                btns_html += '<a class="fr-btn fr-floating-btn" role="button" title="' + editor.language.translate(info.title) + '" tabIndex="-1" data-cmd="' + btns[i] + '" style="transition-delay: ' + (0.025 * (idx++)) + 's;">' + editor.icon.create(info.icon) + '</a>';
              }
            }
          }

          btns_html += '</div>';
          editor.shared.$qi_helper = $(btns_html);

          // Quick insert helper tooltip.
          editor.tooltip.bind(editor.shared.$qi_helper, '> a.fr-btn');

          editor.events.$on(editor.shared.$qi_helper, 'mousedown', function (e) {
            e.preventDefault();
          }, true);
        }

        $helper = editor.shared.$qi_helper;
        $helper.appendTo(editor.$box);

        // Show the quick insert helper.
        setTimeout(function () {
          $helper.css('top', parseFloat($quick_insert.css('top')));
          $helper.css('left', parseFloat($quick_insert.css('left')) + $quick_insert.outerWidth());
          $helper.find('a').addClass('fr-size-1')
          $quick_insert.addClass('fr-on');
        }, 10);
      }
    }

    /*
     * Hides the quick insert helper and places the cursor.
     */
    function _hideHelper() {
      var $helper = editor.$box.find('.fr-qi-helper');

      if ($helper.length) {
        $helper.find('a').removeClass('fr-size-1');
        $helper.css('left', -9999);

        if (!$quick_insert.hasClass('fr-hidden')) $quick_insert.removeClass('fr-on');
      }
    }

    /*
     * Initialize the quick insert.
     */
    function _initquickInsert() {
      if (!editor.shared.$quick_insert) {
        // Append quick insert HTML to editor wrapper.
        editor.shared.$quick_insert = $('<div class="fr-quick-insert"><a class="fr-floating-btn" role="button" tabIndex="-1" title="' + editor.language.translate('Quick Insert') + '">' + editor.icon.create('quickInsert') + '</a></div>');
      }

      $quick_insert = editor.shared.$quick_insert;

      // Quick Insert tooltip.
      editor.tooltip.bind(editor.$box, '.fr-quick-insert > a.fr-floating-btn');

      // Editor destroy.
      editor.events.on('destroy', function () {
        $quick_insert.removeClass('fr-on').appendTo($('body:first')).css('left', -9999).css('top', -9999);

        if ($helper) {
          _hideHelper();
          $helper.appendTo($('body:first'));
        }
      }, true);

      editor.events.on('shared.destroy', function () {
        $quick_insert.html('').removeData().remove();
        $quick_insert = null;

        if ($helper) {
          $helper.html('').removeData().remove();
          $helper = null;
        }
      }, true);

      // Hide before a command is executed.
      editor.events.on('commands.before', hide);

      // Check if the quick insert should be shown after a command has been executed.
      editor.events.on('commands.after', function () {
        if (!editor.popups.areVisible()) {
          _checkTag();
        }
      });

      // User clicks on the quick insert.
      editor.events.bindClick(editor.$box, '.fr-quick-insert > a', _showQIHelper);

      // User clicks on a button from the quick insert helper.
      editor.events.bindClick(editor.$box, '.fr-qi-helper > a.fr-btn', function (e) {
        var cmd = $(e.currentTarget).data('cmd');

        // Trigger commands.before.
        if (editor.events.trigger('quickInsert.commands.before', [cmd]) === false) {
          return false;
        }

        $.FE.QUICK_INSERT_BUTTONS[cmd].callback.apply(editor, [e.currentTarget]);

        if ($.FE.QUICK_INSERT_BUTTONS[cmd].undo) {
          editor.undo.saveStep();
        }

        // Trigger commands.after.
        editor.events.trigger('quickInsert.commands.after', [cmd]);

        editor.quickInsert.hide();
      });

      // Scroll in editor wrapper. Quick insert buttons should scroll along
      editor.events.$on(editor.$wp, 'scroll', function () {
        if ($quick_insert.hasClass('fr-visible')) {
          _place($quick_insert.data('tag'));
        }
      });
    }

    /*
     * Tear up.
     */
    function _init() {
      if (!editor.$wp) return false;

      if (editor.opts.iframe) {
        editor.$el.parent('html').find('head').append('<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.4.0/css/font-awesome.min.css">');
      }

      // Hide the quick insert if user click on an image.
      editor.popups.onShow('image.edit', hide);

      // Check tag where cursor is to see if the quick insert needs to be shown.
      editor.events.on('mouseup', _checkTag);

      if (editor.helpers.isMobile()) {
        editor.events.$on($(editor.o_doc), 'selectionchange', _checkTag);
      }

      // Hide the quick insert when editor loses focus.
      editor.events.on('blur', hide);

      // Check if the quick insert should be shown after a key was pressed.
      editor.events.on('keyup', _checkTag);

      // Hide quick insert on keydown.
      editor.events.on('keydown', function () {
        setTimeout(function () {
          _checkTag();
        }, 0);
      });
    }

    return {
      _init: _init,
      hide: hide
    }
  };

}));
