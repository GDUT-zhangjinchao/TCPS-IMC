function  G = updateG(S,Q,E,omega1,omega2,omega3,v)
tpQ = 0;
tpE = 0;
for i = 1:v
    tpQ = tpQ+Q{i};
    tpE = tpE+E{i};
end
G = updateT(omega1*S+1/v*omega2*tpQ+omega3*tpE);

end