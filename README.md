My inspiration for this project was "Fourier Transform of the Heart" by Rober Wills on YT: https://www.youtube.com/watch?v=ACvXAjZE9jQ&ab_channel=RobertWills - he created his in MatLab and I wanted to try it in Java.
I started by looking at the function for a heart (x^2 + y^2 -1)^3 = x^2*y^3. I then found the parameterization x(t) = 16sin^(t) and y(t) = 13cos(t) - 5cos(2t) - 2cos(3t) - cos(4t) on (0,2pi). 
I then found the Fourier coefficients using their formulas and created my references:
Fourier coefficients for x(t):
  double[] anX = {7.87e^-16, -4.12e^-16, -4.23e-15, -1.73e-15, 1.34e-15}
  double[] bnX = {12.0, 1.59e-16, -4.0, -3.5e-16, -7.77e-16}
Fourier coefficients for y(t):
  double[] anY = {13.0, -5.0, -2.0, -1.0, 4.24e-16}
  double[] bnY = {4.32e-16, 1.79e-15, -4.15e-15, 1.23e-15, 1.93e-15}


I started out making this in Eclipse with JavaFX lib but switched to Processing as it made more sense for me.
This was fun but tedious! 
