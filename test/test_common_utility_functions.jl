@testset "Test common utility functions" begin
    @test DualOptimalFiltering.normalise(1:4) == (1:4)/10
end
