A reworking of memberdb - uses the original database but replaces the frontend
with a combination of a restful API and a single page web app written in
AngularJS

This readme (and a significant amount of scaffolding) was originally copied 
from r1chardj0n3s' angboard application - https://github.com/r1chardj0n3s/angboard

At this point most of this README is irrelevant. The only part of this app that is
currently working is an automatically generated REST api.

See for example http://127.0.0.1:8531/api/members/

Eventually there will be angularish and/or flask front end bits

Installation
============

**Note: requires python3**  (3.4 is recommended)

To set up, first install node / npm per your operating system, and then:

1. `git clone https://github.com/neillc/memberdb-ng`
2. `cd memberdb-ng`
3. `sudo npm install -g grunt-cli bower`
4. `npm install`
5. `bower install`

`npm install` installs stuff in the `packages.json` file and `bower install`
installs things from the `bower.json` file. The separate `npm install -g`
command is necessary because the core of the grunt and bower command-line
programs must be installed "globally" in /usr/local (out of our hands,
unfortunately).

Note: Python from `requirements.txt` for Flask are installed in
`.node-virtualenv` by the above.

And use a separate shell to fire up the grunt server:

    grunt serve 

For example:

    grunt serve 

This will open Chrome (or whatever) to view the site, assuming you did all
that on the same machine that you use as your browsing system. If it was not,
then manually open a browser connection to port 9000 on the system you ran
`grunt serve` on.

Install the "live reload" browser extension / plugin and you'll see your
changes LIVE when you make and save them to disk. Very premium.

If you have an issue with the Flask proxy attempting to run on an already-
used port, you may also specify `--proxy-port` to `grunt serve` to change to
a different port.

Keep an eye on the "grunt serve" window - it'll beep when you violate the
Javascript style guide.


Application Structure
=====================

This repository contains two applications:

1. the Javascript application in "app" providing the webapp using angularjs and 
   bootstrap.
2. A flask application in the backend driectory that supplies a restful API to
   the database.

memberdb-ng
----------------------------

The memberdb-ng application has a structure created by the angularjs generator
at <https://github.com/yeoman/generator-angular>. For some background on how
yoeman works, this is a nice introduction though it uses a different
generator: <https://www.youtube.com/watch?v=gKiaLSJW5xI>. Note that the "yo
angular:controller" and similar commands produce something very nearly
suitable - you'll still need to make some changes to satisfy the code
linting.

1. app.js which is the root application; this file should be as small as
   possible. If you add functionality to the $rootScope, consider whether it
   might be made a service instead.
2. the "home" page, providing a default view in the absence of other views.
3. "login" and "logout" events to allow components to initialise themselves
   when the user obtains access credentials / service catalog.

**memberdb-ng components and documentation**

* [AngularJS for application structure](https://docs.angularjs.org/guide)
  and because it's confusing, [here's why ng-model always needs a dotted
  name in itsexpression](http://jimhoskins.com/2012/12/14/nested-scopes-in-angularjs.html)
* [Bootstrap for page construction and layout](http://getbootstrap.com/css/)
* [AngularUI for Angular/Bootstrap integration](http://angular-ui.github.io/bootstrap/)
* [Font Awesome for iconography (class="fa fa-thumbs-up")](http://fortawesome.github.io/Font-Awesome/cheatsheet/)
* [angular-local-storage for in-browser state](https://github.com/grevory/angular-local-storage)
* [angular-smart-table for tables](http://lorenzofox3.github.io/smart-table-website/)
* [less for compiled CSS](http://lesscss.org/)
* [karma test runner](http://karma-runner.github.io/),
  [mocha BDD structure](http://visionmedia.github.io/mocha/)
  and [chai assertions library](http://chaijs.com/api/bdd/)
* [virtualenv - the npm version](https://www.npmjs.org/package/virtualenv)
* [underscore.js](http://underscorejs.org/)


**Notes**

The minification used in our build tool includes `ngmin` support so you don't
need to manually include the DI minification hacks usually needed in
AngularJS applications. This means that instead of having to write this::

  app.service('cinder', ['apiService', '$q'], function cinder(apiService, $q) {

we can just write this::

  app.service('cinder', function cinder(apiService, $q) {

In many views, we hook fetching this data into the route resolution (using
the resolve property) so it's loaded before we switch route to the new page.
This results in less strange variation in loaded pages as data comes in and
also allows nicer sharing of the fetch functionality between uses. For
example, in cinder::

    $routeProvider.when('/cinder/volumes', {
      controller: 'CinderVolumesCtrl',
      templateUrl: 'views/cinder_volumes.html',
      resolve: {
        volumes: function (cinder) {return cinder.volumes(false); }
      }
    });

The volumes data will be loaded before the routing switches view to the new
page.


backend
--------------------------

The backend provides a restful api for the JavaScript application. 

Tools
=====

Tools used in maintenance of this application:


bower
-----

bower is used to install and update components. It is written in the node.js
programming language, but we don't need to worry about that. Two operations
that might be needed are:

1. Installing a new component to use in the application. This is done using:

    bower install <name of component> -S

   The "-S" adds the component to the bower.json file so it's installed when
   "bower install" is invoked with no arguments. Good for deployment to a new
   environment.

   When a new Javascript or CSS component is installed, you should check that
   it is included in the appropriate index.html section. Usually this should
   happen automatically.

   You will almost certainly also need to manually add the new JS files to
   the karma test configuration in test/karma.con.js or it will fall about
   laughing.

2. Updating a component:

    bower update <name of component>


grunt
-----

grunt is used as a task management tool. It has a number of tasks defined,
all invokable as `grunt serve` or `grunt build` and so on:

* `serve` the application to a browser (also performs a `watch` and will
  additionally play well with `liveReload` if you have that installed in your
  browser)
* `build` the application for deployment, minifying (HTML, CSS and JS),
  cdn'ing, uglifying and so on and putting everything in the "dist" directory
* `test` to run the test suite under `karma` (using `mocha` and `chai`)
* `watch` for changes in the codebase and take action like compile the CSS
  source files using `less`, or re-run tests. It's automatically included in
  `serve` but if you want automatic re-runnning of tests when you make
  changes and *aren't* using `serve` then `grunt watch` is for you.


jslint
------

In addition to jshint (which picks up on some potential code errors) we also
use jslint to enforce a more strict coding style. It is fired automatically
by "grunt watch" (checking application code as it changes) and "grunt test"
(only checking the tests when they're run).

There are some configuration settings baked into grunt's run:

    browser: true,      // assume the code is running in a browser
    predef: ['angular', 'document'],
    indent: 2,          // 2-space indentation
    vars: true,         // allow multiple var statements in a function
    'continue': true,   // allow use of "continue" keyword in loops (wat)
    plusplus: true      // allow auto-increment (seriously)

If you really need to squash an "unused parameter" message (most likely
because Javascipt doesn't have keyword argument support) then you can surround a block of code with:

    /*jslint unparam: true*/
    ... code with unused parameter ...
    /*jslint unparam: false*/


Inteded Areas Of Development (aka TODO)
=======================================

* everything at the moment

