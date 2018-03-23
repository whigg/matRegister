classdef QuadPolynomialTransformModel2D < ParametricTransform
%QUADPOLYNOMIALTRANSFORMMODEL2D  One-line description here, please.
%
%   Class QuadPolynomialTransformModel2D
%   Creates a new 2D quadratic transform model.
%
%   x' = P1 + P3 * x + P5 * y + P7 * x^2 +  P9 * x*y + P11 * y^2
%   y' = P2 + P4 * x + P6 * y + P8 * x^2 + P10 * x*y + P12 * y^2
%
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-03-23,    using Matlab 9.3.0.713579 (R2017b)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function this = QuadPolynomialTransformModel2D(varargin)
    % Constructor for QuadPolynomialTransformModel2D class
        
        % default values
        this.params = [ ...
            0 0 ...   % constant terms for x', y'
            1 0 ...   % x coef
            0 1 ...   % y coef
            0 0 ...   % x^2 coef
            0 0 ...   % x*y coef
            0 0 ...   % y^2 coef
            ];
        
        % initialize if necessary
        if ~isempty(varargin)
            this.params = varargin{1};
        end

    end

end % end constructors


%% Methods
methods
    function pointT = transformPoint(this, point)
        
        x = point(:, 1);
        y = point(:, 2);
        
        % init with translation part
        x2 = ones(size(x)) * this.params(1);
        y2 = ones(size(x)) * this.params(2);
        
        % add linear contributions
        x2 = x2 + x * this.params(3);
        y2 = y2 + x * this.params(4);
        x2 = x2 + y * this.params(5);
        y2 = y2 + y * this.params(6);
        
        % add quadratic contributions
        x2 = x2 + x.^2 * this.params(7);
        y2 = y2 + x.^2 * this.params(8);
        x2 = x2 + x.*y * this.params(9);
        y2 = y2 + x.*y * this.params(10);
        x2 = x2 + y.^2 * this.params(11);
        y2 = y2 + y.^2 * this.params(12);
        
        % concatenate coordinates
        pointT = [x2 y2];
    end
    
    function  getParametricJacobian(this, x, varargin)
        % Compute jacobian matrix, i.e. derivatives for each parameter
    end
    
    function  jacobian = getJacobian(this, point)
        % Computes jacobian matrix, i.e. derivatives wrt to each coordinate
        % jacob(i,j) = d x_i / d x_j
        
        % compute centered coords.
        x = point(:, 1) ;
        y = point(:, 2) ;
        
        p = this.params;
        dxx = p(3)  + 2*x*p(7) + y*p(9);
        dyx = p(4)  + 2*x*p(8) + y*p(10);
        
        dxy = p(5)  + 2*y*p(11) + x*p(9);
        dyy = p(6)  + 2*y*p(12) + x*p(10);
        
        jacobian = [dxx dxy ; dyx dyy];
    end
    
    function transformVector (this, x, varargin)
        % Compute jacobian matrix, i.e. derivatives for each parameter
    end
    
    function dim = getDimension (this) %#ok<MANU>
        % Compute jacobian matrix, i.e. derivatives for each parameter
        dim = 2;
    end
end % end methods

end % end classdef

