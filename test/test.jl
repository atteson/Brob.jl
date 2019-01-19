using Brobdingnag

relerr( x, y ) = abs(convert( Float64, x )/y - 1)

x = 1e10
y = -1e9
bx = Brob(x)
by = Brob(y)
@assert( relerr( bx + by, x + y ) < 1e-12 )

z = -1e-11
bz = Brob(z)
@assert( relerr( bx + bz, x + z ) < 1e-12 )

@assert( relerr(zero(Brob) + Brob(2.0), 2.0) < 1e-12 )
@assert( relerr(Brob(2.0) + zero(Brob), 2.0) < 1e-12 )

for (x,y) in [[1.0,2.0], [-1.0,1.0], [-1.0,-2.0]]
    bx = Brob(x)
    by = Brob(y)

    @assert( (bx < by) == (x < y) )
    @assert( (by < bx) == (y < x) )
end


M2 = ones(Brob,2,2)
Base.sum(M2, dims=1)
@which Base.sum(M2, dims=1)

@which mapreduce(identity, Base.add_sum, M2, dims=1 )
@which Base._mapreduce_dim(identity, Base.add_sum, NamedTuple(), M2, 1 )

Base.mapreducedim!(identity, Base.add_sum, Base.reducedim_init(identity, Base.add_sum, M2, 1), M2 )
Base.reducedim_init(identity, Base.add_sum, M2, 1)
@which Base.reducedim_init(identity, Base.add_sum, M2, 1)
Base._reducedim_init(identity, Base.add_sum, M2, 1)
