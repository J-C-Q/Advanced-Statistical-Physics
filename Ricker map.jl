using GLMakie

fig = Figure()
axis = Axis(fig[1,1],xlabel = L"t",ylabel = L"x_t",title = "time plot",xlabelsize = 50,ylabelsize = 50,titlesize = 50)
axis2 = Axis(fig[1,2],xlabel = L"x_t",ylabel = L"x_{t+1}",title = "cobweb plot",xlabelsize = 50,ylabelsize = 50,titlesize = 50)
slider = Slider(fig[2,1:2],range = LinRange(0,2,1000))
slider2 = Slider(fig[3,1:2],range = 2:1000)
slider3 = Slider(fig[4,1:2],range = LinRange(0.0,4,1000))

label = Label(fig[2,1:2],"x_0 = 0",tellwidth = false)
label2 = Label(fig[3,1:2],"tmax = 10",tellwidth = false)
label3 = Label(fig[4,1:2],"r = 0",tellwidth = false)

points = Observable([Point2f(0,-1)])
some_xs = LinRange(0,2,100)
funk = Observable(some_xs.*exp.(0.01.*(1 .-some_xs)))

points2 = Observable([Point2f(0,0),Point2f(0,0)])

scatterlines!(axis,points,markercolor = :red, color = :red, linestyle = :dot)

lines!(axis2,some_xs,funk)
lines!(axis2,some_xs,some_xs,color = :black)

lines!(axis2,points2,color=:red,linestyle = :dot)
scatter!(axis2,points2,color=:red)

lift(slider.value,slider2.value,slider3.value) do x_0,t_max,r
  ts = 0:t_max
  xs = zeros(t_max+1)

  xxs = zeros(2*(t_max+1))
  yys = zeros(2*(t_max+1))

  xs[1] = x_0
  xxs[1] = x_0
  xxs[2] = xxs[1]
  
  for i in 2:t_max+1
    xs[i] = xs[i-1]*exp(r*(1-xs[i-1]))
  end
  for i in 3:2:2(t_max+1)
    xxs[i] = xxs[i-1]*exp(r*(1-xxs[i-1]))
    yys[i-1] = xxs[i]
    yys[i] = yys[i-1]
    xxs[i+1] = xxs[i]
  end
  yys[end] = yys[end-1]
  points[] = Point2f.(ts,xs)
  points2[] = Point2f.(xxs,yys)
  if t_max != 0
    xlims!(axis,0,t_max)
    ylims!(axis,-0.1,2)
  else
    autolimits!(axis)
  end
  limits!(axis2,0,2,0,2)
  label.text = "x_0 = $(round(x_0,digits = 3))"
  label2.text = "tmax = $t_max"
  label3.text = "r = $(round(r,digits = 3))"

  funk[] = some_xs.*exp.(r.*(1 .-some_xs))
end

display(fig)
