require 'ws2812'

module Run
  def Run.every_sec(seconds) #main loop
    last_tick = Time.now
    loop do
      sleep 0.1
      if Time.now - last_tick >= seconds
         last_tick += seconds
         yield
       end 
  end
end

module Ws
  @ws = Ws2812::Basic.new(64, 18)
  @ws.brightness = 100
  @ws.open

  def splash_map(index)
    a = Array.new(4,0)
    a.each_with_index do |n,i|
      if i <= index
        a[i] = 1
      end
    end

    sum_array = a.reverse + a
    full_map = Array.new(8, Array.new(8,0))
    for i in 0..index
      full_map[3-i] = sum_array
      full_map[4+i] = sum_array
    end
    return full_map.flatten
  end 

  def Ws.splash
    unicorn_map = [7 ,6 ,5 ,4 ,3 ,2 ,1 ,0 ,
                   8 ,9 ,10,11,12,13,14,15,
                   23,22,21,20,19,18,17,16,
                   24,25,26,27,28,29,30,31,
                   39,38,37,36,35,34,33,32,
                   40,41,42,43,44,45,46,47,
                   55,54,53,52,51,50,49,48,
                   56,57,58,59,60,61,62,63]
    for m in 0..2
      case m
        when 0
          r = 0
          g = 0
          b = 100
        when 1
          r = 100
          g = 0
          b = 0
        when 2
          r = 100
          g = 100
          b = 100
      end

      for i in 0..3
         unicorn_map.each do |n|
          @ws[n] = Ws2812::Color.new(r,g,b) if splash_map(i)[n] == 1
           end
         @ws.show
         sleep 0.1
        end   
      end
    @ws[0..63] = Ws2812::Color.new(0,0,0)
  end

  def led_on(bin_array, real_array,r,g,b)
    if bin_array[0..3] == [0,1,1,1]
      bin_array[0..3] = [0,0,0,0]
    end
    real_array.each_with_index do |val,i|
      if bin_array[i] == 1
        @ws[val] = Ws2812::Color.new(r,g,b)
      else
        @ws[val] = Ws2812::Color.new(0,0,0)
      end
      @ws.show
    end
  end

  def Ws.show(bin_array ,select)
    a1 = [7,6,8,9,5,4,10,11]
    a2 = [3,2,12,13,1,0,14,15]
    b1 = [23,22,24,25,21,20,26,27]
    b2 = [19,18,28,29.17,16,30,31]
    c1 = [39,38,40,41,37,36,42,43]
    c2 = [35,34,44,45,33,32,46,47]
    d1 = [55,54,56,57,53,52,58,59]
    d2 = [51,50,60,61,49,48,62,63]
    e = [26,27,37,36,28,29,35,34]

    case select
      when 0
        led_on(bin_array,a1,0,0,100)
      when 1
        led_on(bin_array,a2,0,100,0)
      when 2
        led_on(bin_array,e,100,0,0)
      when 3
        led_on(bin_array,d1,100,0,100)
      when 4
        led_on(bin_array,d2,100,100,0)
      else
        @ws[0..63] = Ws2812::Color.new(0,0,0)
        @ws.show
    end
  end
end

module Time_now
  def case_time(number)
    s0 = [0,1,1,1]
    s1 = [1,0,0,0]
    s2 = [1,0,1,0]
    s3 = [1,1,0,0]
    s4 = [1,1,0,1]
    s5 = [1,0,0,1]
    s6 = [1,1,1,0]
    s7 = [1,1,1,1]
    s8 = [1,0,1,1]
    s9 = [0,1,1,0]

    result = case number
      when 0
        s0
      when 1
        s1
      when 2
        s2
      when 3
        s3
      when 4
        s4
      when 5
        s5
      when 6
        s6
      when 7
        s7
      when 8
        s8
      when 9
        s9
    end
    return result
  end
end

  def Time_now.parse
    time_now = Time.now
    h = case_time(time_now.strftime("%H")[0].to_i) + case_time(time_now.strftime("%H")[1].to_i)
    m = case_time(time_now.strftime("%M")[0].to_i) + case_time(time_now.strftime("%M")[1].to_i)
    s = case_time(time_now.strftime("%S")[0].to_i) + case_time(time_now.strftime("%S")[1].to_i)
    dd = case_time(time_now.strftime("%d")[0].to_i) + case_time(time_now.strftime("%d")[1].to_i)
    dm = case_time(time_now.strftime("%m")[0].to_i) + case_time(time_now.strftime("%m")[1].to_i)
    return h,m,s,dd,dm
  end
end
