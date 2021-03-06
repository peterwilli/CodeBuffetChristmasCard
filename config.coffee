exports.config =
  # See docs at http://brunch.readthedocs.org/en/latest/config.html.
  conventions:
    ignored: /^(vendor.*\.less|.+node_modules.+|.+_.+\..+)$/
  modules:
    definition: false
    wrapper: false
  paths:
    public: '_public'
  files:
    javascripts:
      joinTo:
        'js/app.js': /^(app|vendor)/

      order:
        before: [
          'app/scripts/jquery-2.0.3.min.js'
          'app/scripts/modernizr-latest.js'
        ]
        after: [
          'app/scripts/main.coffee'
        ]

    stylesheets:
      joinTo:
        'css/app.css' : /^(app|vendor)/

    templates:
      joinTo:
        'js/templates.js': /.+\.jade$/

  plugins:
    jade:
      options:
        pretty: yes # Adds pretty-indentation whitespaces to output (false by default)

    bower:
      extend:
        "bootstrap" : 'vendor/bootstrap/docs/assets/js/bootstrap.js'
        "angular-mocks": []
        "styles": []
      asserts:
        "img" : /bootstrap(\\|\/)img/
        "font": /font-awesome(\\|\/)font/