function rmse = Practica2(kf)  

    %Datos obtenidos experimentalmente
    bd = importdata("bdPractica2.mat"); %se importan las bases de datos
    V = bd.prom; %vector voltage promedio de la base de datos curada
    
    % Se aplica un filtro para elimiar ruido
    alpha = 0.3;
    vf = 0;
    
    for i = 1:length(V)
        vf = (alpha*V(i) + (1 - alpha)*vf);
        Vf(i) = vf;
    end
    
    %Ahora, debemos acomodar nuestra base de datos, 
    %hay que recortarla para que inicie en el punto máximo y no en 0
    [~,index] = max(Vf); %valor maximo de la base de datos
    Vbits = round(Vf(index:end)); %"desplazamiento" y redondeo de los datos en resolución de bits 
    time = bd.time(1:length(Vbits)); %vector de tiempo
    
    %Conversión de bits a grados
    theta = ((Vbits*90)/Vbits(end)) - 90;

    %conversión de grados a radianes
    theta_r = deg2rad(theta);
    
    %Datos obtenidos numericamente
    %Parámetros
    h = 1e-3;
    tfin = length(theta_r)*h;
    N = ceil((tfin-h)/h);
    t = h + (0:N)*h;
    m = 0.135; %masa vara + bolita
    l = 0.398; %longitud
    g = 9.81; %gravedad
    kf = 0.67;
        
    %Condiciones iniciales
    theta1_0 = max(theta_r);
    theta2_0 = 0;
    
    %Método de Euler para resoluación de la EDO
    theta1 = [theta1_0 zeros(1,N-1)];
    theta2 = [theta2_0 zeros(1,N-1)];
    
    for n = 1 : N
        theta1(n+1) = theta1(n) + h*(theta2(n));
        theta2(n+1) = theta2(n) + h*((-g/l)*sin(theta1(n)) - (kf/m)*theta2(n));
    end

    rmse = sqrt(mean((theta_r - theta1).^2));

    plot(time, theta_r, 'DisplayName','Experimentales')
    title('Datos experimentales vs simulados')
    xlabel('tiempo') 
    ylabel('radianes')
    hold on
    plot(t, theta1, 'DisplayName','Simulados')
    hold off
    lgd = legend
 end
