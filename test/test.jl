using Brobdingnag

x = Brob(1e10)
y = Brob(-1e9)
convert( Float64, x + y )
y = Brob(-1e11)
convert(Float64, x + y )

for (x,y) in [[1.0,2.0], [-1.0,1.0], [-1.0,-2.0]]
    bx = Brob(x)
    by = Brob(y)

    @assert( (bx < by) == (x < y) )
    @assert( (by < bx) == (y < x) )
end
