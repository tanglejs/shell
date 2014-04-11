shell = require 'shell'
_ = require 'lodash'
config = require 'tangle-config'

logger = require 'winston'
logger.cli()

app = new shell
  prompt: "tangle>"

app.configure ->
  app.use shell.router shell: app
  app.use shell.history shell: app
  app.use shell.completer shell: app
  app.use shell.help shell: app, introduction: true

# TODO - Need to load this list from npm paths scan or something
commands = {
  'project': {}
  'project environment': require 'tangle-environment'
  'project environment :environment': require 'tangle-environment'
}

_.each commands, (fn, route) ->
  app.cmd route, (req, res) ->
    fn(req.params, logger)(config)
      .then (data) -> res.println data
      .fail (err) -> res.red(err).ln()
      .finally -> res.prompt() if req.shell.isShell
