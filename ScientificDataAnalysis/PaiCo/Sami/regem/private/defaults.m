function [options info] = defaults(opt)

if (~exist('opt','var'))
    opt = [];
end

info.method.name = 'RegEM';
info.method.reference = ...
    ['[1] T. Schneider, 2001: Analysis of incomplete climate data: '...
    'Estimation of mean values and covariance matrices and imputation of ' ...
    'missing values. Journal of Climate 14:853�871.' ...
     '[2] R. J. A. Little and D. B. Rubin, 1987: Statistical Analysis ' ...
     'with Missing Data. Wiley Series in Probability and Mathematical ' ...
     'Statistics. (For EM algorithm.)'...
     '[3] P. C. Hansen, 1997: Rank-Deficient and Discrete Ill-Posed ' ...
     'Problems: Numerical Aspects of Linear Inversion. SIAM Monographs ' ...
     'on Mathematical Modeling and Computation. (For regularization ' ...
     'techniques, including the selection of regularization parameters.)'];
 
info.method.doi = '';
info.method.authors = 'Schneider';
info.method.description = ...
   ['Missing values are imputed with a regularized expectation '...
	'maximization (EM) algorithm. In an iteration of the EM algorithm, '...
	'given estimates of the mean and of the covariance matrix are '...
	'revised in three steps. First, for each record X(i,:) with '...
	'missing values, the regression parameters of the variables with '...
	'missing values on the variables with available values are '...
	'computed from the estimates of the mean and of the covariance '...
	'matrix. Second, the missing values in a record X(i,:) are filled '...
	'in with their conditional expectation values given the available '...
	'values and the estimates of the mean and of the covariance '...
	'matrix, the conditional expectation values being the product of '...
	'the available values and the estimated regression '...
	'coefficients. Third, the mean and the covariance matrix are '...
	're-estimated, the mean as the sample mean of the completed '...
	'dataset and the covariance matrix as the sum of the sample '...
	'covariance matrix of the completed dataset and an estimate of the '...
	'conditional covariance matrix of the imputation error.'...
    ''...
	'In the regularized EM algorithm, the parameters of the regression '...
	'models are estimated by a regularized regression method. By '...
	'default, the parameters of the regression models are estimated by '...
	'an individual ridge regression for each missing value in a '...
	'record, with one regularization parameter (ridge parameter) per '...
	'missing value.  Optionally, the parameters of the regression '...
	'models can be estimated by a multiple ridge regression for each '...
	'record with missing values, with one regularization parameter per '...
	'record with missing values. The regularization parameters for the '...
	'ridge regressions are selected as the minimizers of the '...
	'generalized cross-validation (GCV) function. As another option, '...
	'the parameters of the regression models can be estimated by '...
	'truncated total least squares. The truncation parameter, a '...
	'discrete regularization parameter, is fixed and must be given as '...
	'an input argument. The regularized EM algorithm with truncated '...
	'total least squares is faster than the regularized EM algorithm '...
	'with with ridge regression, requiring only one eigendecomposition '...
	'per iteration instead of one eigendecomposition per record and '...
	'iteration. But an adaptive choice of truncation parameter has not '...
	'been implemented for truncated total least squares. So the '...
	'truncated total least squares regressions can be used to compute '...
	'initial values for EM iterations with ridge regressions, in which '...
	'the regularization parameter is chosen adaptively. '...
    ''...
	'As default initial condition for the imputation algorithm, the '...
	'mean of the data is computed from the available values, mean '...
	'values are filled in for missing values, and a covariance matrix '...
	'is estimated as the sample covariance matrix of the completed '...
	'dataset with mean values substituted for missing '...
	'values. Optionally, initial estimates for the missing values and '...
	'for the covariance matrix estimate can be given as input '...
	'arguments.'];

options.weight = setDefault(opt, {'weight'}, []);
info.options.weight = '';


options.regress = setDefault(opt, {'regress'}, 'ttls'); %{'iridge', 'mridge', 'ttls'};
info.options.regress = ...
    ['Regression procedure to be used: '...
    '''mridge'': multiple ridge regression, ''iridge'': individual ridge ' ...
    'regressions, ''ttls'': truncated total least squares regression'];

options.stagTolerance = setDefault(opt, {'stagTolerance'}, 5e-3);
info.options.stagTolerance = ...
    ['Stagnation tolerance: quit when consecutive iterates of the missing '...
     'values are so close that norm( Xmis(it)-Xmis(it-1) ) '...
     '<= stagtol * norm( Xmis(it-1) )'];

options.maxIterations = setDefault(opt, {'maxIterations'}, 30);
info.options.maxIterations = 'Maximum number of EM iterations.';

options.inflation = setDefault(opt, {'inflation'}, 1);
info.options.inflation = ['Inflation factor for the residual covariance '...
    'matrix. Because of the regularization, the residual covariance '...
    'matrix underestimates the conditional covariance matrix of the imputation '...
    'error. The inflation factor is to correct this underestimation. The update of the '...
    'covariance matrix estimate is computed with residual covariance matrices '...
    'inflated by the factor OPTIONS.inflation, and the estimates of the imputation error '...
    'are inflated by the same factor. '];

options.regpar = setDefault(opt, {'regpar'}, []);
info.options.regpar = ['Regularization parameter. For ridge regression, set '...
    'regpar to sqrt(eps) for mild regularization; leave regpar unset for ' ...
    'GCV selection of regularization parameters. For TTLS regression, '...
    'regpar must be set and is a fixed truncation parameter. '];

options.relvar_res = setDefault(opt, {'relvar_res'}, 5e-2);
info.options.relvar_res = ['Minimum relative variance of residuals. ' ... 
    'From the parameter OPTIONS.relvar_res, a lower bound for the regularization '...
    'parameter is constructed, in order to prevent GCV from erroneously choosing '...
    'too small a regularization parameter.'];


options.minvarfrac = setDefault(opt, {'minvarfrac'}, 0);
info.options.minvarfrac = ['Minimum fraction of total variation in standardized ' ...
    'variables that must be retained in the regularization. From the '...
    'parameter OPTIONS.minvarfrac, an approximate upper bound for the ' ...
    'regularization parameter is constructed. The default value OPTIONS.minvarfrac = 0 '...
    'essentially corresponds to no upper bound for the regularization parameter.'];


options.Xmis0 = setDefault(opt, {'Xmis0'}, []);
info.options.Xmis0 = ['Initial imputed values. Xmis0 is a (possibly sparse) '...
    'matrix of the same size as X with initial guesses in place of the NaNs in X.'];

options.C0 = setDefault(opt, {'C0'}, []);
info.options.C0 = ['Initial estimate of covariance matrix. If no initial ' ...
    'covariance matrix C0 is given but initial estimates Xmis0 of the ' ...
    'missing values are given, the sample covariance matrix of the dataset ' ...
    'completed with initial imputed values is taken as an initial estimate of the '...
    'covariance matrix.'];

options.Xcmp = setDefault(opt, {'Xcmp'}, []);
info.options.Xcmp = ['Display the weighted rms difference between the ' ...
    'imputed values and the values given in Xcmp, a matrix of the '...
    'same size as X but without missing values. By default, REGEM displays '...
    'the rms difference between the imputed values at consecutive iterations. The '...
    'option of displaying the difference between the imputed values and reference '...
    'values exists for testing purposes.'];

options.neigs = setDefault(opt, {'neigs'}, 50);
info.options.neigs = ['Number of eigenvalue-eigenvector pairs '...
    'to be computed for TTLS regression. By default, all nonzero eigenvalues and '...
    'corresponding eigenvectors are computed. By computing fewer (neigs) eigenvectors, '...
    'the computations can be accelerated, but the residual covariance matrices become '...
    'inaccurate. Consequently, the residual covariance matrices underestimate the '...
    'imputation error conditional covariance matrices more and more as neigs is decreased.'];

function val = setDefault(opt, field, default)

val = default;
for i = 1:numel(field),
    if (isfield(opt, field{i}))
        opt = opt.(field{i});        
    else
        return;
    end
end
val = opt;