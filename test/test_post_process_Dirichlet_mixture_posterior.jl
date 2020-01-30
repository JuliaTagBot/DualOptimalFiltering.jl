@testset "WF marginal CI functions" begin

    function simulate_WF3_data()
        K = 4
        α = ones(K)
        sα = sum(α)
        Pop_size_WF3 = 15
        Ntimes_WF3 = 3
        time_step_WF3 = 0.1
        time_grid_WF3 = [k*time_step_WF3 for k in 0:(Ntimes_WF3-1)]
        Random.seed!(4)
        wfchain_WF3 = Wright_Fisher_K_dim_exact_trajectory(rand(Dirichlet(K,0.3)), time_grid_WF3[1:(end-1)], α)
        wfobs_WF3 = [rand(Multinomial(Pop_size_WF3, wfchain_WF3[:,k])) for k in 1:size(wfchain_WF3,2)] |> l -> hcat(l...)
        data_WF3 = Dict(zip(time_grid_WF3 , [wfobs_WF3[:,t] for t in 1:size(wfobs_WF3,2)]))
        return data_WF3, wfchain_WF3, α
    end
    data, wfchain_WF3, α = simulate_WF3_data()
    Λ_of_t, wms_of_t = DualOptimalFiltering.filter_WF_adaptive_precomputation_keep_fixed_number(α, data |> DualOptimalFiltering.prepare_WF_dat_1D_2D |> last, 30)

    @test_nowarn DualOptimalFiltering.compute_marginal_CI(α, Λ_of_t, wms_of_t; mass = 0.95)

end
