class MB.Controller.MainController extends MB.Controller.BaseController
  template: MB.View.SampleView
  el: "body"
  constructor : (opt) ->
    super
    @appendModels(sample: new MB.Model.BaseModel())
    @models.sample.set(
      date: new Date()
      dateInEpoch: Date.now()
    )
    # @setRedrawEvent(@models.sample,"change",{waitTime: 1000,leading: false}) update every 1sec
    @setRedrawEvent(@models.sample,"change","dateInEpoch")
    clock = setInterval( =>
      @models.sample.set(
        date: new Date()
        dateInEpoch: Date.now()
      )
    ,0)

  sample: (el,isInitialized) ->
    return if isInitialized
    console.log(this,"this is sample config function")

  subControllers: [
    {name: "header",controller: MB.Controller.HeaderMain}
  ]



window.onload = ->
  window.mainController = new MB.Controller.MainController()
  mainController.mount()
