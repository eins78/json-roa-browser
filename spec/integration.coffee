test = require('tape')
webdriverio = require('webdriverio')

console.log 'Selenium port: ' + process.env.CI_SELENIUM_PORT

browser = webdriverio.remote
  port: process.env.CI_SELENIUM_PORT || 4444
  baseUrl: 'http://localhost:' + process.env.CI_ROA_API_PORT || 5000
  desiredCapabilities: { browserName: 'firefox' }

# just a stub to test the setup
test 'duckduckgo', (t)->
  t.plan(1)

  browser
    .init()
    .url('https://duckduckgo.com/')
    .setValue('#search_form_input_homepage', 'WebdriverIO')
    .click('#search_button_homepage')
    .getTitle().then((title)->
      t.equal title, 'WebdriverIO (Software) at DuckDuckGo'
    )
    .end()
