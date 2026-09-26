function Q = updateQ(Z,S,Q,E,G,D,Y_2,Y_3,mu,omega1,omega2,omega3,v,K)
tpQ = 0;
tpE = 0;
for i = 1:v
    tpQ = tpQ+Q{i};
    tpE = tpE+E{i};
end

[q,n] = size(S);
for i = 1:v
    for iq = 1:q
        for in = 1:n
            Q{i}(iq,in)= (2*K{i}(iq,in).*omega2*(G(iq,in)-(omega1*S(iq,in)+omega2*1/(v-1)*(tpQ(iq,in)-Q{i}(iq,in))+omega3*(tpE(iq,in)))) ...
            +omega2*(mu*(Z{i}(iq,in)-omega1*S(iq,in)-omega3*E{i}(iq,in))+Y_2{i}(iq,in)) ...
            +(mu*D{i}(iq,in)-Y_3{i}(iq,in))) ...
            /(2*K{i}(iq,in)^2*omega2^2+mu*(omega2^2+1));
        end
    end
    Q{i} = updateT(Q{i});
end

