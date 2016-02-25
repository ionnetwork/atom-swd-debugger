DebuggerView = require './debugger-view'
{CompositeDisposable} = require 'atom'
fs = require 'fs'

module.exports = Debugger =
  subscriptions: null

  config:
    gdbPath:
      type: 'string'
      default: "arm-none-eabi-gdb"
    targetBinary:
      type: 'string'
      default: 'Target Binary'

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'debugger:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'core:close': =>
      @debuggerView?.destroy()
      @debuggerView = null
    @subscriptions.add atom.commands.add 'atom-workspace', 'core:cancel': =>
      @debuggerView?.destroy()
      @debuggerView = null

  deactivate: ->
    @subscriptions.dispose()
    # @openDialogView.destroy()
    @debuggerView?.destroy()

  serialize: ->

  toggle: ->
    if @debuggerView and @debuggerView.hasParent()
      @debuggerView.destroy()
      @debuggerView = null
    else
      # @openDialogView = new OpenDialogView (pid) =>
      target = atom.config.get("swd-debugger.targetBinary")
      # atom.config.set('android-debugger.processId', pid)
      if fs.existsSync(target)
        @debuggerView = new DebuggerView(target)
      else
        atom.confirm
          detailedMessage: "Can't find file #{target}."
          buttons:
            Exit: =>
