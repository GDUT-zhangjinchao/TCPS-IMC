function S = updateS(Z,Q,E,G,Y_2,mu,omega1,omega2,omega3,v)
land7 = 0;
tpQ = 0;
tpE = 0;
for i = 1:v
    land7 = land7+mu*(Z{i}-omega2*Q{i}-omega3*E{i})+Y_2{i};
        tpQ = tpQ+Q{i};
    tpE = tpE+E{i};
end
land6 = G-1/v*omega2*tpQ+omega3*tpE;
S = updateT( ...
    (2*omega1*land6+omega1*land7) ...
    ./(2*omega1^2+mu*v*omega1^2));
end