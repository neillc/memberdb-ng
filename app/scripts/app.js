
/**
 * @ngdoc overview
 * @name memberdbApp
 * @description
 * # memberdbApp
 *
 * Main module of the application.
 */
var app = angular
  .module('memberdbApp', [
    'ngAnimate',
    'ngAria',
    'ngCookies',
    'ngMessages',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch',
    'ui.bootstrap',
    'smart-table',
    'LocalStorageModule',
    'pascalprecht.translate'
  ]);
  
  
  app.config(function ($routeProvider) {
    'use strict';
    $routeProvider
      .when('/', {
        templateUrl: 'views/main.html',
        controller: 'MainCtrl'
      })
      .when('/login', {
        templateUrl: 'views/login.html',
        controller: 'LoginCtrl'
      })
      .when('/member-list', {
        templateUrl: 'views/members-list.html',
        controller: 'MembersListCtrl'
      })
      .when('/about', {
        templateUrl: 'views/about.html',
        controller: 'AboutCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });
  });
  
  app.run(function ($rootScope, $location, $log, apiService, alertService, menuService) {
      // somewhere to put the menu, yes!
      $rootScope.menus = menuService;
      $rootScope.loggedIn = false;

      // listen for route changes to ensure we're logged in on all pages except
      // the login page
      $rootScope.$on('$routeChangeStart', function () {
        // set the defaults for the index page elements - these are overridden
        // in the few controllers that need to
        $rootScope.pageHeading = '';
        //if (!apiService.access) {
          //$log.debug('no access', $location.path());
          //if ($location.path() !== '/keystone/logout') {
            //$location.path('/keystone/login');
          //}
        //}
      });

      // root binding for alertService
      //$rootScope.closeAlert = alertService.closeAlert;
});
 
