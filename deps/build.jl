version = v"0.4.2"

using BinDeps, Libdl

@BinDeps.setup

function validate(name, handle)
    v_ptr_major = Libdl.dlsym(handle, :blossom5_julia_version_major)
    v_ptr_minor = Libdl.dlsym(handle, :blossom5_julia_version_minor)
    if v_ptr_major == C_NULL || v_ptr_minor == C_NULL
        return false
    end
    major = ccall(v_ptr_major, Cint, ())
    minor = ccall(v_ptr_minor, Cint, ())
    bin_version = VersionNumber(major, minor+1, 0, ("",))
    return version < bin_version
end

blossom5int32 = library_dependency("blossom5int32", validate=validate)
blossom5float64 = library_dependency("blossom5float64", validate=validate)

provides(Sources, URI("https://pub.ist.ac.at/~vnk/software/blossom5-v2.05.src.tar.gz"), blossom5int32, SHA="6bb2fabaa4a5eb957385c81f2cdad139454afebbdb19d6deea61ced5f7c06489")

prefix = usrdir(blossom5int32)
blossom5srcdir = joinpath(srcdir(blossom5int32), "blossom5-v2.05.src")
blossom5int32libfile = joinpath(libdir(blossom5int32), "blossom5int32.so")
blossom5float64libfile = joinpath(libdir(blossom5float64), "blossom5float64.so")

if Sys.isapple()
    blossom5int32libfile = joinpath(libdir(blossom5int32), "blossom5int32.dylib")
    blossom5float64libfile = joinpath(libdir(blossom5float64), "blossom5float64.dylib")
end

provides(BuildProcess,
    (@build_steps begin
        `rm -rf $blossom5int32libfile`
        `rm -rf $blossom5srcdir`
        GetSources(blossom5int32)
        @build_steps begin
            ChangeDirectory(blossom5srcdir)
            FileRule(blossom5int32libfile,
                @build_steps begin
                    CreateDirectory(joinpath(prefix, "lib"))
                    `sh -c "patch < ../../sharedlib.patch"`
                    `sh -c "cp ../../interface/* ./"`
                    MakeTargets(["all"])
                    `cp -f blossom5.so $blossom5int32libfile`
                end)
        end
    end), blossom5int32)


provides(BuildProcess,
    (@build_steps begin
        `rm -rf $blossom5float64libfile`
        `rm -rf $blossom5srcdir`
        GetSources(blossom5int32)
        @build_steps begin
            ChangeDirectory(blossom5srcdir)
            FileRule(blossom5float64libfile,
                @build_steps begin
                    CreateDirectory(joinpath(prefix, "lib"))
                    `sh -c "patch < ../../sharedlib.patch"`
                    `sh -c "cp ../../interface/* ./"`
                    `sh -c "patch < ../../float64.patch"`
                    MakeTargets(["all"])
                    `cp -f blossom5.so $blossom5float64libfile`
                end)
        end
    end), blossom5float64)

@BinDeps.install Dict([(:blossom5int32, :_jl_blossom5int32),
                       (:blossom5float64, :_jl_blossom5float64)])
