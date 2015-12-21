

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


### TODO

- RoaRelation methods:
    - <del>build dynamic form from needed data</del>
    - **support templated urls**
- requestconfig: resolve against current host (dont expand `/` into full url)
- response: body: "Content Iframe (uses browser accept header!)"
