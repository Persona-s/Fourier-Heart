int nlim = 4; // Maximum Fourier coefficient
PVector[] z;
Complex[] coeff;
float[] t;
float tstep = 0.002 * TWO_PI;
float[] trange;

void setup() {
  size(1024, 768);
  noFill();
  strokeWeight(2);
  colorMode(HSB, 360, 100, 100);

  // Set up (x, y) data for a closed curve
  t = new float[int(TWO_PI / (PI / 32)) + 1];
  float[] x = new float[t.length];
  float[] y = new float[t.length];
  for (int i = 0; i < t.length; i++) {
    t[i] = i * (PI / 32);
    x[i] = 16 * pow(sin(t[i]), 3);
    y[i] = 13 * cos(t[i]) - 5 * cos(2 * t[i]) - 2 * cos(3 * t[i]) - cos(4 * t[i]);
  }

  // Centre, normalise, and flip the curve
  PVector mean = getMean(x, y);
  for (int i = 0; i < x.length; i++) {
    x[i] -= mean.x;
    y[i] -= mean.y;
  }
  float r = getMeanRadius(x, y);
  for (int i = 0; i < x.length; i++) {
    x[i] /= r;
    y[i] = -y[i] / r;
  }

  z = new PVector[x.length];
  for (int i = 0; i < z.length; i++) {
    z[i] = new PVector(x[i], y[i]);
  }

  // Evaluate Fourier coefficients
  coeff = new Complex[2 * nlim + 1];
  Complex tempComplex = new Complex(0, 0); // Temporary complex number for calculations
  for (int n = -nlim; n <= nlim; n++) {
    Complex sum = new Complex(0, 0);
    for (int i = 0; i < z.length - 1; i++) {
      Complex c = tempComplex.fromPolar(1, -n * t[i]);
      sum = sum.add(c.mult(new Complex(z[i].x, z[i].y)));
    }
    coeff[n + nlim] = sum.div(z.length - 1);
  }

  // Prepare the range of t values for animation
  trange = new float[int(TWO_PI / tstep) + 1];
  for (int i = 0; i < trange.length; i++) {
    trange[i] = i * tstep;
  }
}

void draw() {
  background(255);

  // Draw the curve and Fourier series
  drawCurve(z, color(200, 100, 100));
  drawFourier(color(100, 100, 200));
}

void drawCurve(PVector[] points, int col) {
  stroke(col);
  beginShape();
  for (PVector point : points) {
    vertex(point.x * 100 + width / 2, point.y * 100 + height / 2);
  }
  endShape();
}

void drawFourier(int col) {
  Complex tempComplex = new Complex(0, 0); // Temporary complex number for calculations
  Complex current = new Complex(0, 0);
  for (int n = -nlim; n <= nlim; n++) {
    Complex c = tempComplex.fromPolar(1, n * trange[frameCount % trange.length]);
    Complex next = current.add(coeff[n + nlim].mult(c));

    float radius = coeff[n + nlim].mag() * 100;
    noFill();
    stroke(map(n, -nlim, nlim, 0, 360), 100, 100, 50);
    ellipse(current.re * 100 + width / 2, current.im * 100 + height / 2, radius * 2, radius * 2);

    stroke(map(n, -nlim, nlim, 0, 360), 100, 100);
    line(current.re * 100 + width / 2, current.im * 100 + height / 2, next.re * 100 + width / 2, next.im * 100 + height / 2);

    current = next;
  }
}

PVector getMean(float[] x, float[] y) {
  float sumX = 0, sumY = 0;
  for (int i = 0; i < x.length; i++) {
    sumX += x[i];
    sumY += y[i];
  }
  return new PVector(sumX / x.length, sumY / y.length);
}

float getMeanRadius(float[] x, float[] y) {
  float sum = 0;
  for (int i = 0; i < x.length; i++) {
    sum += sqrt(x[i] * x[i] + y[i] * y[i]);
  }
  return sum / x.length;
}

class Complex {
  float re, im;

  Complex(float r, float i) {
    re = r;
    im = i;
  }

  // Non-static fromPolar method
  Complex fromPolar(float r, float theta) {
    return new Complex(r * cos(theta), r * sin(theta));
  }

  Complex add(Complex b) {
    return new Complex(re + b.re, im + b.im);
  }

  Complex mult(Complex b) {
    return new Complex(re * b.re - im * b.im, re * b.im + im * b.re);
  }

  Complex div(float b) {
    return new Complex(re / b, im / b);
  }

  float mag() {
    return sqrt(re * re + im * im);
  }
}
