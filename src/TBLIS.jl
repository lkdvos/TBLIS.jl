module TBLIS

using Libdl
using LinearAlgebra
using Hwloc_jll
using tblis_jll

import LinearAlgebra: mul!

export TTensor
export mul!
export add!

global tblis = C_NULL
global tci = C_NULL
global hwloc = C_NULL

function __init__()
    if Sys.isapple()
        #global tblis = dlopen(joinpath(dirname(pathof(TBLIS)),"libtblis"))
        global tblis = dlopen(joinpath(@__DIR__,"libtblis"))
    else
        global tci = dlopen(tblis_jll.tci)
        global hwloc = dlopen(Hwloc_jll.libhwloc)
        global tblis = dlopen(tblis_jll.tblis)
    end
end

function set_num_threads(n)
    # Previous number of Threads to be returned
    original = get_num_threads()

    tblis_set_num_threads = dlsym(tblis, :tblis_set_num_threads)
    ccall(tblis_set_num_threads, Cvoid, (Cuint,), n)
    return original
end

function get_num_threads()
    tblis_get_num_threads = dlsym(tblis, :tblis_get_num_threads)
    return ccall(tblis_get_num_threads, Cint, ())
end


include("TTensor.jl")
include("Ops.jl")

end #module
