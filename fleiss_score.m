% Calculate Fleiss Score
% Syntax: 	fleiss_score(X, alpha)
%      
%     Inputs:
%           X - square data matrix
%           alpha = Confidence Level
%     Outputs:
%           - Overall Fleiss Kappa value (score)
%           - Percent Overall Agreement (p_bar)
%           - Kappa standard error
%           - Kappa confidence interval
%           - Kappa benchmarks by Landis and Koch 
%           - z test & P Value

function [kappa, std_error, ci, z, p] = fleiss_score(x, alpha)
%check if the raters are the same for each rows
r=sum(x,2);
if any(r-max(r))
    error('The raters are not the same for each rows')
end

N=size(x,1); %frames
n=sum(x(1,:)); %raters
a=n*N; %Sum of all cells

%Calculate pj & pe_bar
pj=(sum(x)./(a));  
pe_bar = sum(pj.^2);

%Calculate Pi & p_bar
pi = (sum(x.^2,2) - n)./(n*(n-1));
p_bar = sum(pi)./N;
kappa = (p_bar - pe_bar)./(1-pe_bar);

%Standard Error Calculator
qj = 1 - pj;
t = sum(pj.*qj);
std_error = realsqrt(2*(t^2 - sum(pj.*qj.*(1-2.*pj))))/(t*(realsqrt(N*n*(n-1))));

%Confidence Interval
%ci = k +- z((1-alpha)/2)*std_error)
ci =kappa + ([-1 1].*(abs(normcdf(alpha))*std_error)); 

%Hypothesis Testing 
z = kappa/std_error;
p=(1-normcdf(abs(z)))*2;

%Display Results
fprintf('Percent Overall Agreement: %0.4f\n%p_bar', p_bar); 
fprintf('Overall Fleiss Kappa Score: %0.4f\n', kappa);

if kappa<0
    cprintf('Red');
    fprintf('Poor agreement by Landis & Koch(1997)\n\n');
elseif kappa>=0 && kappa<=0.2
    fprintf('Slight agreement by Landis & Koch(1997)\n\n');
elseif kappa>0.2 && kappa<=0.4
    fprintf('Fair agreement by Landis & Koch(1997)\n\n');
elseif kappa>0.4 && kappa<=0.6
    fprintf('Moderate agreement by Landis & Koch(1997)\n\n');
elseif kappa>0.6 && kappa<=0.8
    fprintf('Substantial agreement by Landis & Koch(1997)\n\n');
elseif kappa>0.8 && kappa<=1
    fprintf('Perfect agreement by Landis & Koch(1997)\n\n');
end
T=table(kappa,std_error,ci,z,p,'VariableNames',{'Fleiss_Kappa', 'Std_Error', 'Confidence_Interval','z','p_value'});
disp(T)
if p<alpha
    disp('Reject null hypotesis: Observed agreement is not accidental')
else
    disp('Accept null hypotesis: Observed agreement is accidental')
end
end
