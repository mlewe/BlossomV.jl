version = v"0.2.1"

using BinDeps

@BinDeps.setup

function validate(name, handle)
    v_ptr_major = Libdl.dlsym_e(handle, :blossom5_julia_version_major)
    v_ptr_minor = Libdl.dlsym_e(handle, :blossom5_julia_version_minor)
    if v_ptr_major == C_NULL || v_ptr_minor == C_NULL
        return false
    end
    major = ccall(v_ptr_major, Cint, ())
    minor = ccall(v_ptr_minor, Cint, ())
    bin_version = VersionNumber(major, minor+1, 0, ("",))
    return version < bin_version
end

blossom5int32 = library_dependency("blossom5int32", validate=validate)
blossom5float64 = library_dependency("blossom5float64")

provides(Sources, URI("http://pub.ist.ac.at/~vnk/software/blossom5-v2.05.src.tar.gz"), blossom5int32, SHA="6bb2fabaa4a5eb957385c81f2cdad139454afebbdb19d6deea61ced5f7c06489")

prefix = usrdir(blossom5int32)
blossom5srcdir = joinpath(srcdir(blossom5int32), "blossom5-v2.05.src")

provides(BuildProcess,
    (@build_steps begin
        # `rm -rf $prefix`
        `rm -rf $blossom5srcdir`
        GetSources(blossom5int32)
        @build_steps begin
            ChangeDirectory(blossom5srcdir)
            FileRule(joinpath(libdir(blossom5int32), "blossom5int32.so"),
                @build_steps begin
                    CreateDirectory(joinpath(prefix, "lib"))
                    `sh -c "patch < ../../sharedlib.patch"`
                    `sh -c "cp ../../interface/* ./"`
                    MakeTargets(["all"])
                    `cp -f blossom5.so $prefix/lib/blossom5int32.so`
                end)
        end
    end), blossom5int32)


provides(BuildProcess,
    (@build_steps begin
        # `rm -rf $prefix`
        `rm -rf $blossom5srcdir`
        GetSources(blossom5int32)
        @build_steps begin
            ChangeDirectory(blossom5srcdir)
            FileRule(joinpath(libdir(blossom5int32), "blossom5float64.so"),
                @build_steps begin
                    CreateDirectory(joinpath(prefix, "lib"))
                    `sh -c "patch < ../../sharedlib.patch"`
                    `sh -c "cp ../../interface/* ./"`
                    `sh -c "patch < ../../float64.patch"`
                    MakeTargets(["all"])
                    `cp -f blossom5.so $prefix/lib/blossom5float64.so`
                end)
        end
    end), blossom5float64)

@BinDeps.install Dict([(:blossom5int32, :_jl_blossom5int32),
                       (:blossom5float64, :_jl_blossom5float64)])
