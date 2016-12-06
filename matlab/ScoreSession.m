classdef ScoreSession
    properties (Constant)        
        setdbprefs = 0;
    end        
  methods (Static)
      function out = setgetODBC(data)
         persistent Var;
         if nargin
            Var = data;
         end
         out = Var;
      end
   end
end