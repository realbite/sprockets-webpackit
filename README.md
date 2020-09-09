# Sprockets Webpackit

This is a simple gem which will call  webpack-cli to compile designated js files ( including dependent modules ) within the standard sprockets asset pipeline.

## Installation

    gem install sprockets-webpackit

requires node.js to be installed along with webpack, webpack-cli and any other
node modules you require. ( eg coffeescript , truescript , etc )

    npm install webpack webpack-cli --save-dev

create a `webpack.config.js` to control the compilation process.

tested with:

    webpack:  version 4.44.1
    node:     version 12.13.0


## Configuration

    require 'sprockets/webpackit'

    Sprockets::Webpackit.pattern = /^*.js$/   # optional - override the default matcher
    Sprockets::Webpackit.mode = 'production'  # optional - default is RACK_ENV or 'development'

    map '/assets' do
       ...
    end

# Use

to process a file the name must match the given pattern. The default
is a suffix of `.webpack.js` , `.webpack.coffee` etc.

eg: in your `application.js`

    //= require application.webpack.coffee


you could also set the pattern to eg `/.*/`to accept all javascript files.
