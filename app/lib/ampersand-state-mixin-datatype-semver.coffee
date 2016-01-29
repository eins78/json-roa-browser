SemVer = require('semver')

module.exports =
  dataTypes:
    semver:
      set: (newValue)->
        return switch
          # ok if already parsed:
          when newValue?.constructor is SemVer
            {val: newValue, type: 'semver'}

          # fail if not even a string
          when not typeof newValue is 'string'
              {val: newValue, type: typeof newValue}

          # ok if parseable as semver, fail if not a valid semver
          when (semver = (try SemVer(newValue)))?
              {val: newValue, type: 'semver'}

          else
              {val: newValue, type: 'not a valid semver'}

      compare: (currentVal, newVal, attributeName)->
        currentVal?.version is newVal.version
