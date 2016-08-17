

class FoisController < ApplicationController
    
    
    def index 
        @fois = Foi.all
    end
    
end