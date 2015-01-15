
/**
 * @ngdoc overview
 * @name memberdbApp
 * @description
 * # memberdbApp
 *
 * Main module of the application.
 */
angular
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
  ])
  .config(function ($routeProvider) {
    'use strict';
    $routeProvider
      .when('/', {
        templateUrl: 'views/main.html',
        controller: 'MainCtrl'
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
