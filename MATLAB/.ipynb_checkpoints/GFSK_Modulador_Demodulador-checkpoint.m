
x = input('Ingrese la trma de bits para modular = '); % [1 0 0 1 0 0 1 1 1 1 0 0 0 1 1 1 0]
                                                      % [0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0]
                                                      % [1 1 1 1 0 0 1 1 1 0 0 1 0 1 0 1 1]
                                                      % [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0]
                                                      % [0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0]
                                                     
tic; % empezando a medir el tiempo

N = length(x); % mido la distnAm_carrieria dle mensaje
Tb = 1; % tiempo de bit
nb = 150; % numero the muestras por bit

digit = []; 
for n = 1:1:N
    if x(n) == 1
       sig = ones(1,nb); %relleno con 1s
    else
        sig = zeros(1,nb); %relleno con 0s
    end
     digit = [digit sig]; %aqui esta la señal
end

t1 = Tb/nb:Tb/nb:nb*N*(Tb/nb);   %calculo el tiempo para mostrar la señal
figure('Name','ModulAm_carrierion GFSK','NumberTitle','off'); 
subplot(3,1,1); 
plot(t1,digit,'LineWidth',2.5);
grid on;
axis([0 Tb*N -0.5 1.5]);
xlabel('Tiempo[s]');
ylabel('Amplitud [V]');
title('Señal de entrada');


% **************************** ModulAm_carrierion FSK

Am_carrier = 10;         %Amplitud del carrier  
Brate = 1/Tb;            %Bit rate
Frec_c_1 = Brate*10;     %Frecuencia del Carrier para entrada '1'
Frec_c_2 = Brate*5;      %Frecuencia del Carrier para entrada '0'
t2 = Tb/nb:Tb/nb:Tb;     %señal del tiempo   

mod = [];
for i = 1:1:N
    if (x(i) == 1)
        y = Am_carrier*cos(2*pi*Frec_c_1*t2);   %Modulation signal with carrier signal 1
    else
        y = Am_carrier*cos(2*pi*Frec_c_2*t2);   %Modulation signal with carrier signal 2
    end
    mod = [mod y]; %Señal modulada
end
% Filtrado Gaussiano  *****************************
gaussian_filter = fspecial('gaussian',[1 100],1);

gfsk = conv(mod,gaussian_filter);

subplot(3,1,2);
plot(gfsk);
xlabel('Tiempo[s]');
ylabel('Amplitud [V]');
title('Señal Modulada por GFSK'); %señal modulada por Gaussian FSK

% *************************** GFSK Demodulation
x = mod;

h = 5;   % ATENUAm_carrierION DE LA SENAL 
w = 7;   % RUIDO
% SENAL RECIBIDA *********************************

y = h.*x + w;   % Convolucion
s = length(t2);
demod = [];
for n = s:s:length(y)
  t4 = Tb/nb:Tb/nb:Tb;        
  c1 = cos(2*pi*Frec_c_1*t4);      % Senal del carrier para un 1 binario
  c2 = cos(2*pi*Frec_c_2*t4);      % Senal del carrier para un o binario
  mc1 = c1.*y((n-(s-1)):n);   % Convolucion 
  mc2 = c2.*y((n-(s-1)):n);   % Convolucion 
  t5 = Tb/nb:Tb/nb:Tb;
  z1 = trapz(t5,mc1);         % IntregAm_carrierion 
  z2 = trapz(t5,mc2);         % IntregAm_carrierion 
  rz1 = round(2*z1/Tb);
  rz2 = round(2*z2/Tb);
  if(rz1 > Am_carrier/2)              % condiciones logicas
    a = 1;
  else
    a = 0;
  end
  demod = [demod a];
end

% ********** RepresentAm_carrierion demodulada de la informAm_carrierion como una senal digital **d********
digit = [];
for n = 1:length(demod)
    if demod(n) == 1
       sig = ones(1,nb);
    else
        sig = zeros(1,nb);
    end
     digit = [digit sig];
end
t5 = Tb/nb:Tb/nb:nb*length(demod)*(Tb/nb);   % Time period
subplot(3,1,3)
plot(t5,digit,'LineWidth',2.5);grid on;
axis([0 Tb*length(demod) -0.5 1.5]);
xlabel('Tiempo[s]');
ylabel('Amplitud [V]');
title('Senal demodulada por GFSK');
tiempo_exe = toc;
fprintf('Tiempo total de ejecución: %.4f segundos\n', tiempo_exe);