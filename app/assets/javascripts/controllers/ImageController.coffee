class ImageController
  constructor: (@$log, @$scope, @DataService) ->
    vm = @
    vm.orderNav = document.getElementById('order-nav')
    vm.favorNav = document.getElementById('favor-nav')
    vm.orderNavWidth = vm.orderNav.clientWidth
    vm.onShow = false
    @$log.debug "constructing ImageController"
    vm.itemList = undefined
    @$scope.$watch ->
      vm.orderItemList.curPage
    , (nv, ov) ->
      if nv != undefined
        vm.updatePageView()
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
  updatePageView : ->
    @orderItemList.pageRange = [@orderItemList.lb() .. @orderItemList.rb()]
    ft = (@orderItemList.curPage - 1) * @orderItemList.pageOff
    lt = if ft + 10 < @itemList.length then ft + 10 else @itemList.length
    @orderItemList.itemList = @itemList.slice(ft, lt)
  selectItem : (item) ->
    @curItem = item
  showFullImage : (loc) ->
    @fullImageUrl = "http://localhost/#{@currentCollection}/#{loc}"
    $('#fullImageModal').modal('show')
    true
  randomSelect : ->
    @curItem = @itemList[Math.floor(Math.random() * @itemList.length)]
  setItemList : (il) ->
    if @itemListo
      if il
        @itemList = @itemListo
        angular.element(@orderNav).css
          width: @orderNavWidth
        @updatePageView()
      else
        @itemList = @itemListf
        angular.element(@favorNav).css
          width: @orderNavWidth
        @updatePageView()
  vote: (item, up) ->
    @DataService.vote(@currentCollection, item['_id']['$oid'], up)
  updateCollection : ->
    @$log.info("update collection")
    $('#tabs a:first').tab('show')
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
        vm.itemListo = angular.copy(itemList).sort (a, b) ->
          a.title.localeCompare(b.title)
        vm.itemListf = itemList.sort (a, b) ->
          b.liked - a.liked
        vm.orderItemList.pages = Math.ceil(vm.itemListo.length / vm.orderItemList.pageOff)
        vm.orderItemList.totalPageRange = [1 .. vm.orderItemList.pages]
        vm.orderItemList.curPage = 1
        vm.currentCollection = cq
        vm.setItemList(true)
        vm.onShow = true
    , (status) ->
      vm.$log.error status