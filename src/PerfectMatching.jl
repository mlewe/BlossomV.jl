module PerfectMatching

if isfile(joinpath(Pkg.dir("PerfectMatching"),"deps","deps.jl"))
    include("../deps/deps.jl")
else
    error("PerfectMatching not properly installed. Please run Pkg.build(\"PerfectMatching\")")
end

export
    PerfectMatchingCtx,
    Matching, solve, add_edge, get_match

type PerfectMatchingCtx
    ptr::Ptr{Void}

    function PerfectMatchingCtx(ptr::Ptr{Void})
        self = new(ptr)
        finalizer(self, destroy)
        self
    end
end

function destroy(matching::PerfectMatchingCtx)
    if matching.ptr == C_NULL
        return
    end
    ccall((:matching_destruct, _jl_blossom5), Void, (Ptr{Void},), matching.ptr)
    matching.ptr = C_NULL
    nothing
end

function Matching(node_num::Int32, edge_num_max::Int32)
    assert(node_num % 2 == 0)
    ptr = ccall((:matching_construct, _jl_blossom5), Ptr{Void}, (Int32, Int32), node_num, edge_num_max)
    PerfectMatchingCtx(ptr)
end

function add_edge(matching::PerfectMatchingCtx, first_node::Int32, second_node::Int32, cost::Int32)
    ccall((:matching_add_edge, _jl_blossom5), Int32, (Ptr{Void}, Int32, Int32, Int32), matching.ptr, first_node, second_node, cost)
end

function solve(matching::PerfectMatchingCtx)
    ccall((:matching_solve, _jl_blossom5), Void, (Ptr{Void},), matching.ptr)
    nothing
end

function get_match(matching::PerfectMatchingCtx, node::Int32)
    ccall((:matching_get_match, _jl_blossom5), Int32, (Ptr{Void}, Int32), matching.ptr, node)
end

end # module
