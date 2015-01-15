
/**
 * @ngdoc function
 * @name memberdbApp.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the memberdbApp
 */
angular.module('memberdbApp')
  .controller('MembersListCtrl', function ($scope, apiService, $log) {
    'use strict';
    apiService.GET(
      'members', 
      function(data) {
        $scope.data = data;
      });
  });
