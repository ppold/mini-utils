module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    coffee:
      options:
        bare: true
      compile:
        expand: true
        cwd: 'src'
        src: ['**/*.coffee']
        dest: 'compiled/'
        ext: '.js'
    uglify:
      options:
        banner: '/*! <%= pkg.title %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
      build:
        expand: true
        cwd: '<%= coffee.compile.dest %>'
        src: ['**/*.js']
        dest: ''
        ext: '.js'
    clean: ["<%= coffee.compile.dest %>"]
    buster:
      app: {}

  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-buster')

  grunt.registerTask('test', ['coffee', 'buster', 'clean']);
  grunt.registerTask('default', ['coffee', 'uglify', 'clean']);
