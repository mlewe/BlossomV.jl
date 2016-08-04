using BlossomV
using Base.Test

@testset "Trivial Case" begin
    differences = [
        0 1 500
    ]

    m = Matching(2)
    for row_ii in 1:size(differences,1)
        n1,n2, c = differences[row_ii,:]
        add_edge(m,n1,n2,c)
    end
    solve(m)
    @test get_match(m,0) == 1
    @test get_match(m,1) == 0
end

@testset "Base Case -- greedy will work" begin
    differences = [
        0 1 500
        0 2 600
        1 2 700
        2 3 100
        1 3 1000
    ]

    m = Matching(4)
    for row_ii in 1:size(differences,1)
        n1,n2, c = differences[row_ii,:]
        add_edge(m,n1,n2,c)
    end
    solve(m)
    @test get_match(m,0) == 1
    @test get_match(m,1) == 0
    @test get_match(m,2) == 3
    @test get_match(m,3) == 2
end

@testset "Intermidiate Case -- no greedy solution" begin
    differences = [
        0 1 500
        0 2 400
        1 2 300
        2 3 1000
        1 3 1000
    ]

    m = Matching(4)
    for row_ii in 1:size(differences,1)
        n1,n2, c = differences[row_ii,:]
        add_edge(m,n1,n2,c)
    end
    solve(m)
    @test get_match(m,0) == 2
    @test get_match(m,1) == 3
    @test get_match(m,2) == 0
    @test get_match(m,3) == 1
end
