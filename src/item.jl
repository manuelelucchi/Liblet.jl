include("production.jl")

struct Item <: AbstractProduction
    left::Union{Tuple{String},Array{String},String}
    right::Union{Tuple{String},Array{String},String}
    pos::Int
    Item(left::Union{Tuple{String},Array{String},String}, right::Union{Tuple{String},Array{String},String}, pos = 0) = new(left, right, pos)
end

afterdotsymbol(item::Item)::Char = ifelse(item.pos < length(item.right), item.right[item.pos], nothing)

advance(item::Item, x::String)::Item = ifelse(item.pos < length(item.right), Item(item.left, item.right, item.pos+1), nothing)