

class FoisController < ApplicationController
    
    
    def index 
        @fois = Foi.all
    end
    
    def import
        
    end
    
end