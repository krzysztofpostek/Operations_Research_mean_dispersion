

cvx_begin
    variables u_left(N_antennas+1,N_grid_points) u_right(N_antennas+1,N_grid_points)
    variables v_left(N_antennas+1,N_grid_points) v_right(N_antennas+1,N_grid_points)
    variable tau
    variable x(N_antennas,1)
    minimize(tau)
    subject to
    
            u_right(1,:) + v_right(1,:) == x'*Diagrams + [repmat(-tau,[1 length(Indices_class_1)]) repmat(-1,[1 (length(Indices_class_2)+length(Indices_class_3))])];
            u_left(1,:) + v_left(1,:) == -x'*Diagrams + [repmat(-tau,[1 length(Indices_class_1)]) repmat(-1,[1 length(Indices_class_2)])  repmat(0.9,[1 length(Indices_class_3)])];
            
            u_right(2:N_antennas+1,:) + v_right(2:N_antennas+1,:) == repmat(error_size*x, [1 N_grid_points]).*Diagrams;
            u_left(2:N_antennas+1,:) + v_left(2:N_antennas+1,:) == -repmat(error_size*x, [1 N_grid_points]).*Diagrams;
            
            u_right(1,:) + sum(abs(u_right(2:N_antennas+1,:)),1) <= zeros(1,N_grid_points);
            u_left(1,:) + sum(abs(u_left(2:N_antennas+1,:)),1) <= zeros(1,N_grid_points);
            
            v_right(1,:) + sqrt(2*log(1/epsilon))*norms(v_right(2:N_antennas+1,:).*repmat(omega,[1 N_grid_points]),2,1) <= zeros(1,N_grid_points);
            v_left(1,:) + sqrt(2*log(1/epsilon))*norms(v_left(2:N_antennas+1,:).*repmat(omega,[1 N_grid_points]),2,1) <= zeros(1,N_grid_points);
cvx_end