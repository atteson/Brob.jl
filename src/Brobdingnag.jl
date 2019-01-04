module Brobdingnag

export Brob

struct Brob
    positive::Bool
    log::Float64
end

Brob( x::Float64 ) = Brob( sign(x) > 0, log(abs(x)) )

Base.convert( Float64, x::Brob) = (x.positive ? 1 : -1 )*exp( x.log )

function Base.:+( x::Brob, y::Brob )
    sx = x.positive
    sy = y.positive
    if sx == sy
        return Brob( sx, x.log + log(1 + exp(y.log - x.log)) )
    else
        if x.log > y.log
            return Brob( sx, x.log + log(1 - exp(y.log - x.log)) )
        else
            return Brob( sy, y.log + log(1 - exp(x.log - y.log)) )
        end
    end
end

Base.:-( x::Brob, y::Brob ) = x + Brob(!y.positive, y.log)

Base.:*( x::Brob, y::Brob ) = Brob( x.positive == y.positive, x.log + y.log )

Base.:/( x::Brob, y::Brob ) = Brob( x.positive == y.positive, x.log - y.log )

function Base.:^( x::Brob, n::Int )
    @assert( x.positive )
    return Brob( true, n*x.log )
end

end # module
