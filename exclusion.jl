using GLMakie,StatsBase

function exclusion_process_visualization_ring(;L=400,ρ=1/4,tmax = 3000)
  fig = Figure(resolution = (1920,1080)) # make a figure

  # create the axis for the lattice ###################################
  axis = Axis(fig[1:3,1])
  axis.aspect = DataAspect()
  hidedecorations!(axis)
  hidespines!(axis)
  #####################################################################

  axis2 = Axis(fig[4,1],xlabel = L"t",ylabel = L"p_{+-}",xlabelsize = 30,ylabelsize = 30,tellwidth = false) # create the axis for p_+-
  
  ϕ_s = LinRange(0,2π,L+1) # angles for the lattice seperations
  poses = LinRange(0+step(ϕ_s)/2,2π-step(ϕ_s)/2,L) # angles of the lattice locations


  occ_array = zeros(L) # array that tracks the occupations in the lattice
  point_index_array = sample(1:L,Int64(ρ*L),replace = false) # array that tracks the locations of the particles (initialized randomly)

  # occupay locations in lattice #######################################
  for i in 1:Int64(ρ*L)
    occ_array[point_index_array[i]] = 1
  end
  ######################################################################

  p_pm = calc_p_pm(occ_array) # variable that has the current p_+- value
  
  p_pms = Node([Point2f(0,p_pm)]) # data points of p_+- for plotting

  p_pm_text_pos = Node(Point2f(0,0.1)) # the position of the p=... text over the plot
  p_pm_text = Node("p=$p_pm") # text of the p=... over the plot

  J = Node("") # the J text

  colors = Node([:white]) # colors of the plot lines

  points_points = Node([Point2f(cos(poses[point_index_array[i]]),sin(poses[point_index_array[i]])) for i in 1:Int64(ρ*L)]) # positions of the particles in the plot

  # find location in the plot for lattice seperations #################
  ticks_x = Vector{Float64}(undef,2(L+1))
  ticks_y = Vector{Float64}(undef,2(L+1))
  for i in 1:L
    ticks_x[2*i] = 0.995*cos(ϕ_s[i])
    ticks_x[2*i-1] = 1.005*cos(ϕ_s[i])

    ticks_y[2*i] = 0.995*sin(ϕ_s[i])
    ticks_y[2*i-1] = 1.005*sin(ϕ_s[i])
  end
  #####################################################################

  # plot functionen ###################################################
  linesegments!(axis,ticks_x,ticks_y,color = (:darkgray,0.2))
  lines!(axis,[cos(ϕ) for ϕ in LinRange(0,2π,1000)],[sin(ϕ) for ϕ in LinRange(0,2π,1000)],color = (:darkgray,0.2))
  scatter!(axis,points_points,color = :red,markersize = 5)
  lines!(axis2,p_pms,color = colors,linewidth = 3)
  J_text = text!(axis,J,position = (0, 0), align = (:center, :center),visible = false)
  text!(axis2,p_pm_text,position = p_pm_text_pos, align = (:center, :center),offset = (0, 20))
  elem_1 = [LineElement(color = :white,linewidth = 3)]
  elem_2 = [LineElement(color = :darkred,linewidth = 3)]
  axislegend(axis2,[elem_1,elem_2],["thermalization","measurment"],patchsize = (35, 35),rowgap = 10,labelsize = 20,orientation = :horizontal)
  ######################################################################
  display(fig)

  sleep(5)# wait for human comprehension

  sum_J = 0
  for t in 1:tmax 
    occ_array,point_index_array,new_J = timestep(occ_array,point_index_array,Int64(ρ*L))
    if t>tmax/2
      sum_J+=new_J
    end
    points_points[] = [Point2f(cos(poses[point_index_array[i]]),sin(poses[point_index_array[i]])) for i in 1:Int64(ρ*L)]
    p_pm = calc_p_pm(occ_array)
    ps = p_pms[]
    push!(ps, Point2f(t,p_pm))
    p_pms[] = ps
    autolimits!(axis2)
    p_pm_text[] = "p=$p_pm"
    J[] = "J=$(round(ρ*sum_J/(t-tmax/2-1),digits = 3))"
    p_pm_text_pos[] = Point2f(t,p_pm)
    if t>tmax/2
      J_text.visible = true
      colors[] = push!(colors[],:darkred)
    else
      colors[] = push!(colors[],:white)
    end
    sleep(0.016) # wait for human comprehension
  end
end

function timestep(occ_array,point_index_array,N)
  J = 0
  for i in 1:N
    p = rand(1:N)
    n = 1
    i = (point_index_array[p]+n)%length(occ_array)==0 ? length(occ_array) : (point_index_array[p]+n)%length(occ_array)
    while occ_array[i] == 0
      n+=1
      i = (point_index_array[p]+n)%length(occ_array)==0 ? length(occ_array) : (point_index_array[p]+n)%length(occ_array)
    end
    occ_array[point_index_array[p]] = 0
    occ_array[(point_index_array[p]+n-1)%length(occ_array)==0 ? length(occ_array) : (point_index_array[p]+n-1)%length(occ_array)] = 1
    point_index_array[p] = (point_index_array[p]+n-1)%length(occ_array)==0 ? length(occ_array) : (point_index_array[p]+n-1)%length(occ_array)
    J+=n-1
  end
  return occ_array,point_index_array,J/N
end

function calc_p_pm(occ_array)
  p = 0
  for i in 1:length(occ_array)-1
    if occ_array[i] == 1 && occ_array[i+1] == 0
      p+=1
    end
  end
  if occ_array[end] == 1 && occ_array[1] == 0
    p+=1
  end
  return p/length(occ_array)
end


with_theme(exclusion_process_visualization_ring, theme_black())
