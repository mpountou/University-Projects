function boctor( w_z, w_o, Q, R_4, C)
%BOCTORHIGHPASS Create a Boctor High Pass Filter
%   
%   This function takes as input arguments omega_z (w_z), omega_o (w_o) and
%   the Q factor of the filter. The input arguments R_4 and C are optional.
%   The function then asks the user to specify a value for the capacitors. 
%   The algorithm returns the real (not the normalized) parameters of the
%   circuit.  If a maximum number of recursions is reached, try to use a
%   different value for H and/or initial value for R_4.
%
%   Example of usage: BoctorHighPass (1000, 2000, 0.5)
%   User input : C = 10^-6

if (1/Q <= 1 - w_z^2 / w_o ^2 )
    error('A Boctor HPN cannot be defined. You should use a High Pass Notch (Fig. 7.21).');
end

if (w_z >= w_o)
    error('w_z should be < w_o.');
end

H = 2;

if nargin == 3
    R_4 = 2000;
    C = input('Select a value for the capacitors : ');
end

C_1 = C;
C_2 = C;

R_5 = (H-1) * R_4;
R_45 = (R_4*R_5)/ (R_4 + R_5);

a = w_z ^2 * C^2;
b = C^2 * w_o ^ 2 - a;
c = (a+b) * R_45 / a;
d = R_5 - c * H;
e = b * c - C * w_o / Q;
f = 1 - c / R_45;

beta = R_45 - e * R_5 / (d * a);
c = 1/a - C * w_o * R_45/ (Q * a) - R_45 * (R_45 - beta) - f * R_5 / (d * a);

p = [1 beta c];

r = roots(p);
if r(1) > 0 && isreal(r(1))
    R_2 = r(1);
elseif r(2) > 0 && isreal(r(2))
    R_2 = r(2);
else
    BoctorHighPass (w_z, w_o, Q, R_4 + 5, C)
    return;
end

R_1 = 1 / (a * R_2);
R_3 = d / (e * R_2 + f);
R_6 = R_1 * R_3 * R_45 / ( R_3 * (R_1+R_2) - R_1 * R_45);

results = struct ('R_1', R_1, 'R_2', R_2, 'R_3', R_3, 'R_4', R_4, 'R_5', R_5, 'R_6', R_6, 'C_1', C_1, 'C_2', C_2, 'H', H);
assignin('base', 'circuit', results);

disp('The results of the script are in the workspace, under than name circuit');
disp('If any of the resistors have an extremely low value, consider running the analysis with different parameters (e.g. different R_4)');
end