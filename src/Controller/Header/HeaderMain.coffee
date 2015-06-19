class MB.Controller.HeaderMain extends MB.Controller.BaseController
  template: (ctrl) ->
    m(".header",ctrl.models.sample.get("test"))

  constructor : (opt) ->
    super
    @appendModels(sample: new MB.Model.BaseModel(test: "this is test header"))
