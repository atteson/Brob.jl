module Brobdingnag

export Brob

struct Brob <: Real
    positive::Bool
    log::Float64
end

Brob( x::T ) where {T <: Real} = Brob( sign(x) > 0, log(abs(x)) )

Base.convert( ::Type{Brob}, x::Float64) = Brob( x )

Base.convert( ::Type{Float64}, x::Brob) = (x.positive ? 1 : -1 )*exp( x.log )

function Base.:+( x::Brob, y::Brob )
    sx = x.positive
    sy = y.positive
    if x.log > y.log
        return Brob( sx, x.log + log(1 - exp(y.log - x.log)) )
    else
        return Brob( sy, y.log + log(1 - exp(x.log - y.log)) )
    end
end

Base.:-( x::Brob, y::Brob ) = x + Brob(!y.positive, y.log)

Base.:*( x::Brob, y::Brob ) = Brob( x.positive == y.positive, x.log + y.log )

Base.:/( x::Brob, y::Brob ) = Brob( x.positive == y.positive, x.log - y.log )

function Base.:^( x::Brob, n::Int )
    @assert( x.positive )
    return Brob( true, n*x.log )
end

Base.length(::Brob) = 1

Base.iterate( x::Brob ) = (x,nothing)
Base.iterate( x::Brob, ::Nothing ) = nothing

Base.zero( ::Union{Brob,Type{Brob}} ) = Brob( true, -Inf )

Base.ones( ::Type{Brob}, n::Int ) = fill( Brob(true, 0.0), n )

Base.:<( x::Brob, y::Brob ) = ( x.positive < y.positive ) || xor( !x.positive, ( x.log < y.log ) )

Base.promote_rule( ::Type{Brob}, ::Type{Float64} ) = Brob

end # module
