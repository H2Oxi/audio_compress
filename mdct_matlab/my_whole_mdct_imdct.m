% close all
%  clear all
% clc
% %
% %读取音频文件
% info =audioinfo('thesoundofsummer.mp3');%获取音频文件的信息
% [music1,Fs] = audioread('thesoundofsummer.mp3');%读取音频文件

% info =audioinfo('rzer.mp3');%获取音频文件的信息
% [audio,Fs] = audioread('rzer.mp3');%读取音频文件
% 
% music1 = 10^4*audio([1:1000000],1);

load music1
load Fs1

x0=music1;
N=512;
p=mod(length(x0),N/2);
x1=x0(1:length(x0)-p);
m=length(x1)/(N/2);
x=zeros(m-1,N);
for i=1:(length(x1)/(N/2)-1)
    x(i,:)=x1((N/2*(i-1)+1):N/2*(i+1));
end
X=zeros(m-1,N/2);
X_temp=zeros(m-1,N/2);
for i=1:(m-1)
    X_temp(i,:)=MDCT_new(x(i,:));
end
X_t2=fi(X_temp,1,16,-6);
X_t2_qt=mdct_qt(X_t2);

X=double(X_t2_qt);
x_IMDCT=zeros(m-1,N);


%imdct
for i=1:(m-1)
    x_IMDCT(i,:)=IMDCT_new(X(i,:));
end
x_fi=zeros(length(x1),1);
x_fi(1:N/2)=x_IMDCT(1,1:N/2);
for i=2:(m-1)
    x_fi(N/2*(i-1)+1:N/2*i)=x_IMDCT(i-1,N/2+1:N)+x_IMDCT(i,1:N/2);
end
x_fi(N/2*(m-1)+1:N/2*(m))=x_IMDCT((m-1),N/2+1:N);


figure(1)
plot(abs(x_fi/max(x_fi)-double(music1(1:length(x_fi)))/double(max(music1(1:length(x_fi))))))
figure(2)
plot(double(music1)/double(max(music1)))
figure(3)
plot(x_fi/max(x_fi))

sound(x_fi/max(x_fi),Fs1)

% a1=max(x_fi);
% x_fi_1=x_fi/a1;
% plot(x_fi_1);



function X_k=MDCT_new(X_i)
M    =   256; 
N    =   M*2;
t3=[];t4=[];t5=[];
X_in=double(X_i);
for k=0:M-1
%%k&n is reverted
    theta_k_0=(k+0.5)*pi/M;
    t3_reg=-cos((M+1)*theta_k_0/2)/(cos((M-1)*theta_k_0/2));
    t5_reg=-cos(((M-1)/2)*theta_k_0);
    for n=0:N-1
        j=n+1;
        if n<1
            P(j)=X_in(j);
        elseif n<2
            P(j)=X_in(j)+X_in(j-1)*(2*cos(theta_k_0)+t3_reg);
        else
            P(j)=X_in(j)+2*cos(theta_k_0)*P(j-1)+t3_reg*X_in(j-1)-P(j-2);
        end

    end
    t3=[t3,-(cos((M+1)*theta_k_0/2))/(cos((M-1)*theta_k_0/2))];
    t4=[t4,2*cos(theta_k_0)];
    t5=[t5,-cos(((M-1)/2)*theta_k_0)];
    X_k(k+1)=P(N)*t5_reg;

end
end


function X_k_ideal=MDCT_ideal(x_n_init)
M=256;
N=2*M;
X_k_ideal=[];
for k=0:M-1
    theta_k=(k+0.5)*pi/M;
    sum=0;
    for n=0:N-1
        
        sum=sum+x_n_init(N-1-n+1)*cos((n-(M-1)/2)*theta_k);
    end
    X_k_ideal(k+1)=-sum;

end

end

function X_t=IMDCT_new(X_f)
%X_f   =  sin((2*pi/M)*(0:M-1));
M    =   256; 
N    =   M*2;
t1=[];t2=[];
for n=0:N-1
    for k=0:M-1
        theta=(n+(M+1)/2)*pi/M;
        j=k+1;
        if k<1
            Q(j)=X_f(j);
        elseif k<2
            Q(j)=X_f(j)+X_f(j-1)*(1+2*cos(theta));
        else
            Q(j)=X_f(j)+2*cos(theta)*Q(j-1)+X_f(j-1)-Q(j-2);
        end

    end
    t1=[t1,2*cos(theta)];
    t2=[t2,(-1)^(n+M/2)*sin(theta/2)];
    X_t(n+1)=Q(M)*(-1)^(n+M/2)*sin(theta/2);


end

end

function X_k=MDCT_new_fix(X_i)
M    =   256; 
N    =   M*2;
t3=[];t4=[];t5=[];
X_in=fi(X_i,1,64,32);
for k=0:M-1
%%k&n is reverted
    theta_k_0=(k+0.5)*pi/M;
    t3_reg=-cos((M+1)*theta_k_0/2)/(cos((M-1)*theta_k_0/2));
    t5_reg=-cos(((M-1)/2)*theta_k_0);
    t3_reg_fix=fi(t3_reg,1,64,32);
    t4_reg_fix=fi(2*cos(theta_k_0),1,64,32);
    t5_reg_fix=fi(t5_reg,1,64,32);
    for n=0:N-1
        j=n+1;
        if n<1
            P(j)=X_in(j);
        elseif n<2
            P(j)=X_in(j)+X_in(j-1)*(t4_reg_fix+t3_reg_fix);
        else
            P(j)=X_in(j)+t4_reg_fix*P(j-1)+t3_reg_fix*X_in(j-1)-P(j-2);
        end

    end
    t3=[t3,t3_reg_fix];
    t4=[t4,t4_reg_fix];
    t5=[t5,t5_reg_fix];
    X_k(k+1)=P(N)*t5_reg_fix;

end
end

function X_t=IMDCT_new_fix(X_f_i)
%X_f   =  sin((2*pi/M)*(0:M-1));
M    =   256; 
N    =   M*2;
t1=[];t2=[];
X_f=fi(X_f_i,1,64,32);
for n=0:N-1
    theta=(n+(M+1)/2)*pi/M;  
    t1_reg=2*cos(theta);
    t2_reg=(-1)^(n+M/2)*sin(theta/2);
    t1_reg_fix=fi(t1_reg,1,64,32);
    t2_reg_fix=fi(t2_reg,1,64,32);
    for k=0:M-1
        
        j=k+1;
        if k<1
            Q(j)=X_f(j);
        elseif k<2
            Q(j)=X_f(j)+X_f(j-1)*(1+t1_reg_fix);
        else
            Q(j)=X_f(j)+t1_reg_fix*Q(j-1)+X_f(j-1)-Q(j-2);
        end

    end
    t1=[t1,t1_reg_fix];
    t2=[t2,t2_reg_fix];
    X_t(n+1)=Q(M)*t2_reg_fix;


end

end

