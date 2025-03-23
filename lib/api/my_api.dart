// Superclass (or interface) defining a common type
abstract class Shape {
  double area(); // Abstract method (no implementation in the superclass)
  void display() {
    print("This is a shape.");
  }
}

// Subclass Circle
class Circle implements Shape {
  double radius;

  Circle(this.radius);

  @override
  double area() {
    return 3.14 * radius * radius;
  }

  @override
  void display() {
    print("This is a circle with radius $radius.");
  }
}

// Subclass Rectangle
class Rectangle implements Shape {
  double width;
  double height;

  Rectangle(this.width, this.height);

  @override
  double area() {
    return width * height;
  }

  @override
  void display() {
    print("This is a rectangle with width $width and height $height.");
  }
}

void main() {
  List<Shape> shapes = [
    Circle(5.0),
    Rectangle(4.0, 6.0),
    Circle(2.5),
  ];

  for (var shape in shapes) {
    shape.display(); // Polymorphic call: calls the correct display() based on the object's type
    print("Area: ${shape.area()}\n"); //Polymorphic call: Calls the correct area() method based on the object's type.
  }

  // Example using a single reference and changing the type
  Shape myShape = Circle(3.0);
  myShape.display();
  print('Area: ${myShape.area()}');

  myShape = Rectangle(10,5);
  myShape.display();
  print('Area: ${myShape.area()}');

}