class MB.Model.BaseModel extends Backbone.NestedModel
  constructor: (data) ->
    super(data)
  unset: (path,opt) ->
    if @has(path) then super else return
