clear all
close all
A=[1 1 1 0 0 0 0 0 0;
   0 0 0 8 4 2 0 0 0;
   0 0 0 0 0 0 27 9 3;
   3 2 1 0 0 -1 0 0 0;
   0 0 0 12 4 1 0 0 -1;
   6 2 0 0 -2 0 0 0 0;
   0 0 0 12 2 0 0 -3 0;
   6 2 0 0 0 0 0 0 0;
   0 0 0 0 0 0 0 3 0;];

x = [0,1,3,6];
y = [7,10,3,0];


b=[3 - 7 -3 0 0 0 0 0 0]'
p = A\b;
a_1 = p(1);
b_1 = p(2);
c_1 = p(3);

a_2 = p(4); 
b_2 = p(5);
c_2 = p(6);

a_3 = p(7);
b_3 = p(8);
c_3 = p(9);

x1 = linspace(0,1,500);
x2 = linspace(1,2,500);
x3 = linspace(1,2,500);

f_1 = a_1*x1.^3 + b_1*x1.^2 + c_1*x1 + 7;
f_2 = a_2*(x2-1).^3 + b_2*(x2-1).^2 + c_2*(x2-1) + 10;
f_3 = a_3*(x3-3).^3 + b_3*(x3-3).^2 + c_3*(x3-3) + 3;

figure
plot(x,y,'.r','Markersize',20);
hold on
plot(x1,f_1, 'linewidth',2);
hold on
plot(x2, f_2, 'linewidth',2);
hold on
plot(x3, f_3, 'linewidth',2)
set(gca, 'FontName','times','FontSize',14); %set the numbers on the axis to font Times New Roman of size 14
xlabel('$x$','FontSize',14,'Interpreter','Latex');
ylabel('$y$','FontSize',14,'Interpreter','Latex');



