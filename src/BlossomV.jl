module BlossomV

if isfile(joinpath(Pkg.dir("BlossomV"),"deps","deps.jl"))
    include("../deps/deps.jl")
else
    error("BlossomV not properly installed. Please run Pkg.build(\"BlossomV\")")
end

export
    PerfectMatchingCtx,
    Matching, solve, add_edge, get_match, get_all_matches

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



dense_num_edges(node_num) =  node_num*(node_num-1)÷2

Matching(node_num::Integer) = Matching(node_num, dense_num_edges(node_num))      
Matching(node_num::Integer, edge_num_max::Integer) = Matching(Int32(node_num), Int32(edge_num_max))
function Matching(node_num::Int32, edge_num_max::Int32)
    assert(node_num % 2 == 0)
    ptr = ccall((:matching_construct, _jl_blossom5), Ptr{Void}, (Int32, Int32), node_num, edge_num_max)
    PerfectMatchingCtx(ptr)
end



function add_edge(matching::PerfectMatchingCtx, first_node::Integer, second_node::Integer, cost::Integer)
	add_edge(matching, Int32(first_node), Int32(second_node), Int32(cost))
end

function add_edge(matching::PerfectMatchingCtx, first_node::Int32, second_node::Int32, cost::Int32)
    first_node != second_node || error("Can not have an edge between $(first_node) and itself")
    first_node >= 0  || error("first_node less than zero (value: $(first_node)). Indexes are zero-based")
    second_node >= 0  || error("second_node less than zero (value: $(second_node)). Indexes are zero-based")
    cost >= 0  || error("Cost must be positive. edge between $(first_node) and $(second_node) is $cost")

	ccall((:matching_add_edge, _jl_blossom5), Int32, (Ptr{Void}, Int32, Int32, Int32), matching.ptr, first_node, second_node, cost)
end

function solve(matching::PerfectMatchingCtx)
    ccall((:matching_solve, _jl_blossom5), Void, (Ptr{Void},), matching.ptr)
    nothing
end



get_match(matching::PerfectMatchingCtx, node::Integer) = get_match(matching, Int32(node))
function get_match(matching::PerfectMatchingCtx, node::Int32)
    ccall((:matching_get_match, _jl_blossom5), Int32, (Ptr{Void}, Int32), matching.ptr, node)
end

function get_all_matches(m::PerfectMatchingCtx, n_nodes::Integer) 
    ret = Matrix{Int32}(2, n_nodes÷2)
    assigned = falses(n_nodes)
    kk = 1
    for ii in 0:n_nodes-1
        assigned[ii+1] && continue
        jj = get_match(m, ii)
        @assert(!assigned[jj+1])
        assigned[ii+1] = true
        assigned[jj+1] = true
        
        ret[1,kk] = ii
        ret[2,kk] = jj
        kk+=1
    end
    @assert(kk-1 == n_nodes÷2)
    return ret
end
end # module
