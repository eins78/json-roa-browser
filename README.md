# [JSON-ROA](http://json-roa.github.io) Hypermedia API Browser

![status: beta](https://img.shields.io/badge/status-beta-orange.svg)

## Features:

- Request Configuration
  - set Headers and URL to `HTTP GET` JSON-ROA enabled resources
  - save to URL(-hash)/browser history
- JSON-Roa Inspector
  - Relations
  - Collection
  - Meta-Relations
  - Methods (to issue new requests)
- Response Inspector for raw data
  - Request config
  - Headers
  - JSON (without -ROA)
  - JSON-ROA Data

## Screenshot

![Screenshot](https://cloud.githubusercontent.com/assets/134942/12662514/3eb98eaa-c621-11e5-9be3-eec2f7547c2c.png)

### TODO

- [x] RoaRelation methods:
    - [x] build dynamic form from needed data
    - [x] **support templated urls**
- [x] requestconfig: resolve against current host (dont expand `/` into full url)
- [ ] response: body: "Content Iframe (uses browser accept header!)"

#### "Issue Request" ActionForm

- [x] when templated URL -> ask for vars*
  - [x] * vars come from lib (as array), build JSON preset
  - [ ] build a form for the variables
- [x] when body possible* -> ask for body, content-type
  - [x] * method is not GET or DELETE
- [ ] save full url config to RequestConfig (template + vars)
    - [ ] move request/template handling to model
    - [ ] allow edit from main form


## Development

### Magic things

Good to know when reading the code:

- `app`: [(docs)](http://ampersandjs.com/docs#ampersand-app)
  an "global" object called `app` is set up in `main` and the different
  parts of the app are attached to it.
  **Calling `require('ampersand-app')` anywhere will the return this same
  object** (it's a singleton).
- `ampersand-react-mixin` [(docs)](https://github.com/ampersandjs/ampersand-react-mixin#ampersand-react-mixin)
  Wherever instances of Models are passed into React components, they
  will automatically listen on the changes of those instances.
