
/**
 * @ngdoc function
 * @name memberdbApp.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the memberdbApp
 */
angular.module('memberdbApp')
  .controller('MainCtrl', function ($scope) {
    'use strict';
    $scope.awesomeThings = [
      'HTML5 Boilerplate',
      'AngularJS',
      'Karma'
    ];
  });
  
  var app = angular.module('memberdbApp');

  app.run(function (menuService, apiService) {
    var menu = {
      'title': 'Login',
      'action': '#/login',
    };

    menuService.push(menu);
  });
