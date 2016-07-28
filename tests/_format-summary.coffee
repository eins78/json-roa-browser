ansiUp = require('ansi_up')
getStdin = require('get-stdin')

getStdin().then (stdin)->
  output = ansiUp.linkify(ansiUp.ansi_to_html(ansiUp.escape_for_html(stdin)))
  process.stdout.write '''
    <!doctype HTML>
      <head><meta charset="utf-8"></head>
      <body>
        <pre>
  ''' + output + '''
      </pre>
    </body>
  '''
