@views function gen_model_2d(DEM    ::Array{Float64, 2},
                             pts    ::Array{Float64, 2},
                             space_x::Float64,
                             tol    ::Int64)
    pts_index  = Int64[]
    pts_length = size(pts, 1)
    DEM_length = size(DEM, 1)
    pts_keep   = zeros(Int64, pts_length)
    @inbounds @threads for i in 1:pts_length
        idx = findall(j->DEM[j, 1]-pts[i, 1]≤space_x*tol, 1:DEM_length)
        isempty(idx) ? error("Cannot find DEM data near to No.$(i) particle.") : nothing
        DEM_idx = argmin(abs.(DEM[idx, 1].-pts[i, 1]))
        pts[i, 2]≤DEM[idx[DEM_idx], 2] ? pts_keep[i]=1 : nothing
    end
    @inbounds for i in eachindex(pts_keep)
        pts_keep[i]==1 ? push!(pts_index, i) : nothing
    end
    #@info "Generation finished"
    return pts[pts_index, :]
end

@views function gen_model_3d(DEM    ::Array{Float64, 2},
                             pts    ::Array{Float64, 2},
                             space_x::Float64,
                             tol    ::Int64)
    pts_index  = Int64[]
    pts_length = size(pts, 1)
    DEM_length = size(DEM, 1)
    pts_keep   = zeros(Int64, pts_length)
    @inbounds for i in 1:pts_length
        idx = findall(j->DEM[j, 1]-pts[i, 1]≤space_x*tol, 1:DEM_length)
        isempty(idx) ? error("Cannot find DEM data near to No.$(i) particle.") : nothing
        DEM_idx = argmin(abs.(DEM[idx, 1].-pts[i, 1]))
        pts[i, 2]≤DEM[idx[DEM_idx], 2] ? push!(pts_index, i) : nothing
    end
    #@info "Generation finished"
    return pts[pts_index, :]
end


function meshgrid(vx::AbstractVector{T}, vy::AbstractVector{T}) where {T}
    m, n = length(vy), length(vx)
    vx = reshape(vx, 1, n)
    vy = reshape(vy, m, 1)
    return hcat(vec(repeat(vx, m, 1)), vec(repeat(vy, 1, n)))
end
