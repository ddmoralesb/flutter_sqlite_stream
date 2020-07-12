class Person{
  int id;
  String name;
  int age;
  Person parent;

  Person({
    this.id,
    this.name,
    this.age
  });

  @override
  String toString(){
    return this.name;
  }

  factory Person.fromJson(Map<String, dynamic> json) => new Person(
    id: json["id"],
    name: json["name"],
    age: json["age"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "age": age,
  };
}