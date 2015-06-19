MB.View.SampleView = (ctrl) ->
  m(".container",{config: ctrl.sample},[
    ctrl.subCtrls.header.comp
    m(".main-view",[
        m("p","currentTime: #{ctrl.models.sample.get('date')}")
        m("p","in Epoch time: #{ctrl.models.sample.get('dateInEpoch')}")
    ])
    m(".left-panel")
    m(".footer")
  ])
