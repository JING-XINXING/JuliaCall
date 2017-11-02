import RCall.sexp
import Base.get

immutable JuliaObjectID
    i :: Int32
end

function nextid(id :: JuliaObjectID)
    JuliaObjectID(id.i + 1)
end

JuliaObjectID() = JuliaObjectID(0)

type JuliaObject
    id :: JuliaObjectID
    JuliaObject(id :: JuliaObjectID) = new(id)
end

function getPlainID(x :: JuliaObject)
    x.id.i
end

type JuliaObjectContainer
    object_dict :: Dict{JuliaObjectID, Any}
    ind :: JuliaObjectID
end

JuliaObjectContainer() = JuliaObjectContainer(Dict(), JuliaObjectID())

function add!(container :: JuliaObjectContainer, x)
    container.ind = nextid(container.ind)
    container.object_dict[container.ind] = x
    JuliaObject(container.ind)
end

function get(container :: JuliaObjectContainer, id :: JuliaObjectID)
    container.object_dict[id]
end

function get(container :: JuliaObjectContainer, id)
    container.object_dict[JuliaObjectID(id)]
end

## As long as the interface stays the same, the following code should be fine.
## The global JuliaObjectContainer julia_object_stack

julia_object_stack = JuliaObjectContainer()

function new_obj(obj)
    add!(julia_object_stack, obj)
end

JuliaObject(x :: JuliaObject) = x
JuliaObject(x :: RObject) = new_obj(rcopy(x))
JuliaObject(x :: RCall.Sxp) = new_obj(RObject(x))
JuliaObject(x) = new_obj(x)

## Conversion related to JuliaObject

function sexp(x :: JuliaObject)
    reval("JuliaCall:::JuliaObjectFromId")(getPlainID(x))
end

import RCall.rcopy

function rcopy(::Type{JuliaObject}, x::Ptr{S4Sxp})
    try
        get(julia_object_stack, rcopy(x[:id]))
    catch e
        nothing
    end
end

import RCall: RClass, rcopytype

rcopytype(::Type{RClass{:JuliaObject}}, x::Ptr{S4Sxp}) = JuliaObject

## Fallback conversions

sexp(x) = sexp(JuliaObject(x))

## Regarding to issue #12, #13 and #16,
## we should use JuliaObject for general AbstractArray
@suppress begin
    sexp{T}(x :: AbstractArray{T}) = sexp(JuliaObject(x))
end

## AbstractArray{Any} should be converted to R List
sexp(x :: AbstractArray{Any}) = sexp(VecSxp, x)

## Preserve BigFloat precision,
## as the design decision in issue #16
# sexp(x::AbstractArray{BigFloat}) = sexp(JuliaObject(x))
# sexp(x::BigFloat) = sexp(JuliaObject(x))

function setfield1!(object, name, value1)
    value = fieldtype(typeof(object), name)(value1)
    setfield!(object, name, value)
end
