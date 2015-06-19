coffee_lint_option =
  no_tabs:
    level: "error"
  indentation:
    level: "warn"
  arrow_spacing:
    level: "error"
  cyclomatic_complexity:
    level: "ignore"
  empty_constructor_needs_parens:
    level: "error"
  max_line_length:
    level: "ignore"
  line_endings:
    value: "unix"
  newlines_after_classes:
    level: "error"
  no_empty_param_list:
    level: "error"
  no_implicit_parens:
    level: "error"
  non_empty_constructor_needs_parens:
    level: "error"
  space_operators:
    level: "warn"
  no_unnecessary_fat_arrows:
    level: "error"

coffee_files = ["src/app.coffee","src/Model/*.coffee","src/Util/*.coffee","src/View/*.coffee","src/Controller/*.coffee","src/Controller/*/*.coffee","src/MainController.coffee"]


module.exports = (grunt) ->
  grunt.initConfig(
    pkg: grunt.file.readJSON("package.json")

    watch:
      src:
        files: ["src/*.coffee","src/*/*.coffee","src/*/*/*.coffee"]
        tasks: ["coffeelint:src","coffee:src"]
        options:
          livereload : true
      resource:
        files: 'resource/style/**/*.scss'
        tasks: ['scsslint','compass']
        options:
          livereload : true

    coffee:
      options:
        join: true
        bare: true
      src:
        options:
          sourceMap: true
        files:
          "dev/app.js" : coffee_files

    coffeelint:
      src:
        files:
          src: coffee_files
        options:
          coffee_lint_option

    scsslint:
      allFiles: ['resource/style/*.scss']
      options:
        config: 'config/scss-lint.yml'

    compass:
      dist:
        options:
          sassDir: "resource/style"
          imageDir: "resource"
          cssDir: "dev"
          generatedImagesDir: "dev"
          relativeAssets: true

    yuidoc:
      dist:
        name: "music sheet"
        description: "sheetgen"
        version: "0.0.1"
        options:
          paths: 'src'
          outdir: 'docs/'
          syntaxtype: "coffee"
          extension: ".coffee"
          selleck: "true"
          attributesEmit: "true"


    grunt.loadNpmTasks(task) for task in [
      "grunt-coffeelint"
      "grunt-contrib-coffee"
      "grunt-exec"
      "grunt-contrib-watch"
      "grunt-contrib-connect"
      "grunt-open"
      "grunt-contrib-yuidoc"
      "grunt-contrib-compass"
      "grunt-scss-lint"
    ]

    grunt.registerTask("develop","develop task"
      [
        "coffeelint:src"
        "coffee:src"
        "scsslint"
        "compass"
        "yuidoc"
      ]
    )

  )
