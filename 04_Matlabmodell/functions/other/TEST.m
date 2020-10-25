% Made up some pretend data
N = 1000;
A = randn(N);
% Preallocate memory for the pdfs
Y = zeros(N);
% Calculate the pdfs
for nr = 1:N
    Y(nr,:) = normpdf(A(nr,:),mean(A(nr,:)),std(A(nr,:)));
end