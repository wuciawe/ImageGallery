angular
.module 'viewImageApp', []
.value 'version', '0.1'
.config ['$locationProvider', ($locationProvider) ->
    $locationProvider.html5Mode
      enabled: true
      requireBase: false
]
.directive 'appVersion', ['version', (version) ->
  (scope, elem, attrs) ->
    elem.text(version)
]
.service 'DataService', ['$log', '$http', '$q', DataService]
.controller 'imageController', ['$log', '$scope', 'DataService', ImageController]