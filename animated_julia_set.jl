using CairoMakie

function debug(message) if DEBUG_OUTPUT println(message) end end

function Julia_set(c)
    Z = complex.(X, Y)
    C = ones(Float64, length(x), length(y))*c
    B = zeros(size(C));
    for k = 1:it_max
        Z = @. Z^2 + C;
        B = @. B + (abs(Z) < 2);
    end
    
    return B
end

const DEBUG_OUTPUT = true

const x_min, x_max = -1.3, 1.3
const y_min, y_max = -1.3, 1.3
const n = 500
const pix_per_pix = 2

const Z_max = 1e6
const it_max = 50

const c₀ = 0.360284+0.100376im

const frames = 1000

x = range(x_min, x_max, n)
y = range(y_min, y_max, n)

#[X,Y] = meshgrid(x,y)
X = [i for i in x, j in 1:length(y)]
Y = [j for i in 1:length(x), j in y]


debug("Start calc")
t₀ = time_ns()

B = Julia_set(c₀)

tₑ = time_ns()
debug("Eval time: $((tₑ-t₀)/1e9)")


CairoMakie.activate!()

figure = (; resolution=(pix_per_pix*n, pix_per_pix*n), font="CMU Serif")
axis = (; xlabel="x", ylabel="y", aspect=DataAspect())
fig, ax, pltobj = heatmap(B; colorrange=(0, it_max), colormap=:viridis, axis=axis, figure=figure)

record(fig, "Julia!.gif", 1:frames) do i
    pltobj[1] = Julia_set(c₀*exp(i*(1e-2*1im)))
    println("i=$(i)")
    
end

