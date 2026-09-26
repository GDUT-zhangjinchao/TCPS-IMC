function E = updateE(Z,S,Q,E,G,Y_2,gamma,mu,omega1,omega2,omega3,v)
tpQ = 0;
tpE = 0;
for i = 1:v
    tpQ = tpQ+Q{i};
    tpE = tpE+E{i};
end
for i = 1 : v
    E{i} = updateT( ...
        (2*omega3*(G-(omega1*S+omega2*1/(v)*(tpQ)+omega3*(tpE-E{i}))) ...
        +omega3*(mu*(Z{i}-omega1*S-omega2*Q{i})+Y_2{i})) ...
        ./(2*omega3^2+mu*(omega3^2)+2*gamma));
end
end
