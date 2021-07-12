cvx_begin
    variable tau nonnegative
    variable x(N_antennas,1)
    minimize(tau)
    subject to
    
            x'*Diagrams <= [tau*ones(1,length(Indices_class_1)) ones(1,length(Indices_class_2)+length(Indices_class_3))];
            x'*Diagrams >= [-tau*ones(1,length(Indices_class_1)) -ones(1,length(Indices_class_2))  0.9*ones(1,length(Indices_class_3))];
       
cvx_end