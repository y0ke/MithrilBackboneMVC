class MB.Controller.BaseController
  _.extend(@::, Backbone.Events)

  template: "template function reference here"

  ###*
  @property el {String}
  @description target selector to append(mount)
  ###
  el: null

  ###*
  @class MB.Controller.BaseController
  @constructor
  @param options {Object}
  @param options.el: {String} selector string pointing where to append contents
  @param options.template: {Function}  template function
  @description
  You may directly set both template and el as class properties.
  though they are ended up overwritten if the options have them,
  hence instance properties are stringer than class properties.
  ###
  constructor: (options) ->
    if options?.el then @el = options.el
    if options?.template then @template = options.template
    @listeningEvents = []
    _private.setGlobalMC.call(@)
    _private.setSubControllers.call(@)
    @component =
      controller: (data) => @
      view: @template
    @comp = @component

  ###*
  @property models {Object}
  ###
  models: {}

  ###*
  @property collections {Object}
  ###
  collections: []

  ###*
  @property subControllers {Array}
  @description
  set as Object {controller: controller instance,options: option object,name: string}
  subControllers would be initialized and rendered after render method is executed.
  subController instances will be set to @subCtrls when they are initialized.
  ###
  subControllers: []

  ###*
  @property util {Object}
  ###
  util: MB.Util

  ###*
  @property globalMC {Object}
  @example
  {sampleModel: MB.Model.SampleModel}
  @description global Model/Collection stated here would be set to @models / @collections
  ###
  globalMC: {}

  eventHandler: {}

  mount: ->
    m.mount($(@el)[0],@component)

  render: ->
    @component

  refresh: ->
    m.redraw()

  appendModels: (models) ->
    if _.isObject(models)
      @models = _.extend(models,@models)
    @

  appendCollections: (collections) ->
    if _.isObject(collections)
      @collections = _.extend(collections,@collections)

  remove: ->
    @onRemove()
    for key,item of @subCtrls
      item.remove()
      @subCtrls[key] = undefined
    @stopListening()
    if @el then m.mount($(@el)[0],null)

  onRemove: ->

  ###*
  @method addToGlobalObject
  @param {String} name Object path name
  @param {Any} obj Object to set
  ###
  addToGlobalNameSpace: (name,obj) ->
    throw("target path is already existing") if _private.info.globalSpace[name]?
    throw("object to set is not passed") unless obj?
    _private.info.globalSpace[name] = obj

  removeFromGlobalNameSpace: (name) ->
    throw("selecting path is not existing") unless _private.info.globalSpace[name]?
    delete _private.info.globalSpace[name]


  ###*
  @method setRedrawEvent
  @param {Backbone model or Collection Object} MC observed model/collection
  @param {String} state event name to redraw. "add","remove","change" etc...
  more detail about events refer to http://backbonejs.org/#Events-catalog
  @param {String} prop  observed properties
  @param {Object} options
    waitTime: {Number} throttle wait time. default: 0
    leading: {Boolean} enable/disable leading-edge call. default: true
    trailing: {Boolean} enable/disable trailing-edge call. default: true
  @description set models event to redraw a screen.
  ###
  setRedrawEvent: (MC,state,prop,opt) ->
    if typeof prop is 'object'
      opt = prop
      prop = undefined
    if not MC instanceof Backbone.NestedModel or
    not MC instanceof Backbone.Collection or
    typeof state isnt "string" or
    (typeof prop isnt "string" and prop isnt undefined)
      throw("invalid parameter")
    if true in [opt?.waitTime?,opt?.leading?,opt?.trailing?]
      @listenTo(MC,"#{state}#{if prop? then ':' else ''}#{prop or ''}",_.throttle(
        m.redraw
        opt?.waitTime or 0
        {
          trailing: if opt?.trailing? then opt.trailing else true
          leading: if opt?.leading? then opt.leading else true
        }
      ))
    else
      @listenTo(MC,"#{state}#{if prop? then ':' else ''}#{prop or ''}",m.redraw)


  ###*
  define private method
  @property _private
  @type {Object}
  @readonly
  ###
  _private =
    ###*
    @property _private.info
    ###
    info:
      globalSpace: MB.global
      baseModel: MB.Model.BaseModel
      baseCollection: MB.Model.BaseCollection

    ###*
    @method _private.getGlobalMC
    @param MC {Model or Collection}
    @return {Model or Collection instance}
    @description search and return Global Model/Collection instance
    ###
    getGlobalMC: (MC) ->
      return _.find(_.values(_private.info.globalSpace), (item) ->
        return item instanceof MC
      )

    ###*
    @method _private.setGlobalMC
    @return {controller itself}
    @description set Global Model/Collection instance to @models / @collections
    ###
    setGlobalMC: ->
      models = {}
      collections = {}
      for key,model of @globalMC
        gmc = _private.getGlobalMC.call(@,model)
        if gmc instanceof _private.info.baseModel
          models[key] = gmc
        else
          collections[key] = gmc
      @appendModels(models)
      @appendCollections(collections)

    ###*
    @method _private.setSubControllers
    @return {null}
    @description initialize subControllers.call their component via template.
    You may call ctrl.subCtrls.subControllerName.render() or
    ctrl.subCtrls.subControllerName.component to get their component
    ###
    setSubControllers: ->
      @subCtrls ?= {}
      if @subControllers?
        for key,item of @subControllers
          @subCtrls[item.name] = new item.controller(if item.options? then item.options)
