using BinDeps

@BinDeps.setup

blossom5 = library_dependency("blossom5")

provides(Sources, URI("http://pub.ist.ac.at/~vnk/software/blossom5-v2.04.src.tar.gz"), blossom5, SHA="22ec3d6ac23fe8adcce23393d08473af46bf9427105540a7e36f6807c0b50c0c")

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
                    `sh -c "cp ../../interface/* ./"`
                    MakeTargets(["all"])
                    `cp blossom5.so $prefix/lib/blossom5.so`
                end)
        end
    end), blossom5)

@BinDeps.install [:blossom5  => :_jl_blossom5]
