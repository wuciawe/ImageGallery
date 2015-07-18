class DataService
  constructor: (@$log, @$http, @$q) ->
    @$log.debug "constructing DataService"
  jsonData: (collection) ->
    deferred = @$q.defer()
    @$http
      method: "Get"
      url: "/jsondata/#{collection}"
    .success (data, status, headers, config) =>
      deferred.resolve data
    .error (data, status, headers, config) =>
      @$log.error "Failed to retrieve json data - status #{status}"
      deferred.reject data
    deferred.promise