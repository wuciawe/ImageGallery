class ImageController

  constructor: (@$log, @$scope, @DataService) ->
    vm = @
    vm.onShow = false
    @$log.debug "constructing ImageController"
    vm.itemList = []
    angular.element(document.getElementById('order-nav')).css
      width: document.getElementById('order-nav').clientWidth
    @$scope.$watch ->
      vm.orderItemList.curPage
    , (nv, ov) ->
      if nv != undefined
        vm.orderItemList.pageRange = [vm.orderItemList.lb() .. vm.orderItemList.rb()]
        ft = (vm.orderItemList.curPage - 1) * vm.orderItemList.pageOff
        lt = if ft + 10 < vm.itemList.length then ft + 10 else vm.itemList.length
        vm.orderItemList.itemList = vm.itemList.slice(ft, lt)
    vm.orderItemList =
      pageOff: 10
      indexOff: 5
      xlb: ->
        Math.max(1, vm.orderItemList.curPage - (vm.orderItemList.indexOff - 1) // 2)
      rb: ->
        t = vm.orderItemList.xlb() + vm.orderItemList.indexOff - 1
        if t < vm.orderItemList.pages then  t else vm.orderItemList.pages
      lb: ->
        xt = vm.orderItemList.xlb()
        t = xt + vm.orderItemList.indexOff
        if t < vm.orderItemList.pages then xt else Math.max(1, vm.orderItemList.pages - vm.orderItemList.indexOff)
      dec: ->
        vm.orderItemList.curPage -= 1 if vm.orderItemList.curPage > 1
      inc: ->
        vm.orderItemList.curPage += 1 if vm.orderItemList.curPage < vm.orderItemList.pages
    @$log.info(vm.orderItemList)
  selectItem : (item) ->
    @curItem = item
  showFullImage : (loc) ->
    @fullImageUrl = "http://localhost/#{@currentCollection}/#{loc}"
    $('#fullImageModal').modal('show')
    true
  randomSelect : ->
    @curItem = @itemList[Math.floor(Math.random() * @itemList.length)]
  updateCollection : ->
    @$log.info("update collection")
    @onShow = false
    @curItem = undefined
    @orderItemList.curPage = undefined
    cq = @collectionQuery
    @collectionQuery = undefined
    @currentCollection = undefined
    vm = @
    @DataService.jsonData(cq).then (itemList) ->
      console.log(itemList)
      if itemList.length > 0
        vm.itemList = itemList
        vm.orderItemList.pages = Math.ceil(vm.itemList.length / vm.orderItemList.pageOff)
        vm.orderItemList.totalPageRange = [1 .. vm.orderItemList.pages]
        vm.orderItemList.curPage = 1
        vm.currentCollection = cq
        vm.onShow = true
    , (status) ->
      vm.$log.error status