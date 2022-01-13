using GLMakie

fig = Figure(resolution = (1920,1080))
axis = Axis(fig[1,1],xlabel = L"t",ylabel = L"x_t",title = "time plot",xlabelsize = 50,ylabelsize = 50,titlesize = 50)
axis2 = Axis(fig[1,2],xlabel = L"x_t",ylabel = L"x_{t+1}",title = "cobweb plot",xlabelsize = 50,ylabelsize = 50,titlesize = 50)
slider = Slider(fig[2,1:2],range = LinRange(0,2,1000))
slider2 = Slider(fig[3,1:2],range = 2:1000)
slider3 = Slider(fig[4,1:2],range = LinRange(0.0,4.0,1000))

label = Label(fig[2,1:2],"x_0 = 0",tellwidth = false)
label2 = Label(fig[3,1:2],"tmax = 10",tellwidth = false)
label3 = Label(fig[4,1:2],"r = 0",tellwidth = false)

points = Observable([Point2f(0,0),Point2f(0,0)])
some_xs = LinRange(0,2,100)
funk = Observable(some_xs.*exp.(0.01.*(1 .-some_xs)))

points2 = Observable([Point2f(0,0),Point2f(0,0)])
points_dots = Observable(points2[][2:2:end-1])

maxandmin = Observable([points[][end][2],points[][end-1][2]])

show_lims = Observable(false)

scatterlines!(axis,points,markercolor = :red, color = :red, linestyle = :dot)
hlines!(axis,maxandmin,visible = show_lims,color = :black)
lines!(axis2,some_xs,funk)
lines!(axis2,some_xs,some_xs,color = :black)

text_for_plot = Observable("$(minimum(maxandmin[]))")
pos_of_text = Observable(Point2f(slider2.value[]/2,minimum(maxandmin[])-0.01))
text!(axis,text_for_plot,position = pos_of_text,visible = show_lims,align = (:center,:top))

text_for_plot2 = Observable("$(maximum(maxandmin[]))")
pos_of_text2 = Observable(Point2f(slider2.value[]/2,maximum(maxandmin[])+0.01))
text!(axis,text_for_plot2,position = pos_of_text2,visible = show_lims,align = (:center,:bottom))

lines!(axis2,points2,color=:red,linestyle = :dot)
scatter!(axis2,points_dots,color=:red)

lift(slider.value,slider2.value,slider3.value) do x_0,t_max,r
  ts = 0:1000
  xs = zeros(1001)

  xxs = zeros(2*(t_max+1))
  yys = zeros(2*(t_max+1))

  xs[1] = x_0
  xxs[1] = x_0
  xxs[2] = xxs[1]
  
  for i in 2:1001
    xs[i] = xs[i-1]*exp(r*(1-xs[i-1]))
  end
  for i in 3:2:2(t_max+1)
    xxs[i] = xxs[i-1]*exp(r*(1-xxs[i-1]))
    yys[i-1] = xxs[i]
    yys[i] = yys[i-1]
    xxs[i+1] = xxs[i]
  end
  yys[end] = yys[end-1]
  points[] = Point2f.(ts[1:t_max+1],xs[1:t_max+1])
  points2[] = Point2f.(xxs[1:end-2],yys[1:end-2])
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

  if abs(xs[end]-xs[end-1])>0.0001&& 1.8<r<2.525
    show_lims[] = true
    maxandmin[] = [xs[end],xs[end-1]]
  else
    show_lims[] = false
  end
  points_dots[] = Point2f.(xxs,yys)[2:2:end-2]

  axis.yticks = ([0.0,0.2,0.4,0.6,0.8,1.0,1.2,1.4,1.6,1.8,2.0],["0","0.2","0.4","0.6","0.8","1","1.2","1.4","1.6","1.8","2"])
  axis2.xticks = ([0.0,0.2,0.4,0.6,0.8,1.0,1.2,1.4,1.6,1.8,2.0],["0","0.2","0.4","0.6","0.8","1","1.2","1.4","1.6","1.8","2"])
  axis2.yticks = ([0.0,0.2,0.4,0.6,0.8,1.0,1.2,1.4,1.6,1.8,2.0],["0","0.2","0.4","0.6","0.8","1","1.2","1.4","1.6","1.8","2"])

  text_for_plot[] = "$(minimum(maxandmin[]))"
  pos_of_text[] = Point2f(t_max/2,minimum(maxandmin[])-0.01)

  text_for_plot2[] = "$(maximum(maxandmin[]))"
  pos_of_text2[] = Point2f(slider2.value[]/2,maximum(maxandmin[])+0.01)
end

display(fig)




#=
sleep(40)

set_close_to!(slider3, LinRange(0.0,4,1000)[3])

for i in LinRange(0,2,1000)[1:101]
  set_close_to!(slider, i)
  sleep(0.01)
end

for i in 2:4:1002
  set_close_to!(slider2, i)
  sleep(0.01)
end

for i in LinRange(0.0,4,1000)[3:50]
  set_close_to!(slider3, i)
  sleep(0.05)
end

for i in LinRange(0.0,4,1000)[51:500]
  set_close_to!(slider3, i)
  sleep(0.01)
end

for i in LinRange(0.0,4,1000)[501:600]
  set_close_to!(slider3, i)
  sleep(0.05)
end

for i in LinRange(0.0,4,1000)[601:end]
  set_close_to!(slider3, i)
  sleep(0.01)
end
=#


