using Brobdingnag

relerr( x, y ) = abs(convert( Float64, x )/y - 1)
abserr( x, y ) = abs(convert( Float64, x ) - y)

for (x,y, err) in [
    [1e10, -1e9, relerr],
    [1e10, -1e-11, relerr],
    [1.0, 2.0, relerr],
    [0.0, 2.0, relerr],
    [0.0, 0.0, abserr]
]
    bx = Brob(x)
    by = Brob(y)
    @assert( err( bx + by, x + y ) < 1e-12 )
    @assert( err( by + bx, y + x ) < 1e-12 )
end

@assert( relerr( Brob(1.0) + 1, 2 ) < 1e-12 )

for (x,y) in [[1.0,2.0], [-1.0,1.0], [-1.0,-2.0]]
    bx = Brob(x)
    by = Brob(y)

    @assert( (bx < by) == (x < y) )
    @assert( (by < bx) == (y < x) )
end


M2 = ones(Brob,2,2)

maxabserr( x, y ) = maximum(abserr.(convert( Vector{Float64}, vec(x) ), vec(y)))

@assert( maxabserr( Base.sum(M2, dims=1), vec(sum(convert(Matrix{Float64}, M2), dims=1)) ) < 1e-12 )

for (x,y) in [
    [1,1],
    [1,2],
]
    for sign1 in [-1,1]
        for sign2 in [-1, 1]
            for swap in [false,true]
                x = abs(x)*sign1
                y = abs(y)*sign2
                (x,y) = swap ? (x,y) : (y,x)
                
                bx = Brob(x)
                by = Brob(y)
                @assert( ( bx < by ) == ( x < y ) )
                @assert( ( bx <= by ) == ( x <= y ) )
            end
        end
    end
end

    
