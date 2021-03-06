{View, TextEditorView} = require 'atom-space-pen-views'

module.exports =
class OpenDialogView extends View
  @content: ->
    @div tabIndex: -1, class: 'atom-debugger', =>
      @div class: 'block', =>
        @label 'SWD Debugger'
        @subview 'targetEditor', new TextEditorView(mini: true, placeholderText: 'Process ID')
      @div class: 'block', =>
        @button class: 'inline-block btn', outlet: 'startButton', 'Select'
        @button class: 'inline-block btn', outlet: 'cancelButton', 'Cancel'

  initialize: (handler) ->
    @panel = atom.workspace.addModalPanel(item: this, visible: true)
    @targetEditor.focus()

    @cancelButton.on 'click', (e) => @destroy()
    @startButton.on 'click', (e) =>
      handler(@targetEditor.getText())
      @destroy()

  destroy: ->
    @panel.destroy()
