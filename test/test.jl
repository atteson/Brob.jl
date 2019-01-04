using Brobdingnag

x = Brob(1e10)
y = Brob(-1e9)
convert( Float64, x + y )
y = Brob(-1e11)
convert(Float64, x + y )
