function qdot = dequations(T,q,u,L,mp,mc,b,Mode)

%Define some parameters that we can use in our differential equations:
mt = mp+mc;
g = 9.81;
t = q(1);
w = q(2);
x = q(3);
v = q(4);
st = sin(t);
ct = cos(t);

switch Mode
    
    case 'Force'
        F = u;
        qdot(1,1) = w;
        qdot(2,1) = ((F.*ct) + (((ct.^2) - (mt./mp))*b*w) - (mp*L*(w^2)*st*ct) + (mt*g*st))./((mt*L) - (mp*L*(ct^2)));
        qdot(3,1) = v;
        qdot(4,1) = (F + (mp*g*st*ct) - (mp*(w^2)*L*st))./(mt - (mp*(ct^2)));     
    
    case 'Velocity'
        A = u;
        qdot(1, 1) = w;
        qdot(2, 1) = ((g*st) - ((b*w)/mp) + (ct * A))/L;
        qdot(3, 1) = v;
        qdot(4, 1) = A;
        
    case 'Acceleration' %these equations are actually for acceleration control, but the mode
        %for the pendulum class says velocity, and we just differentiate.
        A = u;
        qdot(1,1) = w;
        qdot(2,1) = (A*ct + g*st - ((1/mp)*b*w))/L;
        qdot(3,1) = v;
        qdot(4,1) = A; 
end


