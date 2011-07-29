

require "o2sys.class"

module("o2sys")



local object = class()

object.id = "number"
object.pos = class.vector

function object:clone()

end

object.attributes = {

    garbage = "any",
    id = "number",
    pos = class.vector

}

function object.methods:clone()



end

class.register(object, "object")

