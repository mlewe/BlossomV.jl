using BinDeps

@BinDeps.setup

blossom5 = library_dependency("blossom5.so")

provides(Sources, URI("http://pub.ist.ac.at/~vnk/software/blossom5-v2.04.src.tar.gz"), blossom5)

prefix = usrdir(blossom5)
blossom5srcdir = joinpath(srcdir(blossom5), "blossom5-v2.04.src")

provides(BuildProcess,
    (@build_steps begin
        GetSources(blossom5)
        @build_steps begin
            ChangeDirectory(blossom5srcdir)
            FileRule(joinpath(libdir(blossom5), "blossom5.so"),
                @build_steps begin
                    CreateDirectory(joinpath(prefix, "lib"))
                    `sh -c "patch < ../../sharedlib.patch"`
                    MakeTargets(["all"])
                    `cp blossom5.so $prefix/lib/blossom5.so`
                end)
        end
    end), blossom5)

@BinDeps.install [:blossom5  => :_jl_libblossm5]
