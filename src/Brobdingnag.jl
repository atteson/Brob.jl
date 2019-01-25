module Brobdingnag

export Brob

struct Brob <: Real
    positive::Bool
    log::Float64
end

Brob( x::T ) where {T <: Real} = Brob( !(sign(x) < 0), log(abs(x)) )

Base.convert( ::Type{Brob}, x::Float64) = Brob( x )

Base.convert( ::Type{Float64}, x::Brob) = (x.positive ? 1 : -1 )*exp( x.log )
Base.convert( ::Type{Float32}, x::Brob) = Float32(convert(Float64, x))

function Base.:+( x::Brob, y::Brob )
    s = x.positive == y.positive ? 1 : -1
    if x.log > y.log
        return Brob( x.positive, x.log + log(1 + s * exp(y.log - x.log)) )
    elseif x.log != -Inf || y.log != -Inf
        return Brob( y.positive, y.log + log(1 + s * exp(x.log - y.log)) )
    else
        return x
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
Base.:<=( x::Brob, y::Brob ) = ( x.positive < y.positive ) || xor( !x.positive, ( x.log <= y.log ) )

Base.promote_rule( ::Type{Brob}, ::Union{Type{Float64},Type{Int},Type{Float32}} ) = Brob

function Base.sqrt( x::Brob )
    @assert( x.positive, "Trying to take sqrt of $x" )
    return Brob( true, 0.5*x.log )
end

Base.isnan( x::Brob ) = isnan( x.log )

end # module
