module Counter

  private

    def get_counter
      @counter = session[:counter]
    rescue
      session[:counter] = 0
      @counter = session[:counter]
    end

    def reset_counter
      session[:counter] = 0
    end

    def increment_counter
      session[:counter] = session[:counter] + 1
    rescue
      session[:counter] = 0
      @counter = session[:counter] + 1
    end
end
