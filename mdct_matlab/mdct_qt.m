function X_t3=mdct_qt(X_t2)


X_t2_d=double(X_t2)/64;
[w l]=size(X_t2_d);

y=X_t2_d(:)';

m1=max(y);
y=y/m1;

bit=4;

%% define r.v. Y

% info =audioinfo('rzer.mp3');%获取音频文件的信息
% [audio,Fs] = audioread('rzer.mp3');%读取音频文件
% 
% y = audio(:,1)';
% % x=1:samples;
% % y=4*cos(x);
% % x=1:samples;
% % y=cos(x);
% 

%% Lloyd-Max Algorithm
boundaries = [linspace(-log(2.6),-0.35,0.25*2^bit), linspace(-0.3,0.3,0.5*2^bit+1), linspace(0.35,log(2.6),0.25*2^bit)];
reconstruction = zeros(1,2^bit);
mse_prev = 1;
mse_new = 1;

while (1)
    [hist_values, edges] = histcounts(y,1000);
    %define the reconstruction levels
    for x = 1:2^bit
        total_data_num = 0;
        expectation_t = 0;
        i = 1;
        while (true)
            temp_num = (edges(i)+edges(i+1))/2;
            if ( temp_num >= boundaries(x) && temp_num < boundaries(x+1)  )
                total_data_num = total_data_num + hist_values(i);
                expectation_t = expectation_t + hist_values(i)*temp_num;
                if i < 1000
                    i = i + 1;
                else
                    break;
                end
            else
                if total_data_num == 0 && i < 1000
                    i = i + 1;
                    continue;
                else
                    break;
                end
            end
        end
        reconstruction(x) = expectation_t/total_data_num;
    end
    %define new boundaries
    for x = 1:2^bit-1
        boundaries(x+1) = (1/2)*(reconstruction(x) + reconstruction(x+1));
    end
    %check new error 
    y_nonuni_quantized = quantize_nonuniform(y, boundaries, reconstruction,bit);
    err_nonuni = y - y_nonuni_quantized;
    mse_new = calculate_pow(err_nonuni);
    %finishing condition (no more than %0.01 improvement on err)
    if( abs((mse_new-mse_prev)/mse_new) <= 0.0001)
        break;
    end
    mse_prev = mse_new;
end


y_o = X_t2_d(:)'/m1;
y_qt=zeros(1,length(y_o));

%% 一维
for k=1:length(y)
    if y_o(k)>boundaries(end)
        y_qt(k)=boundaries(end)+(boundaries(end)-boundaries(end-1) )/2;
    elseif y_o(k)<=boundaries(1)
         y_qt(k)=boundaries(1)-(boundaries(1)-boundaries(2) )/2;
    else

        for j=1:length(boundaries)-1
          if y_o(k)>=boundaries(j) && y_o(k)<boundaries(j+1)
              y_qt(k)=(boundaries(j)+boundaries(j+1) )/2;
          end
        end
    end

end

y_qt=y_qt';
X_t3=reshape(y_qt,[w,l]);

X_t3=m1*X_t3;
X_t3=fi(X_t3,1,16,-6);


%% function for calculating power
function powerr = calculate_pow(fnc_in)
    [hist_values_e, edges] = histcounts(fnc_in,1000,'Normalization','pdf');
    total_e = 0;
    i = 0;
    x = linspace(min(edges), max(edges), 1000);
    width = x(2) - x(1);
    for k = x
        i = i + 1;
        total_e = total_e + (k^2)*width*hist_values_e(i);
    end
    powerr = total_e;
end

%% function for non-uniform quantization
function y_quantized = quantize_nonuniform(y, boundaries, reconstruction,bit)
    y_quantized = zeros(1,length(y));
    for x = 1:length(y)
        for i = 1:2^bit
            if (y(x) >= boundaries(i) && y(x) < boundaries(i+1) )
                y_quantized(x) = reconstruction(i);
                break;
            end
        end
    end
    return;
end

%% function for uniform quantization
function y_uni_quantized = quantize_uniform(y, y_max, y_min, level)
    uni_q_delt = (y_max-y_min)/level;
    y_uni_quantized = zeros(1, length(y));
    for x = 1:length(y)
        which_width = fix((y(x)+y_max)/uni_q_delt);
        quantized_value = y_min + (uni_q_delt/2) + which_width*uni_q_delt;
        y_uni_quantized(x) = quantized_value;
    end
    return;
end
 
end
