using CairoMakie
using BenchmarkTools
include(joinpath(@__DIR__, "src/PGeneration.jl"))

datasize = 10000
space_x  = 0.5
DEM = hcat(collect(0:datasize-1), rand(20:0.1:30, datasize))
pts = meshgrid(space_x:space_x:datasize, space_x:space_x:40)
PTS = gen_model_2d(DEM, pts, space_x, 5)

let
    figpath = joinpath(@__DIR__, "result.png")
    fig = Figure()
    axis_1 = Axis(fig[1, 1], aspect=DataAspect())
    axis_2 = Axis(fig[2, 1], aspect=DataAspect())
    axis_3 = Axis(fig[3, 1], aspect=DataAspect())
    limits!(axis_1, -10, 110, -5, 40)
    limits!(axis_2, -10, 110, -5, 40)
    limits!(axis_3, -10, 110, -5, 40)
    pts_plot_1 = scatter!(axis_1, pts[:, 1], pts[:, 2], color=:blue, markersize=1, strokewidth=0)
    DEM_plot_1 = scatterlines!(axis_1, DEM[:, 1], DEM[:, 2], color=:red,  markersize=6, strokewidth=0)
    pts_plot_2 = scatter!(axis_2, PTS[:, 1], PTS[:, 2], color=:blue, markersize=1, strokewidth=0)
    DEM_plot_2 = scatterlines!(axis_2, DEM[:, 1], DEM[:, 2], color=:red,  markersize=6, strokewidth=0)
    pts_plot_3 = scatter!(axis_3, PTS[:, 1], PTS[:, 2], color=:blue, markersize=1, strokewidth=0)
    save(figpath, fig)
    @info "Figure saved in $(figpath)"
end

@benchmark gen_model_2d($DEM, $pts, $space_x, $5)
@benchmark gen_model_3d($DEM, $pts, $space_x, $5)
